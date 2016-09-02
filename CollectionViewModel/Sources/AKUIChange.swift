//
//  AKUIChange.swift
//  CollectionViewModel
//
//  Created by Антон Кудряшов on 02/09/16.
//  Copyright © 2016 Anton Kudryashov. All rights reserved.
//

import Foundation
import UIKit

enum AKUIChange {
    case InsertRows(indexPathSet: [NSIndexPath])
    case DeleteRows(indexPathSet: [NSIndexPath])
    case ReloadRows(indexPathSet: [NSIndexPath])
    case InsertSections(indexSet: NSIndexSet)
    case DeleteSections(indexSet: NSIndexSet)
    case ReloadSections(indexSet: NSIndexSet)
    case ReloadData()
}

// ui change extensions

// for UITableView
extension UITableView {
    func updateWith(change: AKUIChange) {
        switch change {
        case .InsertRows(let indexPaths):
            self.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            break
        case .DeleteRows(let indexPaths):
            self.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            break
        case .ReloadRows(let indexPaths):
            self.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            break
        case .InsertSections(let indexSet):
            self.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            break
        case .DeleteSections(let indexSet):
            self.deleteSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            break
        case .ReloadSections(let indexSet):
            self.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            break
        case .ReloadData():
            self.reloadData()
            break
        }
    }
}

// for UICollectionView
extension UICollectionView {
    func updateWith(change: AKUIChange) {
        switch change {
        case .InsertRows(let indexPaths):
            self.insertItemsAtIndexPaths(indexPaths)
            break
        case .DeleteRows(let indexPaths):
            self.deleteItemsAtIndexPaths(indexPaths)
            break
        case .ReloadRows(let indexPaths):
            self.reloadItemsAtIndexPaths(indexPaths)
            break
        case .InsertSections(let indexSet):
            self.insertSections(indexSet)
            break
        case .DeleteSections(let indexSet):
            self.deleteSections(indexSet)
            break
        case .ReloadSections(let indexSet):
            self.reloadSections(indexSet)
            break
        case .ReloadData():
            self.reloadData()
            break
        }
    }
}
