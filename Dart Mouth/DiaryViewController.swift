//
//  DiaryViewController.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/14/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController, DateNavigationControlDelegate,
    CalorieBudgetViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Local Constants
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
        static let DateNavControlWidth: CGFloat = 190
    }
    
    private struct EntryData {
        static let EntryCategories: [String] = [
            Constants.MealTimeStrings.BreakfastDisplay,
            Constants.MealTimeStrings.LunchDisplay,
            Constants.MealTimeStrings.DinnerDisplay,
            Constants.MealTimeStrings.SnacksDisplay
        ]
    }
    
    private struct Identifiers {
        static let DiaryEntryCell = "DiaryEntryCell"
    }

    
    // MARK: - Instance variables
    
    // Data structure that holds data for table view.
    // Maps strings to optional array of UserMeals
    // Initialized with the 4 relevant keys and nil values.
    var diaryEntries: [String : [DiaryEntry]?] = [
        EntryData.EntryCategories[0]: nil,
        EntryData.EntryCategories[1]: nil,
        EntryData.EntryCategories[2]: nil,
        EntryData.EntryCategories[3]: nil,
    ]
    
    // The current diary date.
    var date: NSDate = NSDate() {
        didSet { updateUI() }
    }
    
    var dateNavigationControl: DateNavigationControl! {
        didSet { dateNavigationControl.delegate = self }
    }
    
    var calorieBudget: Int = 0 {
        didSet { calorieBudgetView.updateLabels() }
    }
    
    var foodCalories: Int = 0 {
        didSet { calorieBudgetView.updateLabels() }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var calorieBudgetView: CalorieBudgetView! {
        didSet { calorieBudgetView.delegate = self }
    }
    
    @IBOutlet weak var diaryTableView: UITableView! {
        didSet {
            diaryTableView.dataSource = self
            diaryTableView.delegate = self
        }
    }
    
    
    // MARK: - Controller / View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateUI()
    }
    
    func updateUI() {
        dateNavigationControl.updateDateLabel()
    }
    
    private func setupViews() {
        // Create and setup date navigation control
        dateNavigationControl = DateNavigationControl(frame: CGRectMake(0, 0, Dimensions.DateNavControlWidth, Dimensions.NavBarItemHeight))
        self.navigationItem.titleView = dateNavigationControl
        
        // Initialize calorie budget values
        self.calorieBudget = CustomUser.currentUser()!.goalDailyCalories
        self.foodCalories = 0
    }
    
    
    // MARK: - DateNavigationControlDelegate protocol methods
    
    func dateForDateNavigationControl(sender: DateNavigationControl) -> NSDate {
        return self.date
    }
    
    func leftArrowWasPressed(sender: UIButton) {
        if let dayBefore = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: self.date, options: []) {
            self.date = dayBefore
        } else {
            print("Date decrement calculation failed")
        }
    }
    
    func rightArrowWasPressed(sender: UIButton) {
        if let dayAfter = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: self.date, options: []) {
            self.date = dayAfter
        } else {
            print("Date increment calculation failed")
        }
    }
    
    
    // MARK: - CalorieBudgetViewDelegate protocol methods
    
    func budgetValueForCalorieBudgetView(sender: CalorieBudgetView) -> Int {
        return self.calorieBudget
    }
    
    func foodValueForCalorieBudgetView(sender: CalorieBudgetView) -> Int {
        return self.foodCalories
    }
    
    
    // MARK: - UITableViewDataSource Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return EntryData.EntryCategories.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return EntryData.EntryCategories[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section: String = EntryData.EntryCategories[section]
        return self.diaryEntries[section]!?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.DiaryEntryCell) as! DiaryEntryTableViewCell
        
        // Configure the cell
        let sectionTitle = EntryData.EntryCategories[indexPath.section]
        let diaryEntry: DiaryEntry = self.diaryEntries[sectionTitle]!![indexPath.row]
        cell.diaryEntry = diaryEntry
        
        return cell
    }

}
