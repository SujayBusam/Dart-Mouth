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
    
    struct Identifiers {
        static let StartSegue = "startAfterInitialization"
        static let SignupSegue = "showSignupFromInitialization"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = CustomUser.currentUser()
        if currentUser != nil {
            performSegueWithIdentifier(Identifiers.StartSegue, sender: self)
        } else {
            performSegueWithIdentifier(Identifiers.SignupSegue, sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Some test functions for playing around with Parse models.
    // Assumes current user is logged in!
    // THESE SHOULD NOT BE USED ANYMORE
    
    private func testEntryAndMealCreation() {
        Recipe.query()!.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let recipe = object as? Recipe {
                
                let diaryEntry = DiaryEntry()
                diaryEntry.date = NSDate()
                diaryEntry.user = CustomUser.currentUser()!
                diaryEntry.recipe = recipe
                diaryEntry.servingsMultiplier = 1.125
                
                let userMeal = UserMeal()
                userMeal.title = "TestSujay"
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
    
    // MARK: - Navigation
    

}
