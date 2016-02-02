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
    
    func getTotalProtein() -> Float? {
        if let recipeProtein = recipe.getProtein() {
            // Rounds to nearest integer.
            return recipeProtein * self.servingsMultiplier
        }
        return nil
    }
    
    func getTotalCarbs() -> Float? {
        if let recipeCarbs = recipe.getTotalCarbs() {
            // Rounds to nearest integer.
            return recipeCarbs * self.servingsMultiplier
        }
        return nil
    }
    
    func getTotalFat() -> Float? {
        if let recipeFat = recipe.getTotalFat() {
            // Rounds to nearest integer.
            return recipeFat * self.servingsMultiplier
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

                newDiaryEntry.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if success {
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
                        
                        // The user's past recipes need to be updated
                        user.pastRecipes.addObject(recipe)
                        user.saveEventually()
                    } else {
                        print("Error saving DiaryEntry after trying to add to diary from RecipeNutritionVC: \(error)")
                    }
                })
            } else {
                print("Error getting UserMeal after trying to add to diary from RecipeNutritionVC: \(error)")
            }
        }
    }
    
    /*
        Delete DiaryEntry in background with success block. If the UserMeal contains this
        DiaryEntry contains ONLY this DiaryEntry, then that UserMeal is also deleted. 
        Otherwise, the UserMeal is just updated so that the DiaryEntry is removed.
    */
    override func deleteInBackgroundWithBlock(block: PFBooleanResultBlock?) {
        let userMealQuery = UserMeal.query()!
        userMealQuery.whereKey("entries", equalTo: self)
        
        // Get the associated UserMeal
        userMealQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if objects == nil || objects!.count != 1 {
                    print("Bad return on getting associated UserMeal when trying to delete DiaryEntry")
                    return
                }
                
                let userMeal = objects!.first! as! UserMeal
                
                // Remove the DiaryEntry from its UserMeal
                let indexOfEntryToDelete =  userMeal.entries.indexOf { (diaryEntry: DiaryEntry) -> Bool in
                    return diaryEntry.objectId! == self.objectId
                }
                userMeal.entries.removeAtIndex(indexOfEntryToDelete!)
                
                // Delete or update the associated UserMeal as necessary
                if userMeal.entries.isEmpty {
                    userMeal.deleteInBackgroundWithBlock({
                        (success: Bool, error: NSError?) -> Void in
                        if success {
                            print("Deleted UserMeal.")
                            super.deleteInBackgroundWithBlock(block)
                        }
                    })
                } else {
                    userMeal.saveInBackgroundWithBlock({
                        (success: Bool, error: NSError?) -> Void in
                        if success {
                            print("Updating UserMeal")
                            super.deleteInBackgroundWithBlock(block)
                        }
                    })
                }
            
            } else {
                print("Error getting associated UserMeal when trying to delete DiaryEntry")
            }
        }
    }
    
}