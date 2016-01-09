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
}