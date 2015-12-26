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

class MenuViewController: UIViewController, DateNavigationControlDelegate, HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Instance variables
    
    // The current menu date.
    var date: NSDate = NSDate() {
        didSet {
            updateUI()
        }
    }
    
    var api = ParseAPIUtil()
    var displayedRecipes = [Recipe]()
    
    let allVenues: [Venue] = [.Foco, .Hop, .Novack]
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateNavigationControl: DateNavigationControl! {
        didSet { dateNavigationControl.delegate = self }
    }
    
    // Selectors for venue, mealtime, and menu
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
        let selectedVenue = itemForSelectionList(venueSelectionList, withSelectedIndex: venueSelectionList.selectedButtonIndex)!
        let selectedMealtime = itemForSelectionList(mealtimeSelectionList, withSelectedIndex: mealtimeSelectionList.selectedButtonIndex)!
        let selectedMenu = itemForSelectionList(menuSelectionList, withSelectedIndex: menuSelectionList.selectedButtonIndex)!
        api.recipesFromCloudForDate(self.date, venueKey: selectedVenue.parseField, mealName: selectedMealtime.parseField, menuName: selectedMenu.parseField, withCompletionHandler: {
            (recipes: [Recipe]?) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if recipes != nil {
                    self.displayedRecipes = recipes!
                } else {
                    self.displayedRecipes.removeAll()
                }
                self.recipesTableView.reloadData()
            }
        })
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
            selectionList.setTitleFont(UIFont.boldSystemFontOfSize(13), forState: .Normal)
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
    
    
    
    // MARK: - HTHorizontalSelectionListDataSource Protocol Methods
    
    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
        let venue = allVenues[venueSelectionList.selectedButtonIndex]
        
        switch selectionList {
        case venueSelectionList:
            return allVenues.count
        case mealtimeSelectionList:
            return Mappings.MealTimesForVenue[venue]!.count
        case menuSelectionList:
            return Mappings.MenusForVenue[venue]!.count
        default:
            return -1
        }
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        return itemForSelectionList(selectionList, withSelectedIndex: index)!.displayString
    }
    
    // Helper function to return Venue, Mealtime, or Menu given a selection list and selection button index.
    // Note that Venue, Mealtime, and Menu conform to ParseFieldCompatible protocol
    private func itemForSelectionList(selectionList: HTHorizontalSelectionList!, withSelectedIndex selectedIndex: Int) -> ParseFieldCompatible? {
        let venue = allVenues[venueSelectionList.selectedButtonIndex]
        
        switch selectionList {
        case venueSelectionList:
            return allVenues[selectedIndex]
        case mealtimeSelectionList:
            return Mappings.MealTimesForVenue[venue]![selectedIndex]
        case menuSelectionList:
            return Mappings.MenusForVenue[venue]![selectedIndex]
        default:
            print("Unhandled selection list.")
            return nil
        }
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
        return displayedRecipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath)
        cell.textLabel!.text = displayedRecipes[indexPath.row].name
        return cell
    }
    
    
    // MARK: - Miscellaneous
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
