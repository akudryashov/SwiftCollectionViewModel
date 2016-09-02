//
//  ViewController.swift
//  CollectionViewModel
//
//  Created by Антон Кудряшов on 24/08/16.
//  Copyright © 2016 Anton Kudryashov. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, AKSectionsChangeHandler {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewControllerViewModel()
    }
    
    var viewModel : ViewControllerViewModel? {
        didSet {
            viewModel?.changeHandler = self
        }
    }
    func handleChange(change: AKUIChange) {
        tableView.updateWith(change)
    }
    
    // UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let count = viewModel?.numberOfElements() {
            return count
        }
        return 0
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = viewModel?.elementAtIndex(section) {
            return section.numberOfElements()
        }
        return 0
    }
    
    //dummy method for testing. Cell is created in storyboard
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL")!
        if let section = viewModel?.elementAtIndex(indexPath.section) {
            if let cellViewModel = section.elementAtIndex(indexPath.item) as? CellViewModel {
                 cell.textLabel?.text = cellViewModel.title
            }
        }
        return cell
    }
    
    //Test actions
    @IBAction func addAction(sender: AnyObject) {
        viewModel?.loadSomething()
    }
    
    @IBAction func removeAction(sender: AnyObject) {
        viewModel?.deleteSection()
    }
    
    @IBAction func replaceAction(sender: AnyObject) {
        viewModel?.replace()
    }
    
}

