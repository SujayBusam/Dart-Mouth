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

class MenuViewController: UIViewController, DateNavigationControlDelegate, HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MBProgressHUDDelegate {
    
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
        static let recipeCell: String = "recipeCell"
        static let nutritionSegue: String = "showRecipeNutrition"
    }
    
    
    
    // MARK: - Instance variables
    
    // The current menu date.
    // TODO: change back to current date after testing is done
    var date: NSDate = NSDate(dateString: "2015-11-24") {
        didSet {
            updateUI()
        }
    }
    
    var api = ParseAPI()
    var allRecipes = [Recipe]()
    var filteredRecipes = [Recipe]() {
        didSet { recipesTableView.reloadData() }
    }
    
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
        api.recipesFromCloudForDate(self.date, venueKey: selectedVenue.parseField,
            mealName: selectedMealtime.parseField, menuName: selectedMenu.parseField,
            orderAlphabetically: true, withCompletionHandler: {
            (recipes: [Recipe]?) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if recipes != nil {
                    self.allRecipes = recipes!
                } else {
                    self.allRecipes.removeAll()
                }
                self.setFilteredRecipesWithSearchText(self.searchBar.text)
                MBProgressHUD.hideAllHUDsForView(self.recipesTableView, animated: true)
            }
        })
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
        setFilteredRecipesWithSearchText(searchText)
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCellWithIdentifier(Identifiers.recipeCell, forIndexPath: indexPath)
        cell.textLabel!.text = filteredRecipes[indexPath.row].name
        return cell
    }
    
    
    
    // MARK: - Button action functions
    
    func searchButtonPressed(sender: UIButton) {
        displaySearchBarAndCancelButton(animated: true)
    }
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        searchBar.text = ""
        setFilteredRecipesWithSearchText("")
        displayDateNavigationAndSearchButton(animated: true)
    }
    
    
    
    // MARK: - Helper Functions
    
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
    
    // Helper function to set filtered Recipes given search text.
    // If the search text is nil or empty, no search occurred, so filtered Recipes are assigned all Recipes
    func setFilteredRecipesWithSearchText(searchText: String?) {
        if searchText != nil && !searchText!.isEmpty {
            // TODO: Make this a String extension
            let searchText = searchText!.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            self.filteredRecipes = allRecipes.filter({ (recipe: Recipe) -> Bool in
                return recipe.name.lowercaseString.containsString(searchText)
            })
        } else {
            self.filteredRecipes = allRecipes
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Identifiers.nutritionSegue:
                if let targetViewController = segue.destinationViewController as? RecipeNutritionViewController {
                    let recipeIndex = recipesTableView.indexPathForSelectedRow!.row
                    targetViewController.recipe = self.filteredRecipes[recipeIndex]
                }
            default: break
            }
        }
    }
    
    
    
    // MARK: - Miscellaneous
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
