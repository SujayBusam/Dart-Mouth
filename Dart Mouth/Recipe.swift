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
    
    @NSManaged var dartmouthId: NSNumber
    @NSManaged var name: String
    @NSManaged var rank: NSNumber
    @NSManaged var nutrients: PFObject
    @NSManaged var uuid: String
    @NSManaged var category: String
    
    static func parseClassName() -> String {
        return "Recipe"
    }
}