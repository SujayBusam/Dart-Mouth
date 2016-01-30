//
//  ArrowView.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 1/23/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import PureLayout

/*
This is a custom UIView that shows a date and left and right arrows.
Pressing the left arrow decrements the date, pressing the right arrow increments it.
*/

class ProgressDisplay: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private struct DisplayOptions {
        static let AnimateDuration = 0.6
        static let SideOffSetRatio : CGFloat = 0.3
        
        static let ArrowLabelWidthNormal : CGFloat = 80.0
        static let ArrowLabelHeightNormal : CGFloat = 40.0
        
    }
    
    var leftDisplay: ArrowLabel!
    var centerDisplay: ArrowLabel!
    var rightDisplay: ArrowLabel!
    
    
    
    // Calculated Dimensions
    var displayLeftX: CGFloat {
        return self.center.x - frame.width * DisplayOptions.SideOffSetRatio
    }
    
    var displayCenterX : CGFloat {
        return self.center.x 
    }
    
    var displayRightX : CGFloat {
        return self.center.x + frame.width * DisplayOptions.SideOffSetRatio
    }


    // Setup left arrow, right arrow, and date label.
    private func setup() {
        self.backgroundColor = UIColor.clearColor()
        self.needsUpdateConstraints()

        centerDisplay = ArrowLabel(frame: CGRectMake(0, 0, DisplayOptions.ArrowLabelWidthNormal, DisplayOptions.ArrowLabelHeightNormal))
        self.addSubview(centerDisplay)

        leftDisplay = ArrowLabel(frame: CGRectMake(0, 0, DisplayOptions.ArrowLabelWidthNormal, DisplayOptions.ArrowLabelHeightNormal))
        self.addSubview(leftDisplay)
        
        rightDisplay = ArrowLabel(frame: CGRectMake(0, 0, DisplayOptions.ArrowLabelWidthNormal, DisplayOptions.ArrowLabelHeightNormal))
        self.addSubview(rightDisplay)
        

        leftDisplay.center.x = displayCenterX
        centerDisplay.center.x = displayCenterX
        rightDisplay.center.x = displayCenterX

    }
    
    func updateCalorieDisplay(calories: Int){
        leftDisplay.updateValue(calories, unit: "", type: .Hidden)
        rightDisplay.updateValue(calories, unit: "", type: .Hidden)
        
        centerDisplay.updateValue(calories, unit: "", type: .Calorie)
        centerDisplay.updateDescription("Calories")
        animateSingleDisplay()
    }
    
    func updateMacroDisplay(carbs: Int, protein: Int, fat: Int){
//        let proteinDescription = String("Protein")
//        proteinDescription.color
        
        leftDisplay.updateValue(protein, unit: "g", type: .Protein)
        let proteinDescription = "Protein"
        let proteinAttributedDescription = NSMutableAttributedString(string: proteinDescription)
        proteinAttributedDescription.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "189090"), range: NSMakeRange(0, proteinDescription.characters.count))
        leftDisplay.updateAttributedDescription(proteinAttributedDescription)
        
        centerDisplay.updateValue(carbs, unit: "g", type: .Carb)
        let carbDescription = "Carbs"
        let carbAttributedDescription = NSMutableAttributedString(string: carbDescription)
        carbAttributedDescription.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "F0B428"), range: NSMakeRange(0, carbDescription.characters.count))
        centerDisplay.updateAttributedDescription(carbAttributedDescription)

        rightDisplay.updateValue(fat, unit: "g", type: .Fat)
        let fatDescription = "Fat"
        let fatAttributedDescription = NSMutableAttributedString(string: fatDescription)
        fatAttributedDescription.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "E42640"), range: NSMakeRange(0, fatDescription.characters.count))
        rightDisplay.updateAttributedDescription(fatAttributedDescription)

        animateFullDisplay()
    }
    

    
    func animateSingleDisplay(){
        UIView.animateWithDuration(DisplayOptions.AnimateDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.leftDisplay.center.x = self.displayCenterX
            self.rightDisplay.center.x = self.displayCenterX
        }, completion: nil)
            }
    
    func animateFullDisplay(){
        UIView.animateWithDuration(DisplayOptions.AnimateDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.leftDisplay.center.x = self.displayLeftX
            self.rightDisplay.center.x = self.displayRightX
            }, completion: nil)
    }
}
