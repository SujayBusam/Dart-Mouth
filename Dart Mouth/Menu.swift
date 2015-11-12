//
//  Menu.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/2/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import RealmSwift

/*
    Represents a menu such as "Everyday Items" or "Today's Specials"
    Important associations:
        Backlinks to all Mealtimes that offer this Menu
*/

class Menu: Object {
    
    dynamic var did: Int = 0
    dynamic var name: String = ""
    
    var mealtimes: [Mealtime] {
        // Define mealtimes as the inverse relationship to Mealtime.venue
        return linkingObjects(Mealtime.self, forProperty: "menus")
    }
    
    override static func primaryKey() -> String? {
        return "did"
    }
    
    // Specify properties to ignore (Realm won't persist these)
        
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
