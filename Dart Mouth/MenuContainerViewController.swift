//
//  MenuContainerViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

/*
    This is a container view container whose only child view controller is
    a MenuViewController.

    This VC contains the menu view and functionality for changing the date and
    searching via a search bar.

    See Apple documentation on container view controllers for more detail.
*/
class MenuContainerViewController: UIViewController, DateNavigationControlDelegate,
    UISearchBarDelegate, MenuViewControllerDelegate {
    
    // MARK: - Local Constants
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
        static let DateNavControlWidth: CGFloat = 190
        static let SearchBarWidth: CGFloat = 200
    }
    
    private struct Identifiers {
        static let searchButtonImage: String = "Search"
        static let searchButtonPressed: String = "searchButtonPressed:"
        static let cancelButtonPressed: String = "cancelButtonPressed:"
        static let Title = "Menus"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Instance Variables
    
    var dateNavigationControl: DateNavigationControl! {
        didSet { dateNavigationControl.delegate = self }
    }
    
    var date: NSDate = NSDate() {
        didSet { updateUI() }
    }
    
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
        searchBar.resignFirstResponder()
    }
    
    private func setupViews() {
        self.title = Identifiers.Title
        
        // Create and setup search bar button
        let button = UIButton(frame: CGRectMake(0, 0, Dimensions.NavBarItemHeight, Dimensions.NavBarItemHeight))
        button.setImage(UIImage(named: Identifiers.searchButtonImage), forState: .Normal)
        button.addTarget(self, action: NSSelectorFromString(Identifiers.searchButtonPressed), forControlEvents: .TouchUpInside)
        self.searchButton = UIBarButtonItem(customView: button)
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
        recipeNutritionAdderContainer.recipe = recipe
        
        // Push onto navigation controller stack
        recipeNutritionAdderContainer.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(recipeNutritionAdderContainer, animated: true)
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
        getChildMenuVC().currentSearchText = searchText
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - Button action functions
    
    func searchButtonPressed(sender: UIButton) {
        displaySearchBarAndCancelButton(animated: true)
    }
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        self.searchBar.text = nil
        getChildMenuVC().currentSearchText = nil
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
