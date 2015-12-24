//
//  ParseAPIUtil.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/23/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation
import Parse

class ParseAPIUtil {
    
    /*
    * Async function that retrieves Recipes for the given parameters.
    * Calls completion block with the retrieved Recipes.
    */
    func recipesForDate(date: NSDate, venueKey: String, mealName: String, menuName: String, withBlock successBlock: ([Recipe]) -> Void) {
        
        let components: NSDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
        
        let offeringQuery = Offering.query()!
        offeringQuery.whereKey("month", equalTo: components.month)
        offeringQuery.whereKey("day", equalTo: components.day)
        offeringQuery.whereKey("year", equalTo: components.year)
        offeringQuery.whereKey("venueKey", equalTo: venueKey)
        offeringQuery.whereKey("mealName", equalTo: mealName)
        offeringQuery.whereKey("menuName", equalTo: menuName)
        
        // Get Offering. There should only be one.
        offeringQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                let offerings = objects as! [Offering]
                assert(offerings.count == 1)
                let offering = offerings[0]

                let recipesQuery = offering.relationForKey("recipes").query()
                recipesQuery.limit = 1000
                
                // Get Recipes
                recipesQuery.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        let recipes = objects as! [Recipe]
                        successBlock(recipes)
                    } else {
                        print("Error fetching Recipes for Offering.")
                    }
                }

            } else {
                print("Error fetching Offering.")
            }
        }
    }
    
    
}