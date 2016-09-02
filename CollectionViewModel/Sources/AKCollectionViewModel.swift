//
//  AKCollectionViewModel.swift
//  CollectionViewModel
//
//  Created by Антон Кудряшов on 24/08/16.
//  Copyright © 2016 Anton Kudryashov. All rights reserved.
//

import Foundation

public class AKElementViewModel {
    //stub base class for element view models
    public init() {}
}

enum AKCollectionChange <ElementType : AKElementViewModel> {
    case Insert(element: ElementType, index: Int)
    case Delete(element: ElementType)
    case Replace(element: ElementType, newElement: ElementType)
    case Reload()
    //TODO, this is collection of changes. not implemented yet
    //case Batch(changes: [AKCollectionChange<ElementType>])
}

public class AKCollectionViewModel<ElementType : AKElementViewModel> : AKElementViewModel {
    
    public init(elements: [ElementType]) {
        collection = elements
        super.init()
    }
    
    //container
    private var collection = [ElementType]()
    
    func numberOfElements() -> Int {
        return collection.count
    }
    
    func elementAtIndex(index: Int) -> ElementType? {
        return index < numberOfElements() ? collection[index] : nil
    }
    
    func indexForElement(element: ElementType) -> Int? {
        if let index = collection.indexOf({ return $0 === element}) {
            return index
        }
        return nil
    }
    
    // containter private interface for changes
    private func applyChange(change: AKCollectionChange<ElementType>) {
        print("super change \(change)")
        switch change {
        case .Insert(let element, let index):
            if index > -1 {
                if index < numberOfElements() {
                    collection.insert(element, atIndex: index)
                }
                else {
                    collection.append(element)
                }
            }
            else {
                assert(false, "index \(index) is not valid")
            }
            break
        case .Delete(let element):
            if let index = indexForElement(element) {
                collection.removeAtIndex(index)
            }
            else {
                assert(false, "element \(element) out of collection \(self)")
            }
            break
        case .Replace(let element, let newElement):
            if let index = indexForElement(element) {
                collection[index] = newElement
            }
            else {
                assert(false, "element \(element) out of collection \(self)")
            }
            break
        default:
            break
        }
    }
}

// Special changes associated with SectionsViewModel
enum AKSectionChange<ElementType : AKElementViewModel> {
    case SectionChange(AKCollectionChange<AKCollectionViewModel<ElementType>>)
    case ElementChange(elementChange: AKCollectionChange<ElementType>, sectionIndex: Int)
}

//see AKUIChange.swift for UI changes implementation

protocol AKSectionsChangeHandler : NSObjectProtocol {
    func handleChange(change: AKUIChange)
}

public class AKSectionsViewModel<ElementType : AKElementViewModel>: AKCollectionViewModel<AKCollectionViewModel<ElementType>> {
    
    public override init(elements: [AKCollectionViewModel<ElementType>]) {
        super.init(elements: elements)
    }
    
    weak var changeHandler : AKSectionsChangeHandler? {
        didSet {
            //reload data in handler
            changeHandler?.handleChange(AKUIChange.ReloadData())
        }
    }
    
    func performChange(change: AKSectionChange<ElementType>) {
        var uiChange : AKUIChange?
        switch change {
        case .SectionChange(let subChange):
            // map section change to UI change
            switch subChange {
            case .Insert(_, let index):
                applyChange(subChange)
                uiChange = AKUIChange.InsertSections(indexSet: NSIndexSet.init(index: index))
                break
            case .Delete(let section):
                if let index = indexForElement(section) {
                    uiChange = AKUIChange.DeleteSections(indexSet: NSIndexSet.init(index: index))
                    //it's necessary to find and then delete
                    applyChange(subChange)
                }
                else {
                    assert(false, "There is no section \(section). And it can't be deleted")
                }
                break
            case .Replace(_, let section): //after applying we have new one
                applyChange(subChange)
                if let index = indexForElement(section) {
                    uiChange = AKUIChange.ReloadSections(indexSet: NSIndexSet.init(index: index))
                }
                else {
                    assert(false, "There is no section \(section). And it can't be replaced")
                }
                break
            case .Reload():
                applyChange(subChange)
                uiChange = AKUIChange.ReloadData()
                break
            }
            break
        case .ElementChange(let elementChange, let sectionIndex):
            if let section = elementAtIndex(sectionIndex) {
                // map section's change for Rows to UI change
                switch elementChange {
                case .Insert(_, let index):
                    section.applyChange(elementChange)
                    uiChange = AKUIChange.InsertRows(indexPathSet: [NSIndexPath.init(forItem: index, inSection: sectionIndex)])
                    break
                case .Delete(let element):
                    if let index = section.indexForElement(element) {
                        uiChange = AKUIChange.DeleteRows(indexPathSet: [NSIndexPath.init(forItem: index, inSection: sectionIndex)])
                        section.applyChange(elementChange)
                    }
                    else {
                        assert(false, "There is no such element in section at index \(sectionIndex). And it can't be deleted")
                    }
                    break
                case .Replace(_, let element):
                    if let index = section.indexForElement(element) {
                        section.applyChange(elementChange)
                        uiChange = AKUIChange.ReloadRows(indexPathSet: [NSIndexPath.init(forItem: index, inSection: sectionIndex)])
                    }
                    else {
                        assert(false, "There is no such element in section at index \(sectionIndex). And it can't be replaced")
                    }
                    break
                case .Reload():
                    uiChange = AKUIChange.ReloadSections(indexSet: NSIndexSet.init(index: sectionIndex))
                    break
                }
                break
            }
            else {
                assert(false, "there is no section with index: \(sectionIndex)")
            }
        }
        
        if uiChange != nil {
            // send UI change for handler
            changeHandler?.handleChange(uiChange!)
        }
    }
}