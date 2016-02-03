//
//  MenuContainerViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import THCalendarDatePicker
import ChameleonFramework

/*
    This is a container view container whose only child view controller is
    a MenuViewController.

    This VC contains the menu view and functionality for changing the date and
    searching via a search bar.

    See Apple documentation on container view controllers for more detail.
*/
class MenuContainerViewController: UIViewController, DateNavigationControlDelegate,
    UISearchBarDelegate, MenuViewControllerDelegate, THDatePickerDelegate {
    
    // MARK: - Local Constants
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
        static let DateNavControlWidth: CGFloat = 190
        static let SearchBarWidth: CGFloat = 200
    }
    
    private struct Identifiers {
        static let searchButtonPressed: String = "searchButtonPressed:"
        static let cancelButtonPressed: String = "cancelButtonPressed:"
        static let calendarButtonPressed: String = "calendarButtonPressed:"
        static let Title = "Menus"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Instance Variables
    
    var datePicker: THDatePickerViewController! {
        didSet {
            datePicker.delegate = self
        }
    }
    
    var dateNavigationControl: DateNavigationControl! {
        didSet { dateNavigationControl.delegate = self }
    }
    
    var date: NSDate = NSDate() {
        didSet { updateUI() }
    }
    
    var calendarButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var searchBar: UISearchBar! {
        didSet { searchBar.delegate = self }
    }
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupChildMenuVC()
        updateUI()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
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
        
        // Create and setup search bar button
        self.searchButton = UIBarButtonItem(image: UIImage(named: Constants.Images.SearchIcon), style: .Plain, target: self, action: NSSelectorFromString(Identifiers.searchButtonPressed))
        self.navigationItem.rightBarButtonItem = self.searchButton
        
        // Create and setup search bar
        searchBar = UISearchBar(frame: CGRectMake(0, 0, Dimensions.NavBarItemHeight, Dimensions.SearchBarWidth))
        searchBar.tintColor = Constants.Colors.appSecondaryColorDark
        searchBar.backgroundColor = UIColor.clearColor()
        
        // Create cancel bar button
        cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: NSSelectorFromString(Identifiers.cancelButtonPressed))
        
        // Create and setup date navigation control
        dateNavigationControl = DateNavigationControl(frame: CGRectMake(0, 0, Dimensions.DateNavControlWidth, Dimensions.NavBarItemHeight))
        self.navigationItem.titleView = dateNavigationControl
        
        
    }
    
    private func setupChildMenuVC() {
        // Create and add MenuViewController to this VC's container view.
        let menuVC = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.ViewControllers.MenuView) as! MenuViewController
        menuVC.delegate = self
        self.addChildViewController(menuVC)
        menuVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(menuVC.view)
        
        menuVC.didMoveToParentViewController(self)
    }
    
    func updateUI() {
        dateNavigationControl.updateDateLabel()
        getChildMenuVC().date = self.date
    }
    
    
    // MARK: - MenuViewControllerDelegate protocol methods
    
    func didSelectRecipeForMenuView(recipe: Recipe, sender: MenuViewController) {
        let recipeNutritionAdderContainer = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.RecipeNutritionAdderContainer)
            as! RecipeNutritonAdderContainerViewController
        
        // Setup the adder container
        recipeNutritionAdderContainer.recipe = recipe
        recipeNutritionAdderContainer.date = self.date
        
        // Push onto navigation controller stack
        recipeNutritionAdderContainer.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(recipeNutritionAdderContainer, animated: true)
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
    
    
    // MARK: - UISearchBarDelegate protocol methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        getChildMenuVC().searchTextChanged(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getChildMenuVC().searchRequested()
    }
    
    
    // MARK: - Button action functions
    
    func calendarButtonPressed(sender: UIBarButtonItem) {
        self.datePicker.date = self.date
        self.presentSemiViewController(self.datePicker)
    }
    
    func searchButtonPressed(sender: UIBarButtonItem) {
        displaySearchBarAndCancelButton(animated: true)
    }
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        self.searchBar.text = nil
        getChildMenuVC().searchTextChanged(nil)
        displayDateNavigationAndSearchButton(animated: true)
    }
    
    
    // MARK: - Helper Functions
    
    func getChildMenuVC() -> MenuViewController {
        // Assumes the MenuViewController has been added as a child.
        return self.childViewControllers.last as! MenuViewController
    }
    
    // Helper function to replace whatever is in the navigation bar with
    // the view controller's search bar and cancel button.
    func displaySearchBarAndCancelButton(animated animated: Bool) {
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: true)
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        
        // Animation causes a "fade-in" effect
        if animated {
            searchBar.alpha = 0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.searchBar.alpha = 1
            })
        }
    }
    
    // Helper function to replace whatever is in the navigation bar with
    // the view controller's date navigation control and search button.
    func displayDateNavigationAndSearchButton(animated animated: Bool) {
        self.navigationItem.setRightBarButtonItem(searchButton, animated: true)
        self.navigationItem.titleView = dateNavigationControl
        
        if animated {
            dateNavigationControl.alpha = 0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.dateNavigationControl.alpha = 1
            })
        }
    }
}
