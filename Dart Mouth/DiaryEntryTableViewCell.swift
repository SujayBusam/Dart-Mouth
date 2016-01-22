//
//  DiaryEntryTableViewCell.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/11/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import ChameleonFramework

class DiaryEntryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    // This is for ONE diary entry. The current cell.
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    
    
    // MARK: - Instance variables
    
    var diaryEntry: DiaryEntry? {
        didSet { updateUI() }
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
    
}
