//
//  DiaryAdderViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/15/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Parse

class DiaryAdderViewController: UIViewController {

    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBAction func mealtimeButtonClicked(sender: UIButton) {
        let mealTime = sender.currentTitle!
        
        let userMealQuery = UserMeal.query()!
        userMealQuery.whereKey("title", equalTo: mealTime)
        userMealQuery.whereKey("date", greaterThanOrEqualTo: self.date.startOfDay)
        userMealQuery.whereKey("date", lessThanOrEqualTo: self.date.endOfDay!)
        userMealQuery.whereKey("user", equalTo: CustomUser.currentUser()!)
        
        userMealQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                let newDiaryEntry = DiaryEntry()
                newDiaryEntry.date = self.date
                newDiaryEntry.user = CustomUser.currentUser()!
                newDiaryEntry.recipe = self.recipe
                newDiaryEntry.servingsMultiplier = self.servingsMultiplier
                
                newDiaryEntry.saveInBackgroundWithBlock({ (bool: Bool, error: NSError?) -> Void in
                    if error == nil {
                        let userMeals = objects as! [UserMeal]
                        if !userMeals.isEmpty {
                            let userMeal = userMeals.first!
                            userMeal.entries.append(newDiaryEntry)
                            userMeal.saveInBackgroundWithBlock(self.completionBlock)
                        } else {
                            print("User Meal not found. Creating it now.")
                            let newUserMeal = UserMeal()
                            newUserMeal.title = mealTime
                            newUserMeal.date = self.date
                            newUserMeal.user = CustomUser.currentUser()!
                            newUserMeal.entries = [newDiaryEntry]
                            newUserMeal.saveInBackgroundWithBlock(self.completionBlock)
                        }
                    } else {
                        print("Error saving DiaryEntry after trying to add to diary from RecipeNutritionVC.")
                    }
                })
                

                
            } else {
                print("Error getting UserMeal after trying to add to diary from RecipeNutritionVC.")
            }
        }
        
        
    }
    
    func completionBlock(bool: Bool, error: NSError?) -> Void {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if error == nil {
                self.dismissViewControllerAnimated(true) { () -> Void in
                    if let vc = self.sourceVC as? RecipeNutritionViewController {
                        vc.presentAddedToDiaryAlert()
                    }
                }
            } else {
                print("Error saving new UserMeal after trying to add to diary from RecipeNutritionVC.")
            }
        }
    }
    
    var sourceVC: UIViewController!
    var recipe: Recipe!
    var servingsMultiplier: Float!
    var date: NSDate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSubviews() {
//        self.view.backgroundColor = UIColor(hexString: "F7F7F7")
//        self.view.alpha = 0.6
    }
    
    override var preferredContentSize: CGSize {
        get {
            if buttonStackView != nil && presentingViewController != nil {
                return buttonStackView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        
        set { super.preferredContentSize = newValue }
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
