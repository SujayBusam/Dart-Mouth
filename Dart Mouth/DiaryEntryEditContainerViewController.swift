//
//  DiaryEntryEditContainerViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import ChameleonFramework

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
        static let trashButtonPressed = "trashButtonPressed:"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Instance Variables

    var userMeal: UserMeal!
    var diaryEntry: DiaryEntry!
    var cancelBarButton: UIBarButtonItem!
    var saveBarButton: UIBarButtonItem!
    var trashBarButton: UIBarButtonItem!
    
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
        saveButton.setTitleColor(FlatGrayDark(), forState: .Highlighted)
        saveButton.sizeToFit()
        saveButton.addTarget(self,
            action: NSSelectorFromString(Identifiers.saveButtonPressed),
            forControlEvents: .TouchUpInside)
        self.saveBarButton = UIBarButtonItem(customView: saveButton)
        self.navigationItem.rightBarButtonItem = self.saveBarButton
        
        let cancelButton = UIButton()
        cancelButton.setTitle(Identifiers.CancelButtonTitle, forState: .Normal)
        cancelButton.setTitleColor(FlatGrayDark(), forState: .Highlighted)
        cancelButton.sizeToFit()
        cancelButton.addTarget(self,
            action: NSSelectorFromString(Identifiers.cancelButtonPressed),
            forControlEvents: .TouchUpInside)
        self.cancelBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = self.cancelBarButton
        
        // Add trash button
        let trashButton = UIButton()
        trashButton.setImage(UIImage(named: Constants.Images.TrashGreen), forState: .Normal)
        trashButton.sizeToFit()
        trashButton.addTarget(self, action: NSSelectorFromString(Identifiers.trashButtonPressed), forControlEvents: .TouchUpInside)
        self.trashBarButton = UIBarButtonItem(customView: trashButton)
        self.toolbarItems = [self.trashBarButton]
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
    
    func cancelButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveButtonPressed(sender: UIButton) {
        // Update the DiaryEntry with the new chosen serving size and navigate back
        let newServingSize = getChildRecipeNutritionVC().servingSizeMultiplier
        self.diaryEntry.servingsMultiplier = newServingSize
        diaryEntry.saveInBackgroundWithBlock { (bool: Bool, error: NSError?) -> Void in
            if error == nil {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func trashButtonPressed(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Remove Food", style: .Destructive) {
            (deleteAction: UIAlertAction) -> Void in
            
            self.diaryEntry.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if success {
                    print("Deleted DiaryEntry")
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    print("Error deleting DiaryEntry")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - RecipeNutritionViewControllerDelegate protocol methods
    
    func recipeForRecipeNutritionView(sender: RecipeNutritionViewController) -> Recipe {
        return self.diaryEntry.recipe
    }
    
    func initialServingSizeMultiplierForRecipeNutritionView(sender: RecipeNutritionViewController) -> Float {
        return self.diaryEntry.servingsMultiplier
    }
    
  
    // MARK: - Helper Functions
    
    func getChildRecipeNutritionVC() -> RecipeNutritionViewController {
        // Assumes the RecipeNutritionViewController has been added as a child.
        return self.childViewControllers.last as! RecipeNutritionViewController
    }
    
}
