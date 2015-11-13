//
//  DartFoodAPI.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/4/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

/*
    iOS API for interfacing with the Dartmouth Nutrition Backend
*/
class DartFoodAPI {
    
    struct ApiConstants {
        static let baseUrl = "https://ancient-springs-1342.herokuapp.com/api/v1"
        
        // For Recipes
        static let recipesEndpoint = "/recipes"
        static let recipesParametersFormat = "?day=%d&month=%d&year=%d"
        static let recipesUrlFormat = baseUrl + recipesEndpoint + recipesParametersFormat
        
        // For Venues
        static let venuesEndpoint = "/venues"
    }
    
    /*
        Hit the backend and get all Recipes for a certain day, month, year.
        The returned JSON is contained in 'data' which is of type NSData.
        A passed in completionHandler function is called with this data. It is executed on the main thread so this data can be written to Realm.
    */
    func getRecipesForDate(day day: Int, month: Int, year: Int, successHandler: JSON -> Void) {
        let urlString = String(format: ApiConstants.recipesUrlFormat, day, month, year)
        let endpointUrl = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(endpointUrl, completionHandler: {
            (data, response, error) -> Void in
            
            if error != nil {
                // TODO(Sujay): Deal with server error.
                print("Error getting Recipes from server")
            } else {
                // TODO(Sujay): Probably should surround with try-catch instead of forced try. E.g. what if response is unexpected or not JSON?
                let jsonObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                let json = JSON(jsonObject)

                // Have to perform on main queue.
                dispatch_async(dispatch_get_main_queue(), {
                    print("Executing success handler")
                    successHandler(json)
                })
            }
        })
        
        print("Hitting backend")
        task.resume()
    }
}
