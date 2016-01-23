//
//  DiaryEntryNutritionAdderContainerViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/23/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

/*
    This is container view controller whose only child view controller is
    a RecipeNutritionViewController.

    This VC contains the recipe nutrition view and functionality for adding
    a recipe as a diary entry, with the mea

    See Apple documentation on container view controllers for more detail.
*/
class DiaryEntryNutritionAdderContainerViewController: UIViewController,
    RecipeNutritionViewControllerDelegate {

    // MARK: - Local Constants
    
    private struct Identifiers {
        static let Title = "Add Food"
        static let AddButtonText = "Add"
        static let CancelButtonText = "Cancel"
        static let addToDiaryButtonPressed = "addToDiaryButtonPressed:"
        static let cancelButtonPressed = "cancelButtonPressed:"
    }
    
    private struct InitialValues {
        static let ServingSize: Float = 1.0
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Instance Variables
    
    var mealTime: String! // Breakfast, Lunch, Dinner, Snacks
    var recipe: Recipe!
    var date: NSDate!
    
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupChildRecipeNutritionVC()
    }
    
    func setupViews() {
        // Set navigation title
        self.navigationItem.title = Identifiers.Title
        
        // Show toolbar
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        // Add button on right side of navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Identifiers.AddButtonText, style: .Done, target: self, action: NSSelectorFromString(Identifiers.addToDiaryButtonPressed))
        
        // Cancel button on left side of navigation bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Identifiers.CancelButtonText, style: .Done, target: self, action: NSSelectorFromString(Identifiers.cancelButtonPressed))
    }
    
    private func setupChildRecipeNutritionVC() {
        // Create and add RecipeViewController to this VC's container view.
        let recipeNutritionVC = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.RecipeNutrition)
            as! RecipeNutritionViewController
        recipeNutritionVC.delegate = self
        
        self.addChildViewController(recipeNutritionVC)
        recipeNutritionVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(recipeNutritionVC.view)
        recipeNutritionVC.didMoveToParentViewController(self)
    }


    // MARK: - Button actions
    
    func cancelButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addToDiaryButtonPressed(sender: UIBarButtonItem) {
        // Add the given recipe with its respective mealtime and serving size
        // by creating a diary entry
        self.navigationController?.popViewControllerAnimated(true)
        let selectedServingSize = getChildRecipeNutritionVC().servingSizeMultiplier
        
        DiaryEntry.createInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if success {
                print("DiaryEntry created")
            }
            }, withUserMealTitle: self.mealTime, withDate: self.date, withUser: CustomUser.currentUser()!, withRecipe: self.recipe, withServingsMultiplier: selectedServingSize)
        
    }
    
    // MARK: - RecipeNutritionViewControllerDelegate protocol methods
    
    func recipeForRecipeNutritionView(sender: RecipeNutritionViewController) -> Recipe {
        return self.recipe
    }
    
    func initialServingSizeMultiplierForRecipeNutritionView(sender: RecipeNutritionViewController) -> Float {
        return InitialValues.ServingSize
    }
    
    
    // MARK: - Helper Functions
    
    func getChildRecipeNutritionVC() -> RecipeNutritionViewController {
        // Assumes the RecipeNutritionViewController has been added as a child.
        return self.childViewControllers.last as! RecipeNutritionViewController
    }

}
