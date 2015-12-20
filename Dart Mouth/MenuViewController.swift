//
//  MenuViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/9/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework
import HTHorizontalSelectionList

class MenuViewController: UIViewController, DateNavigationControlDelegate, HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // String constants, in case we ever need to change them
    private struct Constants {
        static let Foco = "Foco"
        static let Hop = "HOP"
        static let Novack = "Novack"
        
        static let Breakfast = "Breakfast"
        static let Lunch = "Lunch"
        static let Dinner = "Dinner"
        static let LateNight = "Late Night"
        static let AllDay = "All Day"
        
        static let Specials = "Today's Specials"
        static let EverydayItems = "Everyday Items"
        static let Beverage = "Beverage"
        static let Cereal = "Cereal"
        static let Condiments = "Condiments"
        static let GlutenFree = "Additional Gluten Free"
        
        static let CYCDeli = "Courtyard Deli"
        static let CYCGrill = "Courtyard Grill"
        static let CYCGrabGo = "Grab & Go"
        static let CYCSnacks = "Courtyard Snacks"
    }
    
    // Mappings from venue to mealtimes and venue to menus
    private struct SelectionMappings {
        static let MealTimes: [String: [String]] = [
            Constants.Foco: [
                Constants.Breakfast,
                Constants.Lunch,
                Constants.Dinner,
                Constants.LateNight,
            ],
            
            Constants.Hop: [
                Constants.Breakfast,
                Constants.Lunch,
                Constants.Dinner,
                Constants.LateNight,
            ],
            
            Constants.Novack: [
                Constants.AllDay
            ],
        ]
        
        static let Menus: [String: [String]] = [
            Constants.Foco: [
                Constants.Specials,
                Constants.EverydayItems,
                Constants.GlutenFree,
                Constants.Beverage,
                Constants.Condiments,
            ],
            
            Constants.Hop: [
                Constants.Specials,
                Constants.EverydayItems,
                Constants.CYCDeli,
                Constants.CYCGrill,
                Constants.CYCGrabGo,
                Constants.CYCSnacks,
                Constants.Beverage,
                Constants.Cereal,
                Constants.Condiments,
            ],
            
            Constants.Novack: [
                Constants.Specials,
                Constants.EverydayItems,
            ]
        ]
    }
    
    // The current menu date.
    var date: NSDate = NSDate() {
        didSet {
            updateUI()
        }
    }
    
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
    
    var venues: [String] {
        return [Constants.Foco, Constants.Hop, Constants.Novack]
    }
    
    // MARK: - Controller / View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateUI()
    }
    
    func updateUI() {
        dateNavigationControl.updateDateLabel()

        for selectionList in selectionLists {
            selectionList.reloadData()
        }
    }
    
    func setupViews() {
        // Setup properties for the three HTHorizontalSelectionLists
        for selectionList in selectionLists {
            let normalStateColor = FlatGray()
            
            selectionList.centerAlignButtons = true
            selectionList.bottomTrimColor = normalStateColor
            selectionList.selectionIndicatorAnimationMode = .HeavyBounce
            selectionList.selectionIndicatorColor = ColorUtil.appPrimaryColorDark
            
            selectionList.setTitleColor(normalStateColor, forState: .Normal)
            selectionList.setTitleColor(ColorUtil.appPrimaryColorDark, forState: .Selected)
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
        let venue = self.venues[venueSelectionList.selectedButtonIndex]
        
        switch selectionList {
        case venueSelectionList:
            return self.venues.count
        case mealtimeSelectionList:
            return SelectionMappings.MealTimes[venue]!.count
        case menuSelectionList:
            return SelectionMappings.Menus[venue]!.count
        default:
            return -1
        }
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        let venue = self.venues[venueSelectionList.selectedButtonIndex]
        switch selectionList {
        case venueSelectionList:
            return venues[index]
        case mealtimeSelectionList:
            return SelectionMappings.MealTimes[venue]![index]
        case menuSelectionList:
            return SelectionMappings.Menus[venue]![index]
        default:
            return "Error"
        }
    }
    
    
    // MARK: - HTHorizontalSelectionListDelegate Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = "Cell \(indexPath.row)"
        return cell
    }
    
    
    
    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
        updateUI()
    }
    
    // MARK: - UITableViewDataSource Protocol Methods
    
    
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
