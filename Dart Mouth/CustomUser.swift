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
    @NSManaged var goalCarb : Float
    @NSManaged var goalProtein : Float
    @NSManaged var goalFat : Float
    
    struct KeyNames {
        let Gender = "gender"
        let Age = "age"
        let Weight = "weight"
        let height = "height"
        let ActivityLevel = "activityLevel"
    }
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
    
    /*
    * For the given Recipe, create a Subscription object in Parse or
    * append to the existing Subscription object's recipes.
    */
    func createSubscriptionForRecipe(recipe: Recipe,
        withCompletionHandler completionHandler: PFBooleanResultBlock) {
        let subscriptionQuery = Subscription.query()!
        subscriptionQuery.whereKey("user", equalTo: self)
        
        subscriptionQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let subscriptions = objects as! [Subscription]
                
                if subscriptions.count > 1 {
                    print("Found more than one Subscription object for user: \(self.email). This should not happen!!")
                }
                
                if subscriptions.isEmpty {
                    // No Subscription object exists yet for this user.
                    let newSubscription = Subscription()
                    newSubscription.user = self;
                    newSubscription.recipes = [recipe.dartmouthId]
                    newSubscription.saveInBackgroundWithBlock(completionHandler)
                } else {
                    // Subscription object exists for this user. Append to recipes list
                    let existingSubscription = subscriptions[0]
                    existingSubscription.recipes.append(recipe.dartmouthId)
                    existingSubscription.saveInBackgroundWithBlock(completionHandler)
                }
            } else {
                print("Error getting subscriptions for CurrentUser")
            }
        }
    }

}
