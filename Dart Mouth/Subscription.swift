//
//  Subscription.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 3/4/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Parse

class Subscription: PFObject, PFSubclassing {
    
    @NSManaged var user: CustomUser
    @NSManaged var recipes: [Recipe]
    
    static func parseClassName() -> String {
        return "Subscription"
    }
    
}