//
//  DiaryAdderViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/15/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Parse

protocol DiaryAdderViewControllerDelegate: class {
    func presentAddedToDiaryAlertForDiaryAdder(sender: DiaryAdderViewController) -> Void
}

class DiaryAdderViewController: UIViewController {

    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBAction func mealtimeButtonClicked(sender: UIButton) {
        DiaryEntry.createInBackgroundWithBlock(
            self.completionBlock,
            withUserMealTitle: sender.currentTitle!,
            withDate: self.date,
            withUser: CustomUser.currentUser()!,
            withRecipe: self.recipe,
            withServingsMultiplier: self.servingsMultiplier
        )
    }
    
    func completionBlock(bool: Bool, error: NSError?) -> Void {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if error == nil {
                self.dismissViewControllerAnimated(true) { () -> Void in
                    self.delegate.presentAddedToDiaryAlertForDiaryAdder(self)
                }
            } else {
                print("Error saving new UserMeal after trying to add to diary from RecipeNutritionVC.")
            }
        }
    }
    
    weak var delegate: DiaryAdderViewControllerDelegate!
    var recipe: Recipe!
    var servingsMultiplier: Float!
    var date: NSDate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSubviews() {
        // TODO: any setup here such as alpha value
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

}
