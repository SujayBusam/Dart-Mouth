//
//  Recipe.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/22/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Parse

class Recipe: PFObject, PFSubclassing {
    
    struct Fields {
        static let NutrientResults = "result"
        static let Calories = "calories"
        static let TotalFat = "fat"
        static let SaturatedFat = "sfa"
        static let Cholesterol = "cholestrol"
        static let Sodium = "sodium"
        static let TotalCarbs = "carbs"
        static let Fiber = "fiberdtry"
        static let Sugars = "sugars"
        static let Protein = "protein"
        static let Bogus = "Bogus"
    }
    
    @NSManaged var createdBy: PFUser
    @NSManaged var name: String
    // Nutrients is a dictionary whose key type is a dictionary.
    // Look at Parse data browser to see how the JSON is formatted.
    // For the inner Dictionary, the value is of type NSObject because
    // it can be a string or an int, depending on the key.
    @NSManaged var nutrients: Dictionary<String, Dictionary<String, NSObject>>
    @NSManaged var category: String
    
    // Fields below are specific to DDS Recipes. Can be undefined for custom ones.
    @NSManaged var uuid: String
    @NSManaged var rank: Int
    @NSManaged var dartmouthId: Int
    
    
    static func extractDigitsFromString(string: String?) -> Int? {
        guard string != nil && !string!.isEmpty else { return nil }
        
        var extracted = ""
        for char in string!.characters { // TODO: strip
            if char >= "0" && char <= "9" {
                extracted.append(char)
            }
        }
        return Int(extracted)
    }
    
    static func extractFloatFromString(string: String?) -> Float? {
        guard string != nil && !string!.isEmpty else { return nil }
        
        var extracted = ""
        var decimalFound = false
        for char in string!.characters { // TODO: strip
            if char == " " && !extracted.isEmpty { break }
            
            if char == "." {
                if decimalFound {
                    break
                } else {
                    decimalFound = true
                    extracted.append(char)
                }
            }
            
            if (char >= "0" && char <= "9") {
                extracted.append(char)
            }
        }
        return Float(extracted)
    }
    
    
    // MARK: - instance functions (getters) that get various nutrients
    
    func getAllNutrients() -> [String : NSObject]? {
        return self.nutrients[Fields.NutrientResults]
    }
    
    func getCalories() -> Int? {
        let calorieString = getAllNutrients()?[Fields.Calories] as? String
        return Recipe.extractDigitsFromString(calorieString)
    }
    
    func getTotalFat() -> Float? {
        let fatString =  getAllNutrients()?[Fields.TotalFat] as? String
        return Recipe.extractFloatFromString(fatString)
    }
    
    func getSaturatedFat() -> Float? {
        let fatString = getAllNutrients()?[Fields.SaturatedFat] as? String
        return Recipe.extractFloatFromString(fatString)
    }
    
    func getCholesterol() -> Float? {
        let cholesterolString = getAllNutrients()?[Fields.Cholesterol] as? String
        return Recipe.extractFloatFromString(cholesterolString)
    }
    
    func getSodium() -> Float? {
        let sodiumString = getAllNutrients()?[Fields.Sodium] as? String
        return Recipe.extractFloatFromString(sodiumString)
    }
    
    func getTotalCarbs() -> Float? {
        let totalCarbsString = getAllNutrients()?[Fields.TotalCarbs] as? String
        return Recipe.extractFloatFromString(totalCarbsString)
    }
    
    func getFiber() -> Float? {
        let fiberString = getAllNutrients()?[Fields.Fiber] as? String
        return Recipe.extractFloatFromString(fiberString)
    }
    
    func getSugars() -> Float? {
        let sugarsString = getAllNutrients()?[Fields.Sugars] as? String
        return Recipe.extractFloatFromString(sugarsString)
    }
    
    func getProtein() -> Float? {
        let proteinString = getAllNutrients()?[Fields.Protein] as? String
        return Recipe.extractFloatFromString(proteinString)
    }
    
    // For testing
    // TODO: remove
    func getBogus() -> Float? {
        let bogusString = getAllNutrients()?[Fields.Bogus] as? String
        return Recipe.extractFloatFromString(bogusString)
    }
    
    static func parseClassName() -> String {
        return "Recipe"
    }
}