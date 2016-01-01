//
//  RecipeNutritionViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/7/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit

/*
* UIViewController for a selected Recipe's nutritional information
*/
class RecipeNutritionViewController: UIViewController {
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var caloriesValue: UILabel!
    @IBOutlet weak var totalFatValue: UILabel!
    @IBOutlet weak var saturatedFatValue: UILabel!
    @IBOutlet weak var cholesterolValue: UILabel!
    @IBOutlet weak var sodiumValue: UILabel!
    @IBOutlet weak var totalCarbsValue: UILabel!
    @IBOutlet weak var fiberValue: UILabel!
    @IBOutlet weak var sugarsValue: UILabel!
    @IBOutlet weak var proteinValue: UILabel!
    
    var recipe: Recipe! {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Method to call if any or all displayed nutrition values need updating.
    func updateUI() {
        if let nutrients = recipe.nutrients["result"] {
            
            // TODO(Sujay): Get rid of hardcoding and make these values calculated properties of Recipe
            recipeName?.text = recipe.name
            caloriesValue?.text = "\(nutrients["calories"]!)"
            totalFatValue?.text = "\(nutrients["fat"]!)"
            saturatedFatValue?.text = "\(nutrients["sfa"]!)"
            cholesterolValue?.text = "\(nutrients["cholestrol"]!)"
            sodiumValue?.text = "\(nutrients["sodium"]!)"
            totalCarbsValue?.text = "\(nutrients["carbs"]!)"
            fiberValue?.text = "\(nutrients["fiberdtry"]!)"
            sugarsValue?.text = "\(nutrients["sugars"]!)"
            proteinValue?.text = "\(nutrients["protein"]!)"
        }
    }
    
    // MARK: - Miscellaneous
    
}
