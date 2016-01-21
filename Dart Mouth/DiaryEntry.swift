//
//  DiaryEntry.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/9/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Parse

class DiaryEntry: PFObject, PFSubclassing {
    
    @NSManaged var date: NSDate
    @NSManaged var user: CustomUser
    @NSManaged var recipe: Recipe
    @NSManaged var servingsMultiplier: Float
    
    static func parseClassName() -> String {
        return "DiaryEntry"
    }
    
    
    // MARK: - Helper functions
    
    func getTotalCalories() -> Int? {
        if let recipeCals = recipe.getCalories() {
            // Rounds to nearest integer.
            return Int(round(Float(recipeCals) * self.servingsMultiplier))
        }
        return nil
    }
    
    
    // MARK: - Parse helper functions
    
    /*
    Creates a DiaryEntry in the background given these parameters. Executes
    block on succesful completion.
    
    Note that this will create a UserMeal if one does not exist for the passed
    in date and UserMeal title.
    
    TODO: failure handler
    */
    class func createInBackgroundWithBlock(block: PFBooleanResultBlock,
        withUserMealTitle userMealTitle: String, withDate date: NSDate,
        withUser user: CustomUser, withRecipe recipe: Recipe,
        withServingsMultiplier servingsMultiplier: Float) {
        
            
        let userMealQuery = UserMeal.query()!
        userMealQuery.whereKey("title", equalTo: userMealTitle)
        userMealQuery.whereKey("date", greaterThanOrEqualTo: date.startOfDay)
        userMealQuery.whereKey("date", lessThanOrEqualTo: date.endOfDay!)
        userMealQuery.whereKey("user", equalTo: user)
        
        userMealQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                let newDiaryEntry = DiaryEntry()
                newDiaryEntry.date = date
                newDiaryEntry.user = user
                newDiaryEntry.recipe = recipe
                newDiaryEntry.servingsMultiplier = servingsMultiplier
                
                newDiaryEntry.saveInBackgroundWithBlock({ (bool: Bool, error: NSError?) -> Void in
                    if error == nil {
                        let userMeals = objects as! [UserMeal]
                        if !userMeals.isEmpty {
                            let userMeal = userMeals.first!
                            userMeal.entries.append(newDiaryEntry)
                            userMeal.saveInBackgroundWithBlock(block)
                        } else {
                            print("User Meal not found. Creating it now.")
                            let newUserMeal = UserMeal()
                            newUserMeal.title = userMealTitle
                            newUserMeal.date = date
                            newUserMeal.user = user
                            newUserMeal.entries = [newDiaryEntry]
                            newUserMeal.saveInBackgroundWithBlock(block)
                        }
                    } else {
                        print("Error saving DiaryEntry after trying to add to diary from RecipeNutritionVC.")
                    }
                })
            } else {
                print("Error getting UserMeal after trying to add to diary from RecipeNutritionVC.")
            }
        }
    }
}