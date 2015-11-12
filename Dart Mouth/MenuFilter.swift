//
//  MenuFilter.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/19/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import Foundation

struct MenuFilter {
    
    var meal : Int = 0
    var venue : Int = 0
    var searchText : String = ""
    
    // Dictionary that maps a Recipe's VenueKey to the proper Int value for a MenuFilter's meal property.
    let venueKeyDict: [String: Int] = [
        // TODO(sujay): make this programmatic
        "DDS" : 0,
        "CYC" : 2,
        "NOVACK": 3
    ]
    
    // Dictionary that maps a Recipe's mealId to the proper Int value for a MenuFilter's meal property.
    let mealIdDict: [Int: Int] = [
        // TODO(sujay): make this programmatic
        1: 0, // Breakfast
        3: 1, // Lunch
        5: 2, // Dinner
        16: 3 // Late Night
    ]
    
    func filter(allItems : [Recipe]) -> [Recipe] {
        return allItems.filter({ (recipe : Recipe) -> Bool in
            let mealMatch = mealIdDict[recipe.mealId] == meal
            let venueMatch = venueKeyDict[recipe.venueKey] == venue
            let stringMatch = searchText.isEmpty || recipe.name.lowercaseString.rangeOfString(self.searchText.lowercaseString) != nil
            return (mealMatch && venueMatch && stringMatch)
        })
    }
    
}
