//
//  DatabaseRecipesViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/23/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Alamofire

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

        updateUI()
    }

    
    func updateUI() {
        guard self.currentSearchText != nil else { return }
        
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
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    

    // MARK: - Other Overrides
    
    override func searchTextChanged(newSearchText: String?) {
        super.searchTextChanged(newSearchText)
        self.currentSearchText = newSearchText
    }
    
    override func searchRequested() {
        super.searchRequested()
        self.updateUI()
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
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .Default
        
        return cell
    }
}
