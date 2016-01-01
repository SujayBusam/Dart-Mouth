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
    func recipesFromCloudForDate(date: NSDate, venueKey: String?, mealName: String?,
        menuName: String?, orderAlphabetically: Bool,
        withCompletionHandler completionHandler: ([Recipe]?) -> Void) {
        
        let components: NSDateComponents = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
        
        let offeringQuery = Offering.query()!
        offeringQuery.cachePolicy = .CacheElseNetwork
        offeringQuery.whereKey("month", equalTo: components.month)
        offeringQuery.whereKey("day", equalTo: components.day)
        offeringQuery.whereKey("year", equalTo: components.year)
        if venueKey != nil { offeringQuery.whereKey("venueKey", equalTo: venueKey!) }
        if mealName != nil { offeringQuery.whereKey("mealName", equalTo: mealName!) }
        if menuName != nil { offeringQuery.whereKey("menuName", equalTo: menuName!) }
        print("Offerings Cache: \(offeringQuery.hasCachedResult())")
        
        // Get Offering. There should only be one or zero.
        offeringQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                let offerings = objects as! [Offering] // TODO: potential crash here. Implement safeguard
                if offerings.isEmpty {
                    completionHandler(nil)
                } else {
                    // Get all Recipe relations for all Offerings queried above
                    var relationQueries = [PFQuery]()
                    for offering in offerings {
                        relationQueries.append(offering.relationForKey("recipes").query())
                    }
                    
                    
                    let recipesQuery = PFQuery.orQueryWithSubqueries(relationQueries)
                    recipesQuery.cachePolicy = .CacheElseNetwork
                    if orderAlphabetically { recipesQuery.orderByAscending("name") }
                    recipesQuery.limit = 1000
                    print("Recipes Cache: \(recipesQuery.hasCachedResult())")
                    
                    // Get Recipes
                    recipesQuery.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            let recipes = objects as! [Recipe] // TODO: potential crash here. Implement safeguard
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