//
//  PreviousMealsViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/24/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Parse

class PreviousMealsViewController: SearchableViewController,
    UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Local Constants
    
    private struct Identifiers {
        static let PastMealCell = "PastMealCell"
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var previousUserMealsTable: UITableView! {
        didSet {
            previousUserMealsTable.dataSource = self
            previousUserMealsTable.delegate = self
        }
    }
    
    
    // MARK: - Instance Variables
    
    var datesForHeaders = NSMutableOrderedSet()
    var userMealDict = [String : [UserMeal]]()
    
    var filteredDatesForHeaders = NSMutableOrderedSet()
    var filteredUserMealDict = [String : [UserMeal]]()
    
    var currentSearchText: String? {
        didSet {
            setFilteredDateHeadersAndUserMeals(currentSearchText)
        }
    }
    
    var cal = NSCalendar.currentCalendar()
    var formatter = NSDateFormatter()
    
    
    // MARK: - View Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "EEEE, MMM d"
        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        UserMeal.findRecentObjectsInBackgroundWithBlock(self.recentMealsQueryHandler,
            forUser: CustomUser.currentUser()!, withSkip: 0, withLimit: 1000)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Other Overrides
    
    override func searchTextChanged(newSearchText: String?) {
        self.currentSearchText = newSearchText
    }
    
    override func searchRequested() {
        // Do nothing. Changing the search text already updates UI
    }
    
    
    // MARK: - UITableViewDataSource / Delegate Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filteredDatesForHeaders.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = NSDate(dateString: filteredDatesForHeaders.objectAtIndex(section) as! String)
        return formatter.stringFromDate(date)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = filteredDatesForHeaders.objectAtIndex(section) as! String
        return filteredUserMealDict[dateKey]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = previousUserMealsTable
            .dequeueReusableCellWithIdentifier(Identifiers.PastMealCell, forIndexPath: indexPath) as! PastMealTableViewCell
        
        let dateKey = filteredDatesForHeaders.objectAtIndex(indexPath.section) as! String
        let userMeal = filteredUserMealDict[dateKey]![indexPath.row]
        cell.userMeal = userMeal
        
        return cell
    }
    
    
    // MARK: - Helper Functions
    
    func recentMealsQueryHandler(objects: [PFObject]?, error: NSError?) -> Void {
        // Guard against nil or empty data returned
        guard objects != nil && !objects!.isEmpty else {
            self.previousUserMealsTable.reloadData()
            return
        }
        
        let userMeals = objects as! [UserMeal]
        populateAllDateHeadersAndAllUserMeals(userMeals)
        setFilteredDateHeadersAndUserMeals(nil)
    }
    
    /**
     Populates datesForHeaders and userMealDict by:
     Adding all the UserMeal dates to the set of dates in the format YYYY-MM-DD,
     and using those dates as keys to add the UserMeal to the dict.
    **/
    func populateAllDateHeadersAndAllUserMeals(userMeals: [UserMeal]) {
        // Clear the current data
        self.datesForHeaders.removeAllObjects()
        self.userMealDict.removeAll()
        
        // Repopulate
        for userMeal in userMeals {
            let components = self.cal.components([.Year, .Month, .Day], fromDate: userMeal.date)
            let key = "\(components.year)-\(components.month)-\(components.day)"
            self.datesForHeaders.addObject(key)
            if self.userMealDict[key] == nil {
                self.userMealDict[key] = [userMeal]
            } else {
                self.userMealDict[key]!.append(userMeal)
            }
        }
    }
    
    func setFilteredDateHeadersAndUserMeals(searchText: String?) {
        guard searchText != nil && !searchText!.isEmpty else {
            self.filteredDatesForHeaders = NSMutableOrderedSet(orderedSet: self.datesForHeaders, copyItems: true)
            self.filteredUserMealDict = self.userMealDict
            previousUserMealsTable.reloadData()
            return
        }
        
        // Filter so that the filtered instance variables contain only the date strings
        // and UserMeals where a Recipe's name within a UserMeal has a name containing
        // the search text string.
        let searchText = searchText!.lowercaseString.trim()
        let allUserMeals: [UserMeal] = Array(self.userMealDict.values).flatMap { $0 }
        let filteredUserMeals: [UserMeal] = allUserMeals.filter { (userMeal: UserMeal) -> Bool in
            return userMeal.entries.contains({ (diaryEntry: DiaryEntry) -> Bool in
                return diaryEntry.recipe.name.lowercaseString.trim().containsString(searchText)
            })
        }
        
        populateFilteredDateHeadersAndFilteredUserMeals(filteredUserMeals)
    }
    
    /**
     Same as populateAllDateHeadersAndAllUserMeals but now populating the filtered
     counterparts using an already filtered array of UserMeals
    **/
    func populateFilteredDateHeadersAndFilteredUserMeals(userMeals: [UserMeal]) {
        // Clear the current data
        self.filteredDatesForHeaders.removeAllObjects()
        self.filteredUserMealDict.removeAll()
        
        // Repopulate
        for userMeal in userMeals {
            let components = self.cal.components([.Year, .Month, .Day], fromDate: userMeal.date)
            let key = "\(components.year)-\(components.month)-\(components.day)"
            self.filteredDatesForHeaders.addObject(key)
            if self.filteredUserMealDict[key] == nil {
                self.filteredUserMealDict[key] = [userMeal]
            } else {
                self.filteredUserMealDict[key]!.append(userMeal)
            }
        }
        
        self.previousUserMealsTable.reloadData()
    }
}
