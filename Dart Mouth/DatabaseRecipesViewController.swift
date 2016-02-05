//
//  DatabaseRecipesViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/23/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import MBProgressHUD

protocol DatabaseRecipesViewControllerDelegate: class {
    func databaseRecipesVCDidAppear(sender: DatabaseRecipesViewController)
    func didSelectDBRecipeForDBRecipesView(dbRecipe: DatabaseRecipe, sender: DatabaseRecipesViewController)
}

class DatabaseRecipesViewController: SearchableViewController,
    UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate {
    
    
    // MARK: - Local Constants
    
    private struct Identifiers {
        static let recipeCell: String = "DBRecipeCell"
        static let DatabaseSearchError = "Search again or create a custom food."
    }
    
    
    // MARK: - Instance variables
    
    var currentSearchText: String?
    var currentRecipes: [DatabaseRecipe] = [DatabaseRecipe]()
    var delegate: DatabaseRecipesViewControllerDelegate!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var recipesTableView: UITableView! {
        didSet {
            recipesTableView.dataSource = self
            recipesTableView.delegate = self
            recipesTableView.emptyDataSetSource = self
            recipesTableView.emptyDataSetDelegate = self
            recipesTableView.tableFooterView = UIView()
        }
    }
    
    
    // MARK: - View Setup

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        delegate.databaseRecipesVCDidAppear(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Unselect the previously selected item, if there was one.
        if let indexPathForSelectedRow = self.recipesTableView.indexPathForSelectedRow {
            self.recipesTableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DB Recipes VC did load.")

        updateSearchData()
    }

    
    func updateSearchData() {
        guard self.currentSearchText != nil && !self.currentSearchText!.isEmpty else {
            self.currentRecipes.removeAll()
            self.recipesTableView.reloadData()
            return
        }
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.userInteractionEnabled = false
        
        self.currentRecipes.removeAll()
        
        DatabaseRecipe.findDatabaseRecipesWithSearchText(self.currentSearchText!,
            withSuccesBlock: { (dbRecipes: [DatabaseRecipe]) -> Void in
                // The success handler. On UI thread.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.currentRecipes = dbRecipes
                    self.recipesTableView.reloadData()
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
            },
            withFailureBlock: { (errorMessage: String) -> Void in
                // The failure handler. On UI thread.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the error message as an alert
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    let alert = UIAlertController(title: errorMessage, message: Identifiers.DatabaseSearchError, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            })
    }
    

    // MARK: - Other Overrides
    
    override func searchTextChanged(newSearchText: String?) {
        super.searchTextChanged(newSearchText)
        self.currentSearchText = newSearchText
        if newSearchText == nil || newSearchText!.isEmpty {
            self.updateSearchData()
        }
    }
    
    override func searchRequested() {
        super.searchRequested()
        self.updateSearchData()
    }
    
    // MARK: - UITableViewDataSource / Delegate Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentRecipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCellWithIdentifier(Identifiers.recipeCell, forIndexPath: indexPath)
        
        let recipe = currentRecipes[indexPath.row]
        cell.textLabel?.text = recipe.name
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .Default
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.didSelectDBRecipeForDBRecipesView(self.currentRecipes[indexPath.row], sender: self)
    }
    
    
    // MARK: - DZNEmptyDataSetSource / Delegate protocol methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Search the USDA Database for Foods")
    }
    
}
