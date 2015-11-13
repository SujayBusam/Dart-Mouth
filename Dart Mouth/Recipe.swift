//
//  Recipe.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 10/31/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import RealmSwift
import SwiftyJSON

/*
    Represents one food item.

    Important associations:
        Has an associated NutrientPanel
*/
class Recipe: Object {
    
    dynamic var did: Int = 0
    dynamic var name: String = ""
    dynamic var category: String = ""
    
    dynamic var month: Int = 0
    dynamic var day: Int = 0
    dynamic var year: Int = 0
    
    // These determine uniqueness for a Recipe and should be used to query for Recipes
    dynamic var venueKey: String = ""
    dynamic var mealId: Int = 0
    dynamic var menuId: Int = 0
    
    dynamic var nutrientPanel: NutrientPanel?
    
    // TODO: These are present on the backend but might not be necessary here
    dynamic var rank: Int = 0
    dynamic var mmId: Int = 0
    
    /*
        Parses given NSData as JSON, creates all Recipes in them, and saves them.
    */
    class func saveRecipes(json: JSON) {
        if let recipesJSON = json["recipes"].array {
            let realm = try! Realm()
            
            var createdRecipes = [Recipe]()
            
            for recipeJSON in recipesJSON {
                createdRecipes.append(createRecipe(recipeJSON))
            }
            
            print("Writing Recipes and Nutrients")
            try! realm.write {
                realm.add(createdRecipes)
            }
            print("Done writing")
            
        } else {
            // Bad data input.
            // TODO(Sujay): deal with this error.
        }
    }
    
    /*
        Create a single Recipe from JSON. Does not write to Realm.
        Creation of a Recipe necessitates creation of its NutrientPanel. Both are returned in a tuple.
        TODO(Sujay): May need a custom primary key for each Recipe
    */
    class func createRecipe(json: JSON) -> Recipe {
        let recipe = Recipe()
        
        let nutrientPanel = NutrientPanel.createNutrientPanel(json["nutrients"])
        
        recipe.did = json["did"].number!.integerValue
        recipe.name = json["name"].string!
        recipe.category = json["category"].string!
        
        recipe.day = json["day"].number!.integerValue
        recipe.month = json["month"].number!.integerValue
        recipe.year = json["year"].number!.integerValue
        
        recipe.venueKey = json["venueKey"].string!
        recipe.mealId = json["mealId"].number!.integerValue
        recipe.menuId = json["menuId"].number!.integerValue
        
        recipe.nutrientPanel = nutrientPanel
        recipe.rank = json["rank"].number!.integerValue
        recipe.mmId = json["mmId"].number!.integerValue
        
        return recipe
    }
    
    // Specify properties to ignore (Realm won't persist these)
        
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }

}
