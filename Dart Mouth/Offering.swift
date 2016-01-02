//
//  Offering.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/23/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Parse

class Offering: PFObject, PFSubclassing {
    
    @NSManaged var uuid: String
    @NSManaged var month: Int
    @NSManaged var day: Int
    @NSManaged var year: Int
    @NSManaged var venueKey: String
    @NSManaged var mealName: String
    @NSManaged var menuName: String
    @NSManaged var recipes: PFRelation
    
    static func parseClassName() -> String {
        return "Offering"
    }
}