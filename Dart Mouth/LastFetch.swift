//
//  LastFetch.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/10/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import RealmSwift

/*
    A model used to determine if Recipe and/or Venue data was fetched from the server on a given day.
    An instance of this model must be created and saved every time the daily fetch is made.
    This is temporary and should be replaced with a better solution - maybe a user default.
*/
class LastFetch: Object {
    
    dynamic var day: Int = 0
    dynamic var month: Int = 0
    dynamic var year: Int = 0
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
