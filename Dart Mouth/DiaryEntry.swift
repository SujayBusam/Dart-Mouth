//
//  DiaryEntry.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/9/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Parse

class DiaryEntry: PFObject, PFSubclassing {
    
    @NSManaged var date: NSDate
    @NSManaged var user: CustomUser
    @NSManaged var recipe: Recipe
    @NSManaged var servingsMultiplier: Float
    
    static func parseClassName() -> String {
        return "DiaryEntry"
    }
}