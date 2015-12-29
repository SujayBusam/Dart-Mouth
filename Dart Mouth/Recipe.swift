//
//  Recipe.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/22/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation
import Parse

class Recipe: PFObject, PFSubclassing {
    
    @NSManaged var dartmouthId: Int
    @NSManaged var name: String
    @NSManaged var rank: Int
    // Nutrients is a dictionary of dictionaries. Look at Parse data browser to see how the JSON is formatted.
    // For the inner Dictionary, the value is of type AnyObject because it can be a string, nil, or an int.
    @NSManaged var nutrients: Dictionary<String, Dictionary<String, AnyObject>>
    @NSManaged var uuid: String
    @NSManaged var category: String
    
    static func parseClassName() -> String {
        return "Recipe"
    }
}