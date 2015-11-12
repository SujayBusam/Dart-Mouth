//
//  SearchViewController.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/19/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import UIKit
import RealmSwift

class MenuSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var menuFilter = MenuFilter()
    var allRecipes = [Recipe]()
    var shownRecipes = [Recipe]()
    
    // TODO(sujay): Might not even need these outlets since we only care about changes to any of the three UISegmentedControls and UISearchBar.
    @IBOutlet weak var mealSelector: UISegmentedControl!
    @IBOutlet weak var venueSelector: UISegmentedControl!

    @IBOutlet weak var searchField: UISearchBar! {
        didSet {
            searchField.delegate = self
        }
    }

    @IBOutlet weak var recipeTableView: UITableView!{
        didSet {
            recipeTableView.delegate = self
            recipeTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        // TODO(Sujay): Must be a more "Realm-like" way to do this without iterating over returned collection
        for recipe in realm.objects(Recipe).filter(DateUtil.getTodaysDatePredicate()) {
            allRecipes.append(recipe)
        }
        reloadRecipes()
    }
    
    @IBAction func mealChange(sender: UISegmentedControl) {
        menuFilter.meal = sender.selectedSegmentIndex
        reloadRecipes()
    }
    
    @IBAction func venueChange(sender: UISegmentedControl) {
        menuFilter.venue = sender.selectedSegmentIndex
        reloadRecipes()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        menuFilter.searchText = searchText
        reloadRecipes()
    }
    
    func reloadRecipes() {
        shownRecipes = menuFilter.filter(allRecipes)
        self.recipeTableView.reloadData()
    }
    
    // MARK - TableView
    // This contains the required methods for the tableview delegate/source methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //right now only one section for all the food, could potentially 
        //be divisions for entrees etc
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownRecipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = shownRecipes[indexPath.row].name
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "Show Recipe Nutrition":
                    if let targetViewController = segue.destinationViewController as? RecipeNutritionViewController {
                        let recipeIndex = recipeTableView.indexPathForSelectedRow!.row
                        targetViewController.recipe = shownRecipes[recipeIndex]
                    }
                default: break
            }
        }
    }
    
}
