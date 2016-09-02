//
//  ViewControllerViewModel.swift
//  CollectionViewModel
//
//  Created by Антон Кудряшов on 02/09/16.
//  Copyright © 2016 Anton Kudryashov. All rights reserved.
//

class ViewControllerViewModel: AKSectionsViewModel<AKElementViewModel> {
    
    init() {
        let element = CellViewModel()
        element.title = "New"
        super.init(elements: [AKCollectionViewModel.init(elements: [element])])
    }
    
    func loadSomething() {
        let element = CellViewModel()
        element.title = "loaded"
        let section = AKCollectionViewModel.init(elements: [element])
        self.performChange(AKSectionChange.SectionChange(AKCollectionChange.Insert(element: section, index: 0)))
    }
    
    func deleteSection() {
        if let section = elementAtIndex(0) {
            self.performChange(AKSectionChange.SectionChange(AKCollectionChange.Delete(element: section)))
        }
    }
    
    func replace() {
        if let section = elementAtIndex(0) {
            let element = CellViewModel()
            element.title = "replaced"
            let newSection = AKCollectionViewModel.init(elements: [element, element, element, element, element])
            self.performChange(AKSectionChange.SectionChange(AKCollectionChange.Replace(element: section, newElement: newSection)))
        }
    }
    
}
