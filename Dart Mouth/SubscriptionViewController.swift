//
//  SubscriptionViewController.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 3/4/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import HTHorizontalSelectionList
import MBProgressHUD
import VBFPopFlatButton


class SubscriptionViewController : SearchableViewController, UISearchBarDelegate,
HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UITableViewDataSource, UITableViewDelegate {
    
    enum SubscriptionDisplay : Int {
        case Current = 0, AddNew = 1
    }

    var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    var searchButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!

    @IBOutlet weak var subscriptionSelector: HTHorizontalSelectionList!{
        didSet{
            subscriptionSelector.delegate = self
            subscriptionSelector.dataSource = self
        }
    }
    
    @IBOutlet weak var currentSubscriptionTable: UITableView!{
        didSet{
            currentSubscriptionTable.delegate = self
            currentSubscriptionTable.dataSource = self
        }
    }
    
    @IBOutlet weak var addSubscriptionTable: UITableView!{
        didSet{
            addSubscriptionTable.delegate = self
            addSubscriptionTable.dataSource = self
        }
    }
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
        static let SearchBarWidth: CGFloat = 150
    }

    private struct Identifiers {
        static let searchButtonPressed: String = "searchButtonPressed:"
        static let cancelButtonPressed: String = "cancelButtonPressed:"
        static let calendarButtonPressed: String = "calendarButtonPressed:"
        static let Title = "Manage Subscriptions"
        static let subscriptionCell: String = "SubscriptionCell"

    }
    
    var currentSubscriptions : [Recipe] = []
    var newSubscriptions : [Recipe] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    func setupViews(){
        // Set the title
        self.navigationItem.title = Identifiers.Title

        // Create and setup search bar button
        self.searchButton = UIBarButtonItem(image: UIImage(named: Constants.Images.SearchIcon), style: .Plain, target: self, action: NSSelectorFromString(Identifiers.searchButtonPressed))
        self.navigationItem.rightBarButtonItem = self.searchButton
        
        // Create and setup search bar
        searchBar = UISearchBar(frame: CGRectMake(0, 0, Dimensions.NavBarItemHeight, Dimensions.SearchBarWidth))
        searchBar.tintColor = Constants.Colors.appSecondaryColorDark
        searchBar.backgroundColor = UIColor.clearColor()
        
        // Create cancel bar button
        cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: NSSelectorFromString(Identifiers.cancelButtonPressed))
        
        // Selector Setup
        subscriptionSelector.setTitleFont(UIFont.systemFontOfSize(15.0), forState: UIControlState.Normal)
        subscriptionSelector.bottomTrimHidden = true
        subscriptionSelector.centerAlignButtons = true
        subscriptionSelector.reloadData()
    }
    
    func loadNewSubscriptions(searchText : String){
        Recipe.findDDSRecipesContainingSearchText(searchText, withLimit: 100, withCompletionHandler: {
            (recipes: [Recipe])  in
             self.newSubscriptions = recipes
             self.addSubscriptionTable.reloadData()
             self.addSubscriptionTable.alpha = 1.0
             self.currentSubscriptionTable.alpha = 0.0

        })
    }
    
    func loadCurrentSubscriptions(){
        //TODO -- actual loading
        self.addSubscriptionTable.alpha = 0.0
        self.currentSubscriptionTable.alpha = 1.0
        newSubscriptions = []
        addSubscriptionTable.reloadData()
    }
    
    // MARK: - Button action functions
    
    func searchButtonPressed(sender: UIBarButtonItem) {
        displaySearchBarAndCancelButton(animated: true)
        //change to add new subscriptions for searching
        subscriptionSelector.selectedButtonIndex = SubscriptionDisplay.AddNew.rawValue
    }
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        self.searchBar.text = nil
        //getChildMenuVC().searchTextChanged(nil)
        displaySearchButton(animated: true)
        //change to current subscriptions display
        subscriptionSelector.selectedButtonIndex = SubscriptionDisplay.Current.rawValue
        loadCurrentSubscriptions()
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
    func displaySearchButton(animated animated: Bool) {
        self.navigationItem.setRightBarButtonItem(searchButton, animated: true)
        searchBar.resignFirstResponder()

        if animated {
            searchBar.alpha = 1
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.searchBar.alpha = 0
                }, completion: { finished in
                    if(finished) {
                        self.navigationItem.titleView = nil
                    }
            })
        }
    }

    
    // MARK: - UISearchBarDelegate protocol methods
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        //getChildMenuVC().searchTextChanged(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        loadNewSubscriptions(searchBar.text!)
    }
    
    // MARK: - HTHorizontalSelectionListDataSource Protocol Methods
    
    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
        return 2
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        if(index == SubscriptionDisplay.Current.rawValue){
            return "Current"
        } else if(index == SubscriptionDisplay.AddNew.rawValue){
            return "Add"
        } else {
            return "Missing Item"
        }
    }
    
    // MARK: - HTHorizontalSelectionListDelegate Protocol Methods
    
    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
        //update search bar
        let display = SubscriptionDisplay(rawValue: index)!
//        if (display == .Current){
//            displaySearchButton(animated: true)
//        }
        switch display {
            case .Current:
                displaySearchButton(animated: true)
                loadCurrentSubscriptions()
            case .AddNew: displaySearchBarAndCancelButton(animated: true)
        }
    }
    
    
    // MARK: - UITableViewDataSource / Delegate Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == currentSubscriptions) ? currentSubscriptions.count : newSubscriptions.count
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return filteredCategories[section]
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let cell : SubscriptionCell = tableView.dequeueReusableCellWithIdentifier(Identifiers.subscriptionCell, forIndexPath: indexPath) as! SubscriptionCell
        
        if(tableView == currentSubscriptions){
            cell.setRecipe(currentSubscriptions[indexPath.row])
            cell.display = .Current
        } else {
            cell.setRecipe(newSubscriptions[indexPath.row])
            cell.display = .New
        }
        cell.updateDisplay()
        
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //recipeWasSelectedAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //recipeWasSelectedAtIndexPath(indexPath)
    }

}
