//
//  Mealtime.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/2/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import RealmSwift

/*
    Represents a mealtime such as "Breakfast" or "Late Night"

    Important associations:
        Has a list of associated Menus
        Backlinks to all Venues with this Mealtime e.g. both "53 Commons" and "Courtyard Cafe" have a "Dinner" Mealtime
*/

class Mealtime: Object {
    
    dynamic var did: Int = 0
    dynamic var name: String = ""
    dynamic var code: String = "" // e.g. "DIN" for dinner, "BRK" for breakfast
    dynamic var venueKey: String = "" // e.g. "53 Commons". This important to differentiate same mealtimes for different venues e.g. "Dinner" at both "53 Commons" and "Courtyard Cafe".
    let menus = List<Menu>()
    
    dynamic var startTime: Int = 0 // e.g. 1700
    dynamic var endTime: Int = 0 // e.g. 2000
    
    var venues: [Venue] {
        return linkingObjects(Venue.self, forProperty: "mealtimes")
    }
    
    // Specify properties to ignore (Realm won't persist these)
        
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
