//
//  Recipe.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/22/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Parse

class Recipe: PFObject, PFSubclassing {
    
    @NSManaged var createdBy: PFUser
    @NSManaged var dartmouthId: Int
    @NSManaged var name: String
    @NSManaged var rank: Int
    // Nutrients is a dictionary whose key type is a dictionary. 
    // Look at Parse data browser to see how the JSON is formatted.
    // For the inner Dictionary, the value is of type NSObject because
    // it can be a string or an int, depending on the key.
    @NSManaged var nutrients: Dictionary<String, Dictionary<String, NSObject>>
    @NSManaged var uuid: String
    @NSManaged var category: String
    
    static func parseClassName() -> String {
        return "Recipe"
    }
}