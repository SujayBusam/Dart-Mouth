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

protocol ProgressDisplayDataSource: class {
    func getWeeklyCalories(sender: ProgressDisplay) -> Int
    func getWeeklyCarbs(sender: ProgressDisplay) -> Int
    func getWeeklyProtein(sender : ProgressDisplay) -> Int
    func getWeeklyFat(sender: ProgressDisplay) -> Int
    //func colorForArrow(sender : ProgressDisplay, index: Int) -> UIColor
    //func progressUnit(sender : ProgressDisplay) -> String
}

class ProgressDisplay: UIView, ArrowLabelDataSource {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private struct DisplayOptions {
        static let AnimateDuration = 0.3
        
        static let SideOffSetRatio : CGFloat = 0.3
    }

    weak var dataSource: ProgressDisplayDataSource?
    
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
        self.backgroundColor = UIColor.brownColor()
        self.needsUpdateConstraints()

        leftDisplay = ArrowLabel()
        self.addSubview(leftDisplay)
        
        rightDisplay = ArrowLabel()
        self.addSubview(rightDisplay)
        
        centerDisplay = ArrowLabel()
        self.addSubview(centerDisplay)

        leftDisplay.center.x = displayCenterX
        centerDisplay.center.x = displayCenterX
        rightDisplay.center.x = displayCenterX

    }
    
    func updateCalorieDisplay(calories: Int){
        animateSingleDisplay()
    }
    
    func updateMacroDisplay(carbs: Int, protein: Int, fat: Int){
        animateFullDisplay()
    }
    

    
    func animateSingleDisplay(){
        UIView.animateWithDuration(DisplayOptions.AnimateDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.leftDisplay.center.x = self.displayCenterX
            self.leftDisplay.alpha = 0
            self.rightDisplay.center.x = self.displayCenterX
            self.rightDisplay.alpha = 0
        }, completion: nil)
        
//        UIView.animateWithDuration(DisplayOptions.AnimateDuration, delay: 0,
//            options: UIViewAnimationOptions.CurveEaseOut, animations: )
    }
    
    func animateFullDisplay(){
        UIView.animateWithDuration(DisplayOptions.AnimateDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.leftDisplay.center.x = self.displayLeftX
            self.rightDisplay.center.x = self.displayRightX
            self.leftDisplay.alpha = 1.0
            self.rightDisplay.alpha = 1.0
            }, completion: nil)
    }
    

    func updateDisplays(){
        
        
            //let display = ArrowLabel(frame: CGRectMake(0, 0, 30, 30))
//            let display = UILabel()
//            display.text = "Text"
            //let display = ArrowLabel(frame: CGRectMake(0, 0, itemWidth, itemHeight))
//            let display = ArrowLabel()
//            display.dataSource = self
            //displays.append(display)
            //self.addSubview(display)
            
            

            //add constraints
            //if(i == 0){
//                display.addConstraint(NSLayoutConstraint(item: display, attribute: NSLayoutAttribute.RightMargin, relatedBy: NSLayoutRelation.Equal, toItem: display.superview, attribute: NSLayoutAttribute.RightMargin, multiplier: 1, constant: 0))
                //let zeroInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                //display.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Left)
                //display.autoSetDimensionsToSize(CGSizeMake(20, 20))
                //display.autoSetDimensionsToSize(CGSizeMake(itemWidth/2.0, itemHeight/2.0))
                //display.translatesAutoresizingMaskIntoConstraints = false
//                let height = NSLayoutConstraint(item: display, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20)
//                let width = NSLayoutConstraint(item: display, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20)
//                let horizontalPin = NSLayoutConstraint(item: display, attribute: .Trailing, relatedBy: .Equal, toItem: display.superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
//                let verticalCenter = NSLayoutConstraint(item: display, attribute: .CenterY, relatedBy: .Equal, toItem: display.superview, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
//                display.addConstraints([horizontalPin, verticalCenter])
//                display.auto
//                display.updateConstraintsIfNeeded()
                //let horizontalConstraint = display.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
                //NSLayoutConstraint.activateConstraints([horizontalConstraint])


//            } else {
//                
//            }
//            self.append(display)
//        }
        //self.updateConstraintsIfNeeded()
//        self.arrangedSubviews
    }
    

    
    
    // MARK: - ArrowLabelDataSource protocol methods

    
    func colorForArrowLabel(sender: ArrowLabel) -> UIColor {
        return UIColor.blueColor()
    }
    
    func valueForArrowLabel(sender: ArrowLabel) -> Int {
        return 200
    }
    
    func unitForArrowLabel(sender: ArrowLabel) -> String {
        return ""
    }
    
}
