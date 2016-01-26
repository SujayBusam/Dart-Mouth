//
//  DiaryEntryMealPickerViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/22/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

protocol DiaryEntryMealPickerViewControllerDelegate: class {
    func mealWasSelectedForDiaryEntryMealPicker(meal: String,
        sender: DiaryEntryMealPickerViewController) -> Void
}

/*
    The VC class that is displayed as a popover when selecting which meal
    to pick before adding a DiaryEntry to that meal.
*/
class DiaryEntryMealPickerViewController: UIViewController {
    
    private struct Offset {
        static let MarginOffset: CGFloat = 24
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Instance Variables
    
    weak var delegate: DiaryEntryMealPickerViewControllerDelegate!
    
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Return a size that just fits the content of this VC. Otherwise, it is too
    // large when presented as a popover.
    override var preferredContentSize: CGSize {
        get {
            if buttonStackView != nil && presentingViewController != nil {
                let presentingVCSize = presentingViewController!.view.bounds.size
                let stackSize =  self.buttonStackView.sizeThatFits(presentingVCSize)
                let labelSize = self.titleLabel.sizeThatFits(presentingVCSize)
                return CGSizeMake(stackSize.width, stackSize.height + labelSize.height + Offset.MarginOffset)
            } else {
                return super.preferredContentSize
            }
        }
        
        set { super.preferredContentSize = newValue }
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func mealButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate.mealWasSelectedForDiaryEntryMealPicker(sender.currentTitle!, sender: self)
    }

}
