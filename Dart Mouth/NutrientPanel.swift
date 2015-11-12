//
//  NutrientPanel.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/2/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class NutrientPanel: Object {
    
    // TODO(Sujay): add the comprehensive nutrient properties and percentage values
    dynamic var calories: Int = 0
    dynamic var totalCarbs: Float = 0.0
    dynamic var totalFat: Float = 0.0
    dynamic var saturatedFat: Float = 0.0
    dynamic var cholesterol: Float = 0.0
    dynamic var sodium: Float = 0.0
    dynamic var fiber: Float = 0.0 // Is a carb
    dynamic var sugars: Float = 0.0 // Is a carb
    dynamic var protein: Float = 0.0
    
    /*
        Create a single NutrientPanel from JSON.
        Returns the created NutrientPanel.
        // TODO(Sujay): Probably want to return an optional here instead. Also find out if things break if a value is an empty string.
    */
    class func createNutrientPanel(json: JSON) -> NutrientPanel {
        let nutrientPanel = NutrientPanel()
        
        // Assign nutrient values
        nutrientPanel.calories = json["calories"].number!.integerValue
        nutrientPanel.totalCarbs = NutrientUtil.parseNutrientValue(json["carbs"].string!)
        nutrientPanel.totalFat = NutrientUtil.parseNutrientValue(json["fat"].string!)
        nutrientPanel.saturatedFat = NutrientUtil.parseNutrientValue(json["sfa"].string!)
        nutrientPanel.cholesterol = NutrientUtil.parseNutrientValue(json["cholestrol"].string!)
        nutrientPanel.sodium = NutrientUtil.parseNutrientValue(json["sodium"].string!)
        nutrientPanel.fiber = NutrientUtil.parseNutrientValue(json["fiberdtry"].string!)
        nutrientPanel.sugars = NutrientUtil.parseNutrientValue(json["sugars"].string!)
        nutrientPanel.protein = NutrientUtil.parseNutrientValue(json["protein"].string!)
        
        // Write to Realm
        let realm = try! Realm()
        try! realm.write {
            print("Writing Nutrient Panel")
            realm.add(nutrientPanel)
        }
        
        return nutrientPanel
    }
    
    
    // Specify properties to ignore (Realm won't persist these)
        
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
