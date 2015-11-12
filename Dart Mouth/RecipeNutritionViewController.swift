//
//  RecipeNutritionViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/7/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit

/*
    UIViewController for a selected Recipe's nutritional information (Nutrient Panel data).
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
    
    // TODO(Sujay): Find out if this should really be an implicitly unwrapped optional?
    // My thinking was it should be since recipe should never be nil here.
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
        let nutrientPanel = recipe.nutrientPanel!
        
        // TODO(Sujay): Get rid of hardcoding of units
        recipeName?.text = recipe.name
        caloriesValue?.text = "\(nutrientPanel.calories)"
        totalFatValue?.text = "\(nutrientPanel.totalFat) g"
        saturatedFatValue?.text = "\(nutrientPanel.saturatedFat) g"
        cholesterolValue?.text = "\(nutrientPanel.cholesterol) g"
        sodiumValue?.text = "\(nutrientPanel.sodium) mg"
        totalCarbsValue?.text = "\(nutrientPanel.totalCarbs) g"
        fiberValue?.text = "\(nutrientPanel.fiber) g"
        sugarsValue?.text = "\(nutrientPanel.sugars) g"
        proteinValue?.text = "\(nutrientPanel.protein) g"
    }

}
