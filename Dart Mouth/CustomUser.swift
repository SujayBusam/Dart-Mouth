//
//  CustomUser.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/1/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Parse

class CustomUser: PFUser {
    
    @NSManaged var goalDailyCalories: Int
    
    // See http://stackoverflow.com/questions/32041247/declare-a-read-only-nsmanaged-property-in-swift-for-parses-pfrelation
    var pastRecipes: PFRelation! {
        return relationForKey("pastRecipes")
    }
}
