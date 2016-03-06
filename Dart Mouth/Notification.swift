//
//  Notification.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 3/6/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Parse

class Notification: PFObject, PFSubclassing {
    
    @NSManaged var user: CustomUser
    @NSManaged var recipeID: Int
    @NSManaged var onDate: NSDate
    @NSManaged var seen: Bool
    @NSManaged var uuid: String
    
    // Offering related
    @NSManaged var recipeName: String
    @NSManaged var venueKey: String
    @NSManaged var mealName: String
    @NSManaged var menuName: String
    @NSManaged var day: Int
    @NSManaged var month: Int
    @NSManaged var year: Int
    
    static func parseClassName() -> String {
        return "Notification"
    }
}