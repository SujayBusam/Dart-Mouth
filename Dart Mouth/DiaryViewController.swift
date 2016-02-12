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
import THCalendarDatePicker
import ChameleonFramework

class DiaryViewController: UIViewController, DateNavigationControlDelegate,
    CalorieBudgetViewDelegate, UITableViewDataSource, UITableViewDelegate,
    UIPopoverPresentationControllerDelegate,
    PreviousRecipesViewControllerDelegate, DiaryTableHeaderViewDelegate,
    THDatePickerDelegate {
    
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
        static let AddButton = "PlusUnfilledWhite"
        static let addToDiaryPressed = "addToDiaryPressed:"
        static let calendarButtonPressed: String = "calendarButtonPressed:"
        static let Title = "Diary"
    }
    
    
    // MARK: - Instance variables
    
    var datePicker: THDatePickerViewController! {
        didSet {
            datePicker.delegate = self
        }
    }
    
    var displayedUserMeals: [UserMeal?] = [nil, nil, nil, nil]
    
    var breakfastHeader: DiaryTableHeaderView!
    var lunchHeader: DiaryTableHeaderView!
    var dinnerHeader: DiaryTableHeaderView!
    var snacksHeader: DiaryTableHeaderView!
    
    var allTableHeaders: [DiaryTableHeaderView] {
        return [breakfastHeader, lunchHeader, dinnerHeader, snacksHeader]
    }
    
    var calendarButton: UIBarButtonItem!
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
        super.viewWillAppear(animated)
        
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
        
        // Create and setup the calendar bar button
        self.calendarButton = UIBarButtonItem(image: UIImage(named: Constants.Images.Calendar), style: .Plain, target: self, action: NSSelectorFromString(Identifiers.calendarButtonPressed))
        self.navigationItem.leftBarButtonItem = self.calendarButton
        
        // Create and setup the date picker VC
        self.datePicker = THDatePickerViewController.datePicker()
        datePicker.setAllowClearDate(false)
        datePicker.setClearAsToday(true)
        datePicker.setAutoCloseOnSelectDate(false)
        datePicker.setAllowSelectionOfSelectedDate(true)
        datePicker.setDisableFutureSelection(false)
        datePicker.setDisableHistorySelection(false)
        datePicker.setDisableYearSwitch(false)
        datePicker.selectedBackgroundColor = Constants.Colors.appPrimaryColor
        datePicker.currentDateColor = FlatRed()
        datePicker.currentDateColorSelected = FlatRed()
        
        // Create and setup date navigation control
        dateNavigationControl = DateNavigationControl(
            frame: CGRectMake(0, 0, Dimensions.DateNavControlWidth, Dimensions.NavBarItemHeight))
        self.navigationItem.titleView = dateNavigationControl
        
        // Create and setup add to diary button in navigation bar
        // Commented out for now for user studies.
        //self.addToDiaryBarButton = UIBarButtonItem(image: UIImage(named: Identifiers.AddButton), style: UIBarButtonItemStyle.Plain, target: self, action: NSSelectorFromString(Identifiers.addToDiaryPressed))
        //self.navigationItem.rightBarButtonItem = self.addToDiaryBarButton
        
        // Initialize calorie budget values
        self.calorieBudget = CustomUser.currentUser()!.goalDailyCalories
        
        self.diaryTableView.separatorStyle = .None
        
        // Create table section headers
        breakfastHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, Dimensions.TableHeaderHeight))
        breakfastHeader.delegate = self
        breakfastHeader.title.text = MealTime.Breakfast.displayString! + ":"
        
        lunchHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, Dimensions.TableHeaderHeight))
        lunchHeader.delegate = self
        lunchHeader.title.text = MealTime.Lunch.displayString! + ":"
        
        dinnerHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, Dimensions.TableHeaderHeight))
        dinnerHeader.delegate = self
        dinnerHeader.title.text = MealTime.Dinner.displayString! + ":"
        
        snacksHeader = DiaryTableHeaderView(frame: CGRectMake(0, 0, diaryTableView.frame.width, Dimensions.TableHeaderHeight))
        snacksHeader.delegate = self
        snacksHeader.title.text = MealTime.Snacks.displayString! + ":"
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
    
    func calendarButtonPressed(sender: UIBarButtonItem) {
        self.datePicker.date = self.date
        self.presentSemiViewController(self.datePicker)
    }
    
    func addToDiaryPressed(sender: UIBarButtonItem) {
        let popoverContentVC = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.PreviousRecipes) as! PreviousRecipesViewController
        
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
    
    
    // MARK: - THDatePickerDelegate protocol methods
    
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
        self.date = datePicker.date
        self.dismissSemiModalView()
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
        self.dismissSemiModalView()
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
    
    func dateWasDoublePressed(sender: UIButton) {
        self.date = NSDate()
    }
    
    
    // MARK: - PreviousRecipesViewController protocol methods
    
    func didSelectRecipeForPreviousRecipesView(recipe: Recipe, sender: PreviousRecipesViewController) {
        print("selected")
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
        if let diaryEntry = displayedUserMeals[indexPath.section]?.entries[indexPath.row] {
            cell.diaryEntry = diaryEntry
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        pushDiaryEntryEditContainerVCAfterSelectingIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pushDiaryEntryEditContainerVCAfterSelectingIndexPath(indexPath)
    }
    
    
    // MARK: - DiaryTableHeaderViewDelegate protocol methods
    
    func addButtonPressedForDiaryTableHeader(sender: DiaryTableHeaderView) {
        switch sender {
        case self.breakfastHeader:
            pushDiaryEntryAddContainerVCAfterSelectingUserMeal(MealTime.Breakfast.displayString!)
            break
        case self.lunchHeader:
            pushDiaryEntryAddContainerVCAfterSelectingUserMeal(MealTime.Lunch.displayString!)
            break
        case self.dinnerHeader:
            pushDiaryEntryAddContainerVCAfterSelectingUserMeal(MealTime.Dinner.displayString!)
            break
        case self.snacksHeader:
            pushDiaryEntryAddContainerVCAfterSelectingUserMeal(MealTime.Snacks.displayString!)
            break
        default:
            break
        }
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
    
    func pushDiaryEntryAddContainerVCAfterSelectingUserMeal(userMeal: String) {
        let diaryEntryAddContainer = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.DiaryEntryAddContainer) as! DiaryEntryAddContainerViewController
        
        // TODO: additional diaryEntryAddContainer configuration here
        diaryEntryAddContainer.date = self.date
        diaryEntryAddContainer.mealTime = userMeal
        
        // Push onto navigation controller stack
        diaryEntryAddContainer.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryEntryAddContainer, animated: true)
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
