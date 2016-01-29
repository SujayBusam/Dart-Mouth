//
//  PreviousRecipesViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/23/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import ChameleonFramework
import MBProgressHUD
import Parse

protocol PreviousRecipesViewControllerDelegate: class {
    func didSelectRecipeForPreviousRecipesView(recipe: Recipe, sender: PreviousRecipesViewController) -> Void
}

class PreviousRecipesViewController: SearchableViewController,
    UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Local Constants
    
    private struct Identifiers {
        static let RecipeCell = "PastRecipeCell"
    }
    
    
    // MARK: - Instance variables
    
    var allRecipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    
    var currentSearchText: String? {
        didSet {
            // NOTE: doesn't need to call updateUI() since other values such as
            // current venue or date haven't changed. Therefore, API calls do not
            // need to be made. We only update the filtered.
            // This will not call the backend at all.
            setFilteredRecipesWithSearchText(currentSearchText)
        }
    }
    
    weak var delegate: PreviousRecipesViewControllerDelegate!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var previousRecipesTableView: UITableView! {
        didSet {
            previousRecipesTableView.dataSource = self
            previousRecipesTableView.delegate = self
        }
    }
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        print("PreviousRecipesVC did load.")
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("PreviousRecipesVC will appear.")
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.userInteractionEnabled = false
        
        // TODO: need to restrict this to something like the past 2 weeks
        CustomUser.currentUser()!.findAllPreviousRecipesWithCompletionHandler(self.getPreviousRecipesCompletionHandler)
    }
    
    
    // MARK: - UITableViewDataSource / Delegate Protocol Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredRecipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = previousRecipesTableView.dequeueReusableCellWithIdentifier(Identifiers.RecipeCell, forIndexPath: indexPath)
        let recipe = self.filteredRecipes[indexPath.row]
        
        cell.textLabel?.text = recipe.name
        cell.detailTextLabel?.text = "\(recipe.getCalories()?.description ?? "-") cals"
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .Default
        
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        recipeWasSelectedAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        recipeWasSelectedAtIndexPath(indexPath)
    }
    
    
    // MARK: - Navigation
    
    func recipeWasSelectedAtIndexPath(indexPath: NSIndexPath) {
        let selectedRecipe = self.filteredRecipes[indexPath.row]
        delegate.didSelectRecipeForPreviousRecipesView(selectedRecipe, sender: self)
    }
    
    
    // MARK: - Helper Functions
    
    func getPreviousRecipesCompletionHandler(recipes: [Recipe]?) -> Void {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.populateAllRecipes(recipes)
            self.setFilteredRecipesWithSearchText(self.currentSearchText)
            
            // Every time UI updates, table view should reset to top,
            // as long as it's not empty.
            if !self.filteredRecipes.isEmpty {
                self.previousRecipesTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            }
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func populateAllRecipes(recipes: [Recipe]?) {
        // Clear the current data
        self.allRecipes.removeAll()
        
        guard recipes != nil else { return }
        
        // Repopulate
        self.allRecipes = recipes!
    }
    
    func populateFilteredRecipes(recipes: [Recipe]) {
        // Clear the current data
        self.filteredRecipes.removeAll()
        
        // Repopulate
        self.filteredRecipes = recipes
    }
    
    func setFilteredRecipesWithSearchText(searchText: String?) {
        guard searchText != nil && !searchText!.isEmpty else {
            self.filteredRecipes = self.allRecipes
            self.previousRecipesTableView.reloadData()
            return
        }
        
        let searchText = searchText!.lowercaseString.trim()
        let filteredRecipes: [Recipe] = self.allRecipes.filter {
            (recipe: Recipe) -> Bool in
            return recipe.name.lowercaseString.containsString(searchText)
        }
        
        populateFilteredRecipes(filteredRecipes)
        self.previousRecipesTableView.reloadData()
    }
    
    
    // MARK: - Other Overrides
    
    override func setSearchText(searchText: String?) {
        self.currentSearchText = searchText
    }
    
}
