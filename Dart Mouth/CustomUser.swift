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
    @NSManaged var 
    
    // See http://stackoverflow.com/questions/32041247/declare-a-read-only-nsmanaged-property-in-swift-for-parses-pfrelation
    var pastRecipes: PFRelation! {
        return relationForKey("pastRecipes")
    }
    
    
    // MARK: - Useful Parse instance methods
    
    func findAllPreviousRecipesWithCompletionHandler(completionHandler: ([Recipe]?) -> Void) {
        let query = self.pastRecipes.query()
        query.limit = 1000
        query.orderByAscending("name")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let recipes = objects as! [Recipe]
                if recipes.isEmpty {
                    completionHandler(nil)
                } else {
                    completionHandler(recipes)
                }
            } else {
                print("Error gettign previous recipes for current user.")
            }
        }
    }

}
