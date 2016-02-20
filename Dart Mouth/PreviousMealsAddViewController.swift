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
        updateUI()
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
            .dequeueReusableCellWithIdentifier("PastMealEntryCell", forIndexPath: indexPath) as! PreviousMealEntryTableViewCell
        let entry = self.previousUserMeal.entries[indexPath.row]
        cell.diaryEntry = entry
        
        return cell
    }
}
