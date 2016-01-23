//
//  MenuViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/9/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import ChameleonFramework
import HTHorizontalSelectionList
import MBProgressHUD

protocol MenuViewControllerDelegate: class {
    func didSelectRecipeForMenuView(recipe: Recipe, sender: MenuViewController) -> Void
}

/*
    This class is only responsible for displaying menu items and allowing the user
    to select venue / mealtime / menu, as well as presenting recipe nutrition view
    on selection of one of the tableview cells.

    It does not itself contain the date selector, search bar, or toolbar. It is up
    to the containing root view controller to setup those items and update this 
    view controller's UI as necessary.

    It is implemented this way so that this view controller is more generic and reusable.
*/
class MenuViewController: UIViewController, HTHorizontalSelectionListDataSource,
    HTHorizontalSelectionListDelegate, UITableViewDataSource, UITableViewDelegate,
    MBProgressHUDDelegate {
    
    // MARK: - Local Constants
    
    private struct Dimensions {
        static let HorizontalItemFontSize: CGFloat = 13
    }
    
    private struct Identifiers {
        static let recipeCell: String = "RecipeCell"
    }
    
    
    // MARK: - Instance variables
    
    weak var delegate: MenuViewControllerDelegate!
    
    // The current menu date.
    var date: NSDate = NSDate() {
        didSet { updateUI() }
    }
    
    var currentSearchText: String? {
        didSet {
            // NOTE: doesn't need to call updateUI() since other values such as
            // current venue or date haven't changed. Therefore, API calls do not
            // need to be made. We only update the filtered recipes and categories.
            // This will not call the backend at all.
            setFilteredRecipesAndCategoriesWithSearchText(currentSearchText)
        }
    }
    
    var allCategories = [String]()
    var filteredCategories = [String]()
    
    // Maps category names (e.g. Side Dish) to array of Recipes
    var allRecipes = [String: [Recipe]]()
    var filteredRecipes = [String: [Recipe]]()
    
    
    // MARK: - Outlets
    
    // Selectors for venue, mealtime, and menu. These were created via storyboard
    @IBOutlet
    var venueSelectionList: HTHorizontalSelectionList! {
        didSet {
            venueSelectionList.dataSource = self
            venueSelectionList.delegate = self
        }
    }
    
    @IBOutlet
    var mealtimeSelectionList: HTHorizontalSelectionList! {
        didSet {
            mealtimeSelectionList.dataSource = self
            mealtimeSelectionList.delegate = self
        }
    }
    
    @IBOutlet
    var menuSelectionList: HTHorizontalSelectionList! {
        didSet {
            menuSelectionList.dataSource = self
            menuSelectionList.delegate = self
        }
    }
    
    @IBOutlet weak var recipesTableView: UITableView! {
        didSet {
            recipesTableView.dataSource = self
            recipesTableView.delegate = self
        }
    }
    
    
    // MARK: - Computed properties
    
    var selectionLists: [HTHorizontalSelectionList] {
        return [venueSelectionList, mealtimeSelectionList, menuSelectionList]
    }
    
    
    // MARK: - Controller / View Setup
    
    override func viewDidLoad() {
        print("MenuVC view did load.")
        super.viewDidLoad()
        
        setupViews()
        updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("MenuVC view will appear.")
        super.viewWillAppear(animated)

        // If a Recipe was selected, the gray selection disappears with animation
        // once navigation returns to this view controller.
        if let indexPathForSelectedRow = self.recipesTableView.indexPathForSelectedRow {
            self.recipesTableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
        
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func updateUI() {
        // Update the horizonal selection lists
        for selectionList in selectionLists {
            selectionList.reloadData()
            
            if selectionList.selectedButtonIndex >= numberOfItemsInSelectionList(selectionList) ||
                selectionList.selectedButtonIndex < 0 {
                    selectionList.selectedButtonIndex = 0
            }
        }
        
        // Update the recipes table view by fetching appropriate Recipes from Parse cloud.
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.userInteractionEnabled = false
        let selectedVenue = itemForSelectionList(venueSelectionList, withIndex: venueSelectionList.selectedButtonIndex)!
        let selectedMealtime = itemForSelectionList(mealtimeSelectionList, withIndex: mealtimeSelectionList.selectedButtonIndex)!
        let selectedMenu = itemForSelectionList(menuSelectionList, withIndex: menuSelectionList.selectedButtonIndex)!
        Recipe.findDDSRecipesForDate(self.date, venueKey: selectedVenue.parseField,
            mealName: selectedMealtime.parseField, menuName: selectedMenu.parseField,
            orderAlphabetically: true,
            withCompletionHandler: self.getRecipesCompletionHandler)
    }
    
    private func setupViews() {
        // Setup properties for the three HTHorizontalSelectionLists
        for selectionList in selectionLists {
            selectionList.centerAlignButtons = true
            selectionList.bottomTrimColor = FlatBlackDark()
            selectionList.selectionIndicatorAnimationMode = .HeavyBounce
            selectionList.selectionIndicatorColor = Constants.Colors.appPrimaryColorDark
            
            selectionList.setTitleColor(FlatGrayDark(), forState: .Normal)
            selectionList.setTitleColor(Constants.Colors.appPrimaryColorDark, forState: .Selected)
            selectionList.setTitleFont(UIFont.boldSystemFontOfSize(Dimensions.HorizontalItemFontSize), forState: .Normal)
        }
    }
    
    
    // MARK: - HTHorizontalSelectionListDataSource Protocol Methods
    
    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
        let selectedVenue = Venue.allVenues[venueSelectionList.selectedButtonIndex]
        
        switch selectionList {
        case venueSelectionList:
            return Venue.allVenues.count
        case mealtimeSelectionList:
            return selectedVenue.mealTimes.count
        case menuSelectionList:
            return selectedVenue.menus.count
        default:
            return -1
        }
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        return itemForSelectionList(selectionList, withIndex: index)!.displayString
    }
    
    
    // MARK: - HTHorizontalSelectionListDelegate Protocol Methods
    
    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
        updateUI()
    }
    
    
    // MARK: - UITableViewDataSource Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.filteredCategories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = self.filteredCategories[section]
        return filteredRecipes[category]!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredCategories[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCellWithIdentifier(Identifiers.recipeCell, forIndexPath: indexPath)
        
        let category = filteredCategories[indexPath.section]
        let recipe = filteredRecipes[category]![indexPath.row]
        
        cell.textLabel?.text = recipe.name
        cell.detailTextLabel?.text = "\(recipe.getCalories()?.description ?? "-") cals"
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .Default
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        pushRecipeNutritionAdderContainerVCAfterSelectingIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pushRecipeNutritionAdderContainerVCAfterSelectingIndexPath(indexPath)
    }
    
    
    // MARK: - Navigation
    // TODO: The push should be a delegate method
    func pushRecipeNutritionAdderContainerVCAfterSelectingIndexPath(indexPath: NSIndexPath) {
        let category = self.filteredCategories[indexPath.section]
        let selectedRecipe = self.filteredRecipes[category]![indexPath.row]
        delegate.didSelectRecipeForMenuView(selectedRecipe, sender: self)
    }
    
    
    // MARK: - Helper Functions
    
    // Function that handles the Recipes after fetching them from Parse
    func getRecipesCompletionHandler(recipes: [Recipe]?) -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            self.populateAllCategoriesAndRecipes(recipes)
            self.setFilteredRecipesAndCategoriesWithSearchText(self.currentSearchText)
            
            // Every time UI updates, table view should reset to top, as long as it's not empty.
            if !self.filteredRecipes.isEmpty {
                self.recipesTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        
    }
    
    // Populates passed Recipes into allRecipes dictionary that maps category name
    // to Recipes. Also populates allCategories.
    func populateAllCategoriesAndRecipes(recipes: [Recipe]?) {
        // Clear the current data
        self.allCategories.removeAll()
        self.allRecipes.removeAll()
        
        guard recipes != nil else { return }
        
        // Repopulate
        for recipe in recipes! {
            let category = recipe.category
            
            // Populate all Recipes
            if self.allRecipes[category] == nil {
                self.allRecipes[category] = [recipe]
            } else {
                self.allRecipes[category]!.append(recipe)
            }
            
            // Populate all categories
            if !self.allCategories.contains(category) {
                self.allCategories.append(category)
            }
        }
    }
    
    // Populates passed Recipes into filteredRecipes dictionary that maps
    // category name to Recipes. Also populates filteredCategories
    func populateFilteredCategoriesAndRecipes(recipes: [Recipe]) {
        // Clear the current data
        self.filteredCategories.removeAll()
        self.filteredRecipes.removeAll()
        
        // Repopulate
        for recipe in recipes {
            let category = recipe.category
            
            // Populate filtered Recipes
            if self.filteredRecipes[category] == nil {
                self.filteredRecipes[category] = [recipe]
            } else {
                self.filteredRecipes[category]!.append(recipe)
            }
            
            // Populate filtered categories
            if !self.filteredCategories.contains(category) {
                self.filteredCategories.append(category)
            }
        }
    }
    
    // Helper function to return Venue, Mealtime, or Menu enum given a selection list
    // and selection button index. Note that Venue, Mealtime, and Menu conform to
    // ParseFieldCompatible protocol
    private func itemForSelectionList(selectionList: HTHorizontalSelectionList!, withIndex index: Int) -> ParseFieldCompatible? {
        let selectedVenue = Venue.allVenues[venueSelectionList.selectedButtonIndex]
        
        switch selectionList {
        case venueSelectionList:
            return Venue.allVenues[index]
        case mealtimeSelectionList:
            return selectedVenue.mealTimes[index]
        case menuSelectionList:
            return selectedVenue.menus[index]
        default:
            print("Unhandled selection list.")
            return nil
        }
    }
    
    /*
    Helper function to set filtered Recipes and filtered categories given
    search text. If the search text is nil or empty, no search occurred, so
    filtered Recipes are assigned all Recipes and filtered categories are
    assigned all categories.
    
    Also reloads the table view at the end. This is the only place where reloadData()
    is called! Do not call reloadData() anywhere else.
    */
    func setFilteredRecipesAndCategoriesWithSearchText(searchText: String?) {
        guard searchText != nil && !searchText!.isEmpty else {
            self.filteredRecipes = self.allRecipes
            self.filteredCategories = self.allCategories
            self.recipesTableView.reloadData()
            return
        }
        
        let searchText = searchText!.lowercaseString.trim()
        let allRecipes: [Recipe] = Array(self.allRecipes.values).flatMap { $0 }
        let filteredRecipes: [Recipe] = allRecipes.filter {
            (recipe: Recipe) -> Bool in
            return recipe.name.lowercaseString.containsString(searchText)
        }
        populateFilteredCategoriesAndRecipes(filteredRecipes)
        self.recipesTableView.reloadData()
    }
    
}
