//
//  DiaryEntryAddContainerViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/22/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import ChameleonFramework
import MBProgressHUD

/*
    This container VC is responsible for presenting child VCs that display
    DDS food, past foods, custom food, past meals, and 3rd party database food.

    This VC doesn't itself present that information. Its children do. This VC only
    manages the child views and manages the navigation bar, searching, and 
    navigation to other view controllers.
*/
class DiaryEntryAddContainerViewController: UIViewController,
    UISearchBarDelegate, MenuViewControllerDelegate, PreviousRecipesViewControllerDelegate {
    
    // MARK: - Local Constants
    
    struct Identifiers {
        static let ValidFoodSections: [String] = [
            "DDS",
            "My Foods",
            "My Meals",
            "Database"
        ]
        static let searchButtonImage: String = "Search"
        static let searchButtonPressed: String = "searchButtonPressed:"
        static let cancelButtonPressed: String = "cancelButtonPressed:"
        static let foodPickerValueDidChange: String = "foodPickerValueDidChange:"
        static let Title = "Add Food"
    }
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
        static let FoodTypePickerWidth: CGFloat = 200
        static let SearchBarWidth: CGFloat = 200
        static let FoodTypePickerFontSize: CGFloat = 13
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var foodTypePicker: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Instance Variables
    
    var date: NSDate!
    var mealTime: String!
    
    var searchButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var searchBar: UISearchBar! {
        didSet { searchBar.delegate = self }
    }
    var currentSelectedIndex: Int = 0
    
    var currentDisplayedVC: UIViewController! // TODO: this should be a subclass of UIVC
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupChildViewControllers()
    }
    
    private func setupViews() {
        // Set navigation bar title
        // Font and size is taken care of in app delegate
        self.navigationItem.title = Identifiers.Title
        
        // Create and setup search bar button
        let button = UIButton(frame: CGRectMake(0, 0, Dimensions.NavBarItemHeight, Dimensions.NavBarItemHeight))
        button.setImage(UIImage(named: Identifiers.searchButtonImage), forState: .Normal)
        button.addTarget(self, action: NSSelectorFromString(Identifiers.searchButtonPressed), forControlEvents: .TouchUpInside)
        self.searchButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = self.searchButton
        
        // Create and setup search bar
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, Dimensions.NavBarItemHeight, Dimensions.SearchBarWidth))
        self.searchBar.tintColor = Constants.Colors.appSecondaryColorDark
        self.searchBar.backgroundColor = UIColor.clearColor()
        
        // Create cancel bar button
        self.cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: NSSelectorFromString(Identifiers.cancelButtonPressed))
        
        // Setup the food type picker
        for index in 0...(Identifiers.ValidFoodSections.count - 1) {
            self.foodTypePicker.setTitle(Identifiers.ValidFoodSections[index], forSegmentAtIndex: index)
        }
        self.foodTypePicker.tintColor = Constants.Colors.appPrimaryColorDark
        self.foodTypePicker.addTarget(self, action: NSSelectorFromString(Identifiers.foodPickerValueDidChange), forControlEvents: .ValueChanged)
    }
    
    // Add / setup the child view controllers that correspond to each segment in foodTypePicker
    private func setupChildViewControllers() {
        // Create, add, and add view of MenuVC
        let menuVC = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.ViewControllers.MenuView) as! MenuViewController
        menuVC.delegate = self
        self.addChildViewController(menuVC)
        menuVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(menuVC.view)
        menuVC.didMoveToParentViewController(self)
        self.currentDisplayedVC = menuVC
        
        
        // Create and add PreviousRecipesVC
        let previousRecipesVC = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.ViewControllers.PreviousRecipes) as! PreviousRecipesViewController
        previousRecipesVC.delegate = self
        self.addChildViewController(previousRecipesVC)
        previousRecipesVC.view.frame = self.containerView.bounds
        
        // Create and add CustomRecipesVC
        let customRecipesVC = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.ViewControllers.CustomRecipes) as! CustomRecipesViewController
        self.addChildViewController(customRecipesVC)
        customRecipesVC.didMoveToParentViewController(self)
        customRecipesVC.view.frame = self.containerView.bounds
        
        // Create and add DatabaseRecipesVC
        let databaseRecipesVC = self.storyboard!.instantiateViewControllerWithIdentifier(Constants.ViewControllers.DatabaseRecipes) as! DatabaseRecipesViewController
        self.addChildViewController(databaseRecipesVC)
        databaseRecipesVC.didMoveToParentViewController(self)
        databaseRecipesVC.view.frame = self.containerView.bounds
    }
    
    
    // MARK: - UISearchBarDelegate protocol methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let vc = self.currentDisplayedVC as! SearchableViewController
        vc.setSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - MenuViewControllerDelegate protocol methods
    
    func didSelectRecipeForMenuView(recipe: Recipe, sender: MenuViewController) {
        showDiaryEntryNutritionAdderForRecipe(recipe)
    }
    
    
    // MARK: - PreviousRecipesViewControllerDelegate protocol methods
    
    func didSelectRecipeForPreviousRecipesView(recipe: Recipe, sender: PreviousRecipesViewController) {
        showDiaryEntryNutritionAdderForRecipe(recipe)
    }
    
    
    // MARK: - Button action functions
    
    func searchButtonPressed(sender: UIButton) {
        displaySearchBarAndCancelButtonAnimated(true)
    }
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        self.searchBar.text = nil
        let vc = self.currentDisplayedVC as! SearchableViewController
        vc.setSearchText(nil)
        displayTitleAndSearchButtonAnimated(true)
    }
    
    func foodPickerValueDidChange(sender: UISegmentedControl) {
        let newSelectedIndex = sender.selectedSegmentIndex
        let viewControllerToHide = self.childViewControllers[self.currentSelectedIndex]
        let viewControllerToDisplay = self.childViewControllers[newSelectedIndex]
        
        viewControllerToHide.view.removeFromSuperview()
        self.containerView.addSubview(viewControllerToDisplay.view)
        viewControllerToDisplay.viewDidAppear(true)
        
        self.currentDisplayedVC = viewControllerToDisplay
        self.currentSelectedIndex = newSelectedIndex
    }

    
    // MARK: - Helper Functions
    
    // Helper function to replace whatever is in the navigation bar with
    // the view controller's search bar and cancel button.
    func displaySearchBarAndCancelButtonAnimated(animated: Bool) {
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: true)
        self.navigationItem.titleView = searchBar
        self.searchBar.becomeFirstResponder()
        
        // Animation causes a "fade-in" effect
        if animated {
            self.searchBar.alpha = 0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.searchBar.alpha = 1
            })
        }
    }
    
    // Helper function to replace whatever is in the navigation bar with
    // the view controller's title and search button.
    func displayTitleAndSearchButtonAnimated(animated: Bool) {
        self.navigationItem.setRightBarButtonItem(searchButton, animated: animated)
        
        if animated {
            self.navigationItem.titleView?.alpha = 1.0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.navigationItem.titleView?.alpha = 0
                self.navigationItem.title = Identifiers.Title
                }, completion: { (bool: Bool) -> Void in
                    self.navigationItem.titleView = nil
            })
        } else {
            self.navigationItem.titleView = nil
            self.navigationItem.title = Identifiers.Title
        }
    }
    
    func showDiaryEntryNutritionAdderForRecipe(recipe: Recipe) {
        let diaryEntryNutritionAdderContainer = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.DiaryEntryNutritionAdderContainer)
            as! DiaryEntryNutritionAdderContainerViewController
        
        // Setup the adder container
        diaryEntryNutritionAdderContainer.mealTime = self.mealTime
        diaryEntryNutritionAdderContainer.recipe = recipe
        diaryEntryNutritionAdderContainer.date = self.date
        
        // Push onto navigation controller stack
        diaryEntryNutritionAdderContainer.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryEntryNutritionAdderContainer, animated: true)
    }

}
