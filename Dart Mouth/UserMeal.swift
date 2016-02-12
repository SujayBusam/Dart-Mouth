//
//  UserMeal.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/9/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Parse

class UserMeal: PFObject, PFSubclassing {
    
    @NSManaged var title: String // Breakfast, Lunch, Dinner, Snacks
    @NSManaged var date: NSDate
    @NSManaged var user: CustomUser
    @NSManaged var entries: [DiaryEntry]
    
    static func parseClassName() -> String {
        return "UserMeal"
    }
    
    
    // MARK: - Useful class helper functions
    
    class func findObjectsInBackgroundWithBlock(block: PFQueryArrayResultBlock,
        forDate date: NSDate, forUser user: CustomUser) -> Void {
        findObjectsInBackgroundWithBlockWithinRange(block, startDate: date, endDate: date, forUser: user)
    }
    
    class func findObjectsInBackgroundWithBlockWithinRange(block: PFQueryArrayResultBlock,
        startDate: NSDate, endDate: NSDate, forUser user: CustomUser) -> Void {
            let query = UserMeal.query()!
            query.includeKey("entries.recipe")
            query.includeKey("entries.user")
            
            // Restrict query based on parameters
            query.whereKey("user", equalTo: user)
            query.whereKey("date", greaterThanOrEqualTo: startDate.startOfDay)
            query.whereKey("date", lessThanOrEqualTo: endDate.endOfDay!)
            
            query.findObjectsInBackgroundWithBlock(block)
    }
    
    class func findRecentObjectsInBackgroundWithBlock(block: PFQueryArrayResultBlock, forUser user: CustomUser, withSkip skip: Int,
        withLimit limit: Int) {
        
        let query = UserMeal.query()!
        query.includeKey("entries.recipe")
        query.includeKey("entries.user")
        
        // Restrict query based on parameters
        query.whereKey("user", equalTo: user)
        query.orderByDescending("date")
        query.limit = limit
        query.skip = skip
        
        query.findObjectsInBackgroundWithBlock(block)
    }
    
    
    // MARK: - Useful instance helper functions
    
    func getCumulativeCalories() -> Int {
        var total: Int = 0
        for entry in self.entries {
            if let cals = entry.getTotalCalories() {
                total += cals
            }
        }
        return total
    }
    
    func getCumulativeProtein() -> Float {
        var total: Float = 0
        for entry in self.entries {
            if let protein = entry.getTotalProtein() {
                total += protein
            }
        }
        return total
    }
    
    func getCumulativeCarbs() -> Float {
        var total: Float = 0
        for entry in self.entries {
            if let carbs = entry.getTotalCarbs() {
                total += carbs
            }
        }
        return total
    }
    
    func getCumulativeFat() -> Float {
        var total: Float = 0
        for entry in self.entries {
            if let fat = entry.getTotalFat() {
                total += fat
            }
        }
        return total
    }
    
    /**
    Return the names of all Recipes within this UserMeal, separated by given string.
     
    Returns nil if this UserMeal has no DiaryEntries, which should not be the case
    if all apps delete UserMeals once their entries are empty.
    **/
    func getStringSeparatedRecipes(separator: String) -> String? {
        guard !self.entries.isEmpty else { return nil }
        
        return self.entries.map({ (entry: DiaryEntry) -> String in
            return entry.recipe.name.trim()
        }).joinWithSeparator(separator)
    }
}