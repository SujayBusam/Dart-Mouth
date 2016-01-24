//
//  DiaryViewController.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/14/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class DiaryViewController: UIViewController, DateNavigationControlDelegate,
    CalorieBudgetViewDelegate, UITableViewDataSource, UITableViewDelegate,
    UIPopoverPresentationControllerDelegate,
    DiaryEntryMealPickerViewControllerDelegate {
    
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
        static let addToDiaryPressed = "addToDiaryPressed:"
        static let Title = "Diary"
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
    
    var addToDiaryBarButton: UIBarButtonItem!
    
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
        self.navigationController?.setToolbarHidden(true, animated: false)
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateUI()
    }
    
    private func setupViews() {
        self.title = Identifiers.Title
        
        // Create and setup date navigation control
        dateNavigationControl = DateNavigationControl(
            frame: CGRectMake(0, 0, Dimensions.DateNavControlWidth, Dimensions.NavBarItemHeight))
        self.navigationItem.titleView = dateNavigationControl
        
        // Create and setup add to diary button in navigation bar
        self.addToDiaryBarButton = UIBarButtonItem(barButtonSystemItem: .Add,
            target: self, action: NSSelectorFromString(Identifiers.addToDiaryPressed))
        self.navigationItem.rightBarButtonItem = self.addToDiaryBarButton
        
        // Initialize calorie budget values
        self.calorieBudget = CustomUser.currentUser()!.goalDailyCalories
        
        self.diaryTableView.separatorStyle = .None
        
        // Create table section headers
        breakfastHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, Dimensions.TableHeaderHeight))
        breakfastHeader.title.text = Constants.MealTimeStrings.BreakfastDisplay + ":"
        
        lunchHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, Dimensions.TableHeaderHeight))
        lunchHeader.title.text = Constants.MealTimeStrings.LunchDisplay + ":"
        
        dinnerHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, Dimensions.TableHeaderHeight))
        dinnerHeader.title.text = Constants.MealTimeStrings.DinnerDisplay + ":"
        
        snacksHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, Dimensions.TableHeaderHeight))
        snacksHeader.title.text = Constants.MealTimeStrings.SnacksDisplay + ":"
    }
    
    func updateUI() {
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.userInteractionEnabled = false
        
        dateNavigationControl.updateDateLabel()
        updateUserMealCumulativeCalories()
        
        // Get the UserMeals for the current date and populate view
        self.displayedUserMeals = [nil, nil, nil, nil]
        UserMeal.findObjectsInBackgroundWithBlock(self.userMealQueryCompletionHandler, forDate: self.date, forUser: CustomUser.currentUser()!)
    }
    
    
    // MARK: - Button actions
    
    func addToDiaryPressed(sender: UIBarButtonItem) {
        let popoverContentVC = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.DiaryEntryMealPicker) as! DiaryEntryMealPickerViewController
        
        // Configure the popover content VC (the diary entry meal picker)
        popoverContentVC.delegate = self
        popoverContentVC.modalPresentationStyle = .Popover
        
        // Configure the popover presentation controller. This is different from
        // configuring the actual content VC. See docs.
        let presentationController = popoverContentVC.popoverPresentationController!
        presentationController.barButtonItem = self.addToDiaryBarButton
        presentationController.delegate = self
        
        self.presentViewController(popoverContentVC, animated: true, completion: nil)
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
    
    
    // MARK: - DiaryEntryMealPickerViewControllerDelegate protocol methods
    
    func mealWasSelectedForDiaryEntryMealPicker(meal: String, sender: DiaryEntryMealPickerViewController) {
        
        let diaryEntryAddContainer = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.DiaryEntryAddContainer) as! DiaryEntryAddContainerViewController
        
        // TODO: additional diaryEntryAddContainer configuration here
        diaryEntryAddContainer.date = self.date
        diaryEntryAddContainer.mealTime = meal
        
        // Push onto navigation controller stack
        diaryEntryAddContainer.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryEntryAddContainer, animated: true)
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate protocol methods
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
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
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        pushDiaryEntryEditContainerVCAfterSelectingIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pushDiaryEntryEditContainerVCAfterSelectingIndexPath(indexPath)
    }
    
    
    // MARK: - Navigation
    
    func pushDiaryEntryEditContainerVCAfterSelectingIndexPath(indexPath: NSIndexPath) {
        let selectedUserMeal = displayedUserMeals[indexPath.section]!
        let selectedDiaryEntry = selectedUserMeal.entries[indexPath.row]
        
        let diaryEntryEditContainer = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.DiaryEntryEditContainer)
            as! DiaryEntryEditContainerViewController
        diaryEntryEditContainer.userMeal = selectedUserMeal
        diaryEntryEditContainer.diaryEntry = selectedDiaryEntry
        
        // Push onto navigation controller stack
        diaryEntryEditContainer.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryEntryEditContainer, animated: true)
    }
    
    
    // MARK: - Helper functions
    
    func updateUserMealCumulativeCalories() {
        for i in 0...(allTableHeaders.count - 1) {
            allTableHeaders[i].caloriesLabel.text = "\(displayedUserMeals[i]?.getCumulativeCalories() ?? 0)"
        }
    }
    
    // Function that gets called after getting UserMeals for a certain date.
    // Appropriately populates the view on the main queue.
    func userMealQueryCompletionHandler(objects: [PFObject]?, error: NSError?) -> Void {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if error == nil {
                let userMeals = objects as! [UserMeal]
                var newDisplayedUserMeals: [UserMeal?] = [nil, nil, nil, nil]
                for userMeal in userMeals {
                    // Make sure title (e.g. Breakfast, Lunch, Dinner, Snack) is valid
                    guard UserMealData.ValidCategories.contains(userMeal.title) else {
                        print("UserMeal does not have a proper title!: \(userMeal.title)")
                        continue
                    }
                    
                    if let index = UserMealData.ValidCategories.indexOf(userMeal.title) {
                        newDisplayedUserMeals[index] = userMeal
                    } else {
                        print("UserMeal does not have a proper title!: \(userMeal.title)")
                    }
                }
                
                self.displayedUserMeals = newDisplayedUserMeals
                self.diaryTableView.reloadData()
                self.calorieBudgetView.updateLabels()
                self.updateUserMealCumulativeCalories()
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }
    }
    
}
