//
//  DatabaseRecipesViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/23/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

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
    
    var currentSearchText: String? {
        didSet {
            updateUI()
        }
    }
    
    var currentRecipes: [Recipe] = [Recipe]()
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
       
    }
    

    // MARK: - Other Overrides
    
    override func setSearchText(searchText: String?) {
        // TODO: implement
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
        cell.detailTextLabel?.text = "\(recipe.getCalories()?.description ?? "-") cals"
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .Default
        
        return cell
    }
}


