//
//  DiaryEntryTableViewCell.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/11/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

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
    
    
    // MARK: - Default override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            recipeNameLabel?.text = recipe.name
            servingsLabel?.text = "\(diaryEntry.servingsMultiplier) Servings"
            totalCaloriesLabel?.text = "\(diaryEntry.getTotalCalories()!)"
        }
    }

}
