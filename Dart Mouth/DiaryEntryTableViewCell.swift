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
            let multiplier = diaryEntry.servingsMultiplier
            
            var servingsText = "Serving"
            if multiplier > 1.0 {
                servingsText = "Servings"
            }
            
            recipeNameLabel?.text = recipe.name
            servingsLabel?.text = "\(vulgarFraction(Double(multiplier)).0) " + servingsText
            totalCaloriesLabel?.text = "\(diaryEntry.getTotalCalories()!)"
        }
    }
    
    /**
     Returns a tuple with the closest compound fraction possible with Unicode's built-in "vulgar fractions".
     See here: http://www.unicode.org/charts/PDF/U2150.pdf
     :param: number The floating point number to convert.
     :returns: A tuple (String, Double): the string representation of the closest possible vulgar fraction and the value of that string
     */
    func vulgarFraction(number: Double) -> (String, Double) {
        let fractions: [(String, Double)] = [("", 1), ("\u{215E}", 7/8),
            ("\u{215A}", 5/6), ("\u{2158}", 4/5), ("\u{00BE}", 3/4), ("\u{2154}", 2/3),
            ("\u{215D}", 5/8), ("\u{2157}", 3/5), ("\u{00BD}", 1/2), ("\u{2156}", 2/5),
            ("\u{215C}", 3/8), ("\u{2153}", 1/3), ("\u{00BC}", 1/4), ("\u{2155}", 1/5),
            ("\u{2159}", 1/6), ("\u{2150}", 1/7), ("\u{215B}", 1/8), ("\u{2151}", 1/9),
            ("\u{2152}", 1/10), ("", 0)]
        let whole = Int(number)
        let sign = whole < 0 ? -1 : 1
        let fraction = number - Double(whole)
        
        for i in 1..<fractions.count {
            if abs(fraction) > (fractions[i].1 + fractions[i - 1].1) / 2 {
                if fractions[i - 1].1 == 1.0 {
                    return ("\(whole + sign)", Double(whole + sign))
                } else {
                    return ("\(fractions[i - 1].0)", Double(whole) + Double(sign) * fractions[i - 1].1)
                }
            }
        }
        return ("\(whole)", Double(whole))
    }

}
