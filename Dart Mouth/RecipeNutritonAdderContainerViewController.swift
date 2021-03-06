//
//  RecipeNutritonAdderContainerViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

/*
    This is container view controller whose only child view controller is
    a RecipeNutritionViewController.

    This VC contains the recipe nutrition view and functionality for adding
    a recipe as a diary entry.

    See Apple documentation on container view controllers for more detail.
*/
class RecipeNutritonAdderContainerViewController: UIViewController,
    UIPopoverPresentationControllerDelegate, DiaryEntryMealPickerViewControllerDelegate,
    RecipeNutritionViewControllerDelegate {
    
    // MARK: - Local Constants
    
    private struct Identifiers {
        static let Title = "Add Food"
        static let AddButtonText = "Add to Diary"
        static let addToDiaryButtonPressed = "addToDiaryButtonPressed:"
        static let cancelButtonPressed = "cancelBarButtonPressed"
    }
    
    private struct InitialValues {
        static let ServingSize: Float = 1.0
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Instance Variables
    
    var recipe: Recipe!
    var date: NSDate!
    var cancelBarButton: UIBarButtonItem!
    var addToDiaryBarButton: UIBarButtonItem!

    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupChildRecipeNutritionVC()
    }
    
    private func setupViews() {
        // Set navigation title
        self.navigationItem.title = Identifiers.Title
        
        // Show toolbar
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        // Create and set the "Add To Diary" toolbar button and add it to the toolbar.
        let addToDiaryButton = UIButton()
        addToDiaryButton.setTitleColor(self.view.tintColor, forState: .Normal)
        addToDiaryButton.setTitle(Identifiers.AddButtonText, forState: .Normal)
        addToDiaryButton.sizeToFit()
        addToDiaryButton.addTarget(self,
            action: NSSelectorFromString(Identifiers.addToDiaryButtonPressed),
            forControlEvents: .TouchUpInside)
        self.addToDiaryBarButton = UIBarButtonItem(customView: addToDiaryButton)
        self.setToolbarItems([self.addToDiaryBarButton], animated: true)
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
    
    // Not used currently
    func cancelBarButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addToDiaryButtonPressed(sender: UIBarButtonItem) {
        let popoverContentVC = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.DiaryEntryMealPicker) as! DiaryEntryMealPickerViewController
        
        // Configure the popover content VC (the diary adder)
        popoverContentVC.delegate = self
        popoverContentVC.modalPresentationStyle = .Popover
        
        // Configure popover presentation controller
        let presentationController = popoverContentVC.popoverPresentationController!
        presentationController.barButtonItem = self.addToDiaryBarButton
        presentationController.delegate = self
        
        self.presentViewController(popoverContentVC, animated: true, completion: nil)
    }
    
    
    // MARK: - RecipeNutritionViewControllerDelegate protocol methods
    
    func recipeForRecipeNutritionView(sender: RecipeNutritionViewController) -> Recipe {
        return self.recipe
    }
    
    func initialServingSizeMultiplierForRecipeNutritionView(sender: RecipeNutritionViewController) -> Float {
        return InitialValues.ServingSize
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate protocol methods
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    // MARK: - DiaryEntryMealPickerViewControllerDelegate protocol methods
    
    func mealWasSelectedForDiaryEntryMealPicker(meal: String, sender: DiaryEntryMealPickerViewController) {
        self.navigationController?.popViewControllerAnimated(true)
        DiaryEntry.createInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if success {
                print("DiaryEntry created")
            }
            }, withUserMealTitle: meal, withDate: self.date, withUser: CustomUser.currentUser()!, withRecipe: self.recipe, withServingsMultiplier: self.getChildRecipeNutritionVC().servingSizeMultiplier)
    }

    
    // MARK: - Helper Functions
    
    func getChildRecipeNutritionVC() -> RecipeNutritionViewController {
        // Assumes the RecipeNutritionViewController has been added as a child.
        return self.childViewControllers.last as! RecipeNutritionViewController
    }
}
