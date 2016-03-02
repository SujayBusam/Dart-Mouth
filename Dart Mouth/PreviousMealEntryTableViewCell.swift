//
//  PreviousMealEntryTableViewCell.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 2/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import ChameleonFramework

class PreviousMealEntryTableViewCell: UITableViewCell, CheckboxUIButtonDelegate {

    // MARK: - Outlets
    // This is for ONE diary entry. The current cell.
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var checkBoxButton: CheckboxUIButton! {
        didSet {
            checkBoxButton.delegate = self
        }
    }
    
    
    // MARK: - Instance variables
    
    var diaryEntry: DiaryEntry? {
        didSet { updateUI() }
    }
    
    var isChecked: Bool {
        return self.checkBoxButton.isChecked
    }
    
    var numberFormatter: NSNumberFormatter = NSNumberFormatter()
    var fracUtil = FractionUtil()
    
    // MARK: - Default override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.numberFormatter.numberStyle = .DecimalStyle
        self.totalCaloriesLabel.textColor = FlatNavyBlue()
        self.servingsLabel.textColor = FlatGrayDark()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - UI Configuration
    
    func updateUI() {
        // TODO: may have to reset any existing diary entry information here.
        if let diaryEntry = self.diaryEntry {
            let recipe = diaryEntry.recipe
            let multiplier = diaryEntry.servingsMultiplier
            
            var servingsText = "Serving"
            if multiplier > 1.0 {
                servingsText = "Servings"
            }
            
            recipeNameLabel?.text = recipe.name
            servingsLabel?.text = "\(fracUtil.vulgarFraction(Double(multiplier)).0) " + servingsText
            totalCaloriesLabel?.text = self.numberFormatter.stringFromNumber(diaryEntry.getTotalCalories()!)
        }
    }
    
    func setChecked(checked: Bool) {
        self.checkBoxButton.isChecked = checked
    }
    
    func toggleCheckbox() {
        self.checkBoxButton.toggleCheck()
    }
    
    
    // MARK: - CheckboxUIButtonDelegate Protocol Methods
    
    func didSelectCheckbox(sender: CheckboxUIButton) {
        // Do nothing. Class with table view takes care of it
    }

}
