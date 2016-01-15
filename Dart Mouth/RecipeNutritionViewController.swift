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
    
    struct Strings {
        static let ErrorNutrientValue = "N/A"
    }
    
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
    @IBOutlet weak var servingSizeValue: UILabel!
    
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
        recipeName?.text = recipe.name
        caloriesValue?.text = "\(recipe.getCalories()?.description ?? Strings.ErrorNutrientValue)"
        totalFatValue?.text = "\(recipe.getTotalFat()?.description ?? Strings.ErrorNutrientValue) g"
        saturatedFatValue?.text = "\(recipe.getSaturatedFat()?.description ?? Strings.ErrorNutrientValue) g"
        cholesterolValue?.text = "\(recipe.getCholesterol()?.description ?? Strings.ErrorNutrientValue) mg"
        sodiumValue?.text = "\(recipe.getSodium()?.description ?? Strings.ErrorNutrientValue) mg"
        totalCarbsValue?.text = "\(recipe.getTotalCarbs()?.description ?? Strings.ErrorNutrientValue) g"
        fiberValue?.text = "\(recipe.getFiber()?.description ?? Strings.ErrorNutrientValue) g"
        sugarsValue?.text = "\(recipe.getFiber()?.description ?? Strings.ErrorNutrientValue) g"
        proteinValue?.text = "\(recipe.getProtein()?.description ?? Strings.ErrorNutrientValue) g"
        servingSizeValue?.text = "\(recipe.getServingSizeGrams()?.description ?? Strings.ErrorNutrientValue) g"

    }
    
    // MARK: - Miscellaneous
    
}
