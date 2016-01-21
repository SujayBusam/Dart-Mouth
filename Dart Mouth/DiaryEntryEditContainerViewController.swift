//
//  DiaryEntryEditContainerViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

/*
    This is container view controller whose only child view controller is
    a RecipeNutritionViewController.

    This VC contains the recipe nutrition view and functionality for editing
    or deleting an existing DiaryEntry.

    See Apple documentation on container view controllers for more detail.
*/
class DiaryEntryEditContainerViewController: UIViewController,
    RecipeNutritionViewControllerDelegate {

    // MARK: - Local Constants
    
    private struct Identifiers {
        static let Title = "Edit Food"
        static let SaveButtonTitle = "Save"
        static let saveButtonPressed = "saveButtonPressed:"
        static let CancelButtonTitle = "Cancel"
        static let cancelButtonPressed = "cancelButtonPressed:"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Instance Variables

    var diaryEntry: DiaryEntry!
    var cancelBarButton: UIBarButtonItem!
    var saveBarButton: UIBarButtonItem!
    
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupChildRecipeNutritionVC()
    }
    
    private func setupViews() {
        // Setup navigation title
        self.navigationItem.title = Identifiers.Title
        
        // Show toolbar
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        // Create and set the "Save" and "Cancel" bar buttons and add 
        // them to the navigation bar
        let saveButton = UIButton()
        saveButton.setTitle(Identifiers.SaveButtonTitle, forState: .Normal)
        saveButton.setTitleColor(UIColor.blueColor(), forState: .Highlighted)
        saveButton.sizeToFit()
        saveButton.addTarget(self,
            action: NSSelectorFromString(Identifiers.saveButtonPressed),
            forControlEvents: .TouchUpInside)
        self.saveBarButton = UIBarButtonItem(customView: saveButton)
        self.navigationItem.rightBarButtonItem = self.saveBarButton
        
        let cancelButton = UIButton()
        cancelButton.setTitle(Identifiers.CancelButtonTitle, forState: .Normal)
        cancelButton.setTitleColor(UIColor.blueColor(), forState: .Highlighted)
        cancelButton.sizeToFit()
        cancelButton.addTarget(self,
            action: NSSelectorFromString(Identifiers.cancelButtonPressed),
            forControlEvents: .TouchUpInside)
        self.cancelBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = self.cancelBarButton
    }
    
    private func setupChildRecipeNutritionVC() {
        // Create and add RecipeViewController to this VC's container view
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
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        // TODO: implement
    }
    
    
    // MARK: - RecipeNutritionViewControllerDelegate protocol methods
    
    func recipeForRecipeNutritionView(sender: RecipeNutritionViewController) -> Recipe {
        return self.diaryEntry.recipe
    }
    
    func initialServingSizeMultiplierForRecipeNutritionView(sender: RecipeNutritionViewController) -> Float {
        return self.diaryEntry.servingsMultiplier
    }
    
  
    // MARK: - Helper Functions
    
}
