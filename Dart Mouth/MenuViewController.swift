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

class MenuViewController: UIViewController, DateNavigationControlDelegate,
    HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate,
    UITableViewDataSource, UITableViewDelegate,
    UISearchBarDelegate, MBProgressHUDDelegate {
    
    // MARK: - Local Constants
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
        static let DateNavControlWidth: CGFloat = 190
        static let SearchBarWidth: CGFloat = 200
        static let HorizontalItemFontSize: CGFloat = 13
    }
    
    private struct Identifiers {
        static let searchButtonImage: String = "Search"
        static let searchButtonPressed: String = "searchButtonPressed:"
        static let cancelButtonPressed: String = "cancelButtonPressed:"
        static let recipeCell: String = "RecipeCell"
        static let nutritionSegue: String = "showRecipeNutrition"
    }
    
    
    // MARK: - Instance variables
    
    // The current menu date.
    var date: NSDate = NSDate() {
        didSet { updateUI() }
    }
    
    var allCategories = [String]()
    var filteredCategories = [String]()
    
    // Maps category names (e.g. Side Dish) to array of Recipes
    var allRecipes = [String: [Recipe]]()
    var filteredRecipes = [String: [Recipe]]()
    
    var dateNavigationControl: DateNavigationControl! {
        didSet { dateNavigationControl.delegate = self }
    }
    
    var searchButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var searchBar: UISearchBar! {
        didSet { searchBar.delegate = self }
    }
    
    
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
        super.viewDidLoad()
        
        setupViews()
        updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = self.recipesTableView.indexPathForSelectedRow {
            self.recipesTableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        searchBar.resignFirstResponder()
    }
    
    func updateUI() {
        dateNavigationControl.updateDateLabel()
        
        // Update the horizonal selection lists
        for selectionList in selectionLists {
            selectionList.reloadData()
            
            if selectionList.selectedButtonIndex >= numberOfItemsInSelectionList(selectionList) ||
                selectionList.selectedButtonIndex < 0 {
                    selectionList.selectedButtonIndex = 0
            }
        }
        
        // Update the recipes table view by fetching appropriate Recipes from Parse cloud.
        let spinningActivity = MBProgressHUD.showHUDAddedTo(recipesTableView, animated: true)
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
        // Create and setup date navigation control
        dateNavigationControl = DateNavigationControl(frame: CGRectMake(0, 0, Dimensions.DateNavControlWidth, Dimensions.NavBarItemHeight))
        self.navigationItem.titleView = dateNavigationControl
        
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
        setFilteredRecipesAndCategoriesWithSearchText(searchText)
        self.recipesTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        performSegueWithIdentifier(Identifiers.nutritionSegue, sender: self)
    }
    
    
    // MARK: - Button action functions
    
    func searchButtonPressed(sender: UIButton) {
        displaySearchBarAndCancelButton(animated: true)
    }
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        self.searchBar.text = nil
        setFilteredRecipesAndCategoriesWithSearchText(nil)
        displayDateNavigationAndSearchButton(animated: true)
        self.recipesTableView.reloadData()
    }
    
    
    // MARK: - Helper Functions
    
    // Function that handles the Recipes after fetching them from Parse
    func getRecipesCompletionHandler(recipes: [Recipe]?) -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            self.populateAllCategoriesAndRecipes(recipes)
            self.setFilteredRecipesAndCategoriesWithSearchText(self.searchBar.text)
            self.recipesTableView.reloadData()
            
            // Every time UI updates, table view should reset to top, as long as it's not empty.
            if !self.filteredRecipes.isEmpty {
                self.recipesTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            }
            MBProgressHUD.hideAllHUDsForView(self.recipesTableView, animated: true)
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
    
    // Helper function to set filtered Recipes and filtered categories given
    // search text. If the search text is nil or empty, no search occurred, so
    // filtered Recipes are assigned all Recipes and filtered categories are
    // assigned all categories
    func setFilteredRecipesAndCategoriesWithSearchText(searchText: String?) {
        guard searchText != nil && !searchText!.isEmpty else {
            self.filteredRecipes = self.allRecipes
            self.filteredCategories = self.allCategories
            return
        }
        
        let searchText = searchText!.lowercaseString.trim()
        let allRecipes: [Recipe] = Array(self.allRecipes.values).flatMap { $0 }
        let filteredRecipes: [Recipe] = allRecipes.filter {
            (recipe: Recipe) -> Bool in
            return recipe.name.lowercaseString.containsString(searchText)
        }
        populateFilteredCategoriesAndRecipes(filteredRecipes)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Identifiers.nutritionSegue:
                if let targetViewController = segue.destinationViewController as? RecipeNutritionViewController {
                    if let indexPath = recipesTableView.indexPathForSelectedRow {
                        let category = self.filteredCategories[indexPath.section]
                        let recipe = self.filteredRecipes[category]![indexPath.row]
                        targetViewController.recipe = recipe
                    }
                }
            default:
                break
            }
        }
    }
    
    
    // MARK: - Miscellaneous
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
