//
//  PreviousMealsAddViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 2/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class PreviousMealsAddViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate {
    
    // MARK: - Local Constants
    
    private struct Identifiers {
        static let Title = "Add Food"
        static let AddButtonText = "Add"
        static let CancelButtonText = "Cancel"
        static let addToDiaryButtonPressed = "addToDiaryButtonPressed:"
        static let cancelButtonPressed = "cancelButtonPressed:"
        static let Cell = "PastMealEntryCell"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var previousEntriesTableView: UITableView! {
        didSet {
            previousEntriesTableView.dataSource = self
            previousEntriesTableView.delegate = self
            previousEntriesTableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    
    // MARK: - Instance Variables
    
    var previousUserMeal: UserMeal!
    
    
    // MARK: - UI Setup
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateUI()
    }
    
    func setupViews() {
        // Set navigation title
        self.navigationItem.title = Identifiers.Title
        
        // Add button on right side of navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Identifiers.AddButtonText, style: .Done, target: self, action: NSSelectorFromString(Identifiers.addToDiaryButtonPressed))
        
        // Cancel button on left side of navigation bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Identifiers.CancelButtonText, style: .Done, target: self, action: NSSelectorFromString(Identifiers.cancelButtonPressed))
    }
    
    func updateUI() {
        previousEntriesTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource / Delegate Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.previousUserMeal.entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = previousEntriesTableView
            .dequeueReusableCellWithIdentifier(Identifiers.Cell, forIndexPath: indexPath) as! PreviousMealEntryTableViewCell
        let entry = self.previousUserMeal.entries[indexPath.row]
        cell.diaryEntry = entry
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PreviousMealEntryTableViewCell
        cell.setChecked(true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PreviousMealEntryTableViewCell
        cell.setChecked(false)
    }
    
    
    // MARK: - Button actions
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addToDiaryButtonPressed(sender: UIBarButtonItem) {
        
    }
}
