//
//  DatabaseRecipe.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/30/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

/**
    Data model that encapsulates the JSON data returned from USDA
    database after querying for a food item using a search term.

    Note that this does not contain nutrition info, only the ndbno
    used to query for nutrition info.
**/
import Foundation
import SwiftyJSON

class DatabaseRecipe {
    
    var group: String
    var name: String
    var ndbno: String
    
    init(group: String, name: String, ndbno: String) {
        self.group = group
        self.name = name
        self.ndbno = ndbno
    }
    
    
    // MARK: - Useful class helper functions
    
    class func isValidJSON(recipeJSON: JSON) -> Bool {
        return recipeJSON["group"].isExists() && recipeJSON["name"].isExists()
            && recipeJSON["ndbno"].isExists()
    }
    
}