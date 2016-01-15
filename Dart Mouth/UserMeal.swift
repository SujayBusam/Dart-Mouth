//
//  UserMeal.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/9/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Parse

class UserMeal: PFObject, PFSubclassing {
    
    @NSManaged var title: String // Breakfast, Lunch, Dinner, Snack
    @NSManaged var date: NSDate
    @NSManaged var user: CustomUser
    @NSManaged var entries: [DiaryEntry]
    
    static func parseClassName() -> String {
        return "UserMeal"
    }
    
    
    // MARK: - Useful class helper functions
    
    class func findObjectsInBackgroundWithBlock(block: PFQueryArrayResultBlock,
        forDate date: NSDate, forUser user: CustomUser) -> Void {
        let query = UserMeal.query()!
        query.includeKey("entries.recipe")
        query.includeKey("entries.user")
            
        // Restrict query based on parameters
        query.whereKey("user", equalTo: user)
        query.whereKey("date", greaterThanOrEqualTo: date.startOfDay)
        query.whereKey("date", lessThanOrEqualTo: date.endOfDay!)
            
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
}