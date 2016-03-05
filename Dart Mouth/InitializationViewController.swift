//
//  InitializationViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/11/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Parse

class InitializationViewController: UIViewController {
    
    let DEBUG = false
    
    struct Identifiers {
        static let StartSegue = "startAfterInitialization"
        static let SignupSegue = "showSignupFromInitialization"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DEBUG {
            // Test out code here
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if !DEBUG {
            let currentUser = CustomUser.currentUser()
            if currentUser != nil {
                scheduleNotifications()
                performSegueWithIdentifier(Identifiers.StartSegue, sender: self)
            } else {
                performSegueWithIdentifier(Identifiers.SignupSegue, sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Notifications
    
    private func scheduleNotifications() {
        print("Scheduling Notifications")
    }
    
    
    // MARK: - Some test functions for playing around with Parse models.
    // Assumes current user is logged in!
    
    private func testUserMealQuery() {
        let date = NSDate(dateString: "2016-01-12")
        
        let query = UserMeal.query()!
        query.whereKey("date", greaterThanOrEqualTo: date.startOfDay)
        query.whereKey("date", lessThanOrEqualTo: date.endOfDay!)
        
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            let userMeal = object as! UserMeal
            print(userMeal.title)
        }
    }
    
    // THIS SHOULD BE USED WITH EXTREME CAUTION. CREATES DATA IN PARSE
    private func testEntryAndMealCreation() {
        Recipe.query()!.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let recipe = object as? Recipe {
                
                let diaryEntry = DiaryEntry()
                diaryEntry.date = NSDate()
                diaryEntry.user = CustomUser.currentUser()!
                diaryEntry.recipe = recipe
                diaryEntry.servingsMultiplier = 1.125
                
                let userMeal = UserMeal()
                userMeal.title = "Breakfast Test"
                userMeal.date = NSDate()
                userMeal.user = CustomUser.currentUser()!
                userMeal.entries = [diaryEntry]
                
                diaryEntry.saveInBackgroundWithBlock { (bool: Bool, error: NSError?) -> Void in
                    userMeal.saveInBackgroundWithBlock({ (bool: Bool, error: NSError?) -> Void in
                        print("Saved")
                    })
                }
            }
        }
    }
    
    // THIS SHOULD BE USED WITH EXTREME CAUTION. CREATES DATA IN PARSE
    private func testUserRelationCreation() {
        let currentUser = CustomUser.currentUser()!
        let recipeQuery = Recipe.query()!
        recipeQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let recipe = object as? Recipe {
                currentUser.pastRecipes.addObject(recipe)
                currentUser.saveInBackground()
                print("Past Recipe saved.")
            }
        }
    }
    

}
