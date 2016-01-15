//
//  DiaryViewController.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/14/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import UIKit
import Parse

class DiaryViewController: UIViewController, DateNavigationControlDelegate,
CalorieBudgetViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Local Constants
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
        static let DateNavControlWidth: CGFloat = 190
        static let TableHeaderHeight: CGFloat = 55
    }
    
    private struct UserMealData {
        static let ValidCategories: [String] = [
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
    
    var displayedUserMeals: [UserMeal?] = [nil, nil, nil, nil]
    
    var breakfastHeader: DiaryTableHeaderView!
    var lunchHeader: DiaryTableHeaderView!
    var dinnerHeader: DiaryTableHeaderView!
    var snacksHeader: DiaryTableHeaderView!
    
    var allTableHeaders: [DiaryTableHeaderView] {
        return [breakfastHeader, lunchHeader, dinnerHeader, snacksHeader]
    }
    
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
    
    override func viewWillAppear(animated: Bool) {
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateUI()
    }
    
    func updateUI() {
        dateNavigationControl.updateDateLabel()
        updateUserMealCumulativeCalories()
        
        // Get the UserMeals for the current date and populate view
        self.displayedUserMeals = [nil, nil, nil, nil]
        UserMeal.findObjectsInBackgroundWithBlock(self.userMealQueryCompletionHandler, forDate: self.date, forUser: CustomUser.currentUser()!)
    }
    
    // Function that gets called after getting UserMeals for a certain date.
    // Appropriately populates the view on the main queue.
    func userMealQueryCompletionHandler(objects: [PFObject]?, error: NSError?) -> Void {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if error == nil {
                let userMeals = objects as! [UserMeal]
                for userMeal in userMeals {
                    // Make sure title (e.g. Breakfast, Lunch, Dinner, Snack) is valid
                    guard UserMealData.ValidCategories.contains(userMeal.title) else {
                        print("UserMeal does not have a proper title!: \(userMeal.title)")
                        continue
                    }
                    
                    if let index = UserMealData.ValidCategories.indexOf(userMeal.title) {
                        self.displayedUserMeals[index] = userMeal
                    } else {
                        print("UserMeal does not have a proper title!: \(userMeal.title)")
                    }
                }
                
                self.diaryTableView.reloadData()
                self.calorieBudgetView.updateLabels()
                self.updateUserMealCumulativeCalories()
            }
            
        }
    }
    
    private func setupViews() {
        // Create and setup date navigation control
        dateNavigationControl = DateNavigationControl(frame: CGRectMake(0, 0, Dimensions.DateNavControlWidth, Dimensions.NavBarItemHeight))
        self.navigationItem.titleView = dateNavigationControl
        
        // Initialize calorie budget values
        self.calorieBudget = CustomUser.currentUser()!.goalDailyCalories
        
        self.diaryTableView.separatorStyle = .None
        
        // Create table section headers
        breakfastHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, 0))
        breakfastHeader.title.text = Constants.MealTimeStrings.BreakfastDisplay + ":"
        
        lunchHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, 0))
        lunchHeader.title.text = Constants.MealTimeStrings.LunchDisplay + ":"
        
        dinnerHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, 0))
        dinnerHeader.title.text = Constants.MealTimeStrings.DinnerDisplay + ":"
        
        snacksHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, 0))
        snacksHeader.title.text = Constants.MealTimeStrings.SnacksDisplay + ":"
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
        var foodValue = 0
        for userMeal in self.displayedUserMeals {
            if userMeal != nil {
                foodValue += userMeal!.getCumulativeCalories()
            }
        }
        return foodValue
    }
    
    
    // MARK: - UITableViewDataSource Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return UserMealData.ValidCategories.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return allTableHeaders[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Dimensions.TableHeaderHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedUserMeals[section]?.entries.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.DiaryEntryCell) as! DiaryEntryTableViewCell
        
        // Configure the cell
        let diaryEntry = displayedUserMeals[indexPath.section]!.entries[indexPath.row]
        cell.diaryEntry = diaryEntry
        
        return cell
    }
    
    
    // MARK: - Helper functions
    
    func updateUserMealCumulativeCalories() {
        for i in 0...(allTableHeaders.count - 1) {
            allTableHeaders[i].caloriesLabel.text = "\(displayedUserMeals[i]?.getCumulativeCalories() ?? 0)"
        }
    }
    
}
