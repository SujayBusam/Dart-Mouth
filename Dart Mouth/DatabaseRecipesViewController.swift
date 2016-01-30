//
//  DatabaseRecipesViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/23/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol DatabaseRecipesViewControllerDelegate: class {
    func databaseRecipesVCDidAppear(sender: DatabaseRecipesViewController)
}

class DatabaseRecipesViewController: SearchableViewController,
    UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Local Constants
    
    private struct Identifiers {
        static let recipeCell: String = "DBRecipeCell"
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
        }
    }
    
    
    // MARK: - View Setup

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        delegate.databaseRecipesVCDidAppear(self)
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
        
        self.currentRecipes.removeAll()
        
        let parameters: [String : String] = [
            "api_key" : Constants.FoodDatabase.ApiKey,
            "q" : self.currentSearchText!,
            "sort" : "r",
            "max" : "50",
            "offset" : "0",
            "format" : "JSON"
        ]
        
        Alamofire.request(.GET, Constants.FoodDatabase.BaseUrl, parameters: parameters)
            .responseJSON { (response: Response<AnyObject, NSError>) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard response.result.error == nil else {
                        // Error in making the request
                        print("Error searching food database for \(self.currentSearchText!)")
                        print(response.result.error!)
                        return
                    }
                    
                    if let responseValue = response.result.value {
                        let responseJSON = JSON(responseValue)
                        print("JSON: \(responseJSON)")
                        
                        if let dbRecipes = responseJSON["list"]["item"].array {
                            for dbRecipe in dbRecipes {
                                guard DatabaseRecipe.isValidJSON(dbRecipe) else {
                                    print("This item: \(dbRecipe) does not have valid fields. Skipping.")
                                    continue
                                }
                                
                                self.currentRecipes.append(DatabaseRecipe(group: dbRecipe["group"].stringValue,
                                    name: dbRecipe["name"].stringValue, ndbno: dbRecipe["ndbno"].stringValue))
                            }
                        } else {
                            print("Item not found.")
                        }
                    }
                    self.recipesTableView.reloadData()
                })
        }
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
}
