//
//  Venue.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/2/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import RealmSwift

/*
    Represents a venue such as "53 Commons"

    Important Associations:
        Has a list of associated Mealtimes
*/
class Venue: Object {
    
    dynamic var name: String = ""
    dynamic var key: String = ""
    
    let mealtimes = List<Mealtime>()
    
    // Specify properties to ignore (Realm won't persist these)
        
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
