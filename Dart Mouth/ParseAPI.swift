//
//  ParseAPIUtil.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/23/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation
import Parse

/*
* A class with some app-specific, useful wrapper functions around the Parse API
*/
class ParseAPI {
    
    /*
    * Async function that retrieves Recipes for the given parameters.
    * Calls completion block with the retrieved Recipes.
    */
    func recipesFromCloudForDate(date: NSDate, venueKey: String, mealName: String,
        menuName: String, orderAlphabetically: Bool,
        withCompletionHandler completionHandler: ([Recipe]?) -> Void) {
        
        let components: NSDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
        
        let offeringQuery = Offering.query()!
        offeringQuery.whereKey("month", equalTo: components.month)
        offeringQuery.whereKey("day", equalTo: components.day)
        offeringQuery.whereKey("year", equalTo: components.year)
        offeringQuery.whereKey("venueKey", equalTo: venueKey)
        offeringQuery.whereKey("mealName", equalTo: mealName)
        offeringQuery.whereKey("menuName", equalTo: menuName)
        
        // Get Offering. There should only be one or zero.
        offeringQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                let offerings = objects as! [Offering] // TODO: potential crash here. Implement safeguard
                if offerings.isEmpty {
                    completionHandler(nil)
                } else {
                    let offering = offerings[0]
                    
                    let recipesQuery = offering.relationForKey("recipes").query()
                    recipesQuery.limit = 1000
                    if orderAlphabetically { recipesQuery.orderByAscending("name") }
                    
                    // Get Recipes
                    recipesQuery.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            let recipes = objects as! [Recipe]
                            completionHandler(recipes)
                        } else {
                            print("Error fetching Recipes for Offering.")
                        }
                    }
                }
                
            } else {
                print("Error fetching Offering.")
            }
        }
    }
    
    
}