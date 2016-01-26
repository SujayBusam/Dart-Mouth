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
    func getNumItems(sender: ProgressDisplay) -> Int
    func valueForItem(sender : ProgressDisplay) -> Int
    func textForItem(sender: ProgressDisplay, index: Int) -> String
    func colorForArrow(sender : ProgressDisplay, index: Int) -> UIColor
    func progressUnit(sender : ProgressDisplay) -> String
}

class ProgressDisplay: UIStackView, ArrowLabelDataSource {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    weak var dataSource: ProgressDisplayDataSource?
    var displays : [UIView] = []
    
    // Calculated Dimensions
    var numItems : Int {
        if let items = dataSource?.getNumItems(self) {
            return items
        }
        return 0
    }
    var itemWidth: CGFloat {
        if numItems > 0 {
            return frame.width / CGFloat(numItems)
        }
        return CGFloat(0)
    }
    var itemHeight : CGFloat { return frame.height - 8.0}
    


    // Setup left arrow, right arrow, and date label.
    private func setup() {
        self.backgroundColor = UIColor.brownColor()
        self.axis = .Horizontal
        //self.alignment = .Fill

        
//        // Setup left button
//        leftButton = UIButton(frame: CGRectMake(0, 0, buttonSize, buttonSize))
//        leftButton.setImage(UIImage(named: "LeftArrowWhite"), forState: UIControlState.Normal)
//        leftButton.addTarget(self, action: "leftArrowWasPressed:", forControlEvents: .TouchUpInside)
//        
//        // Setup right button
//        rightButton = UIButton(frame: CGRectMake(0, 0, buttonSize, buttonSize))
//        rightButton.setImage(UIImage(named: "RightArrowWhite"), forState: UIControlState.Normal)
//        rightButton.addTarget(self, action: "rightArrowWasPressed:", forControlEvents: .TouchUpInside)
//        
//        // Setup date label
//        dateLabel = UILabel(frame: CGRectMake(0, 0, dateLabelWidth, dateLabelHeight))
//        dateLabel.textAlignment = NSTextAlignment.Center
//        dateLabel.textColor = UIColor.whiteColor()
//        dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
//        dateLabel.adjustsFontSizeToFitWidth = true
//        updateDateLabel()
//        
//        self.addSubview(leftButton)
//        self.addSubview(rightButton)
//        self.addSubview(dateLabel)
        
        setupConstraints()
        updateDisplays()
    }
    
    func updateDisplays(){
        self.subviews.forEach({ $0.removeFromSuperview() }) // clear items
        
        for i in 0..<numItems {
            //let display = ArrowLabel(frame: CGRectMake(0, 0, 40, 40))

            let display = ArrowLabel(frame: CGRectMake(0, 0, itemWidth, itemHeight))
            //let display = ArrowLabel()
            display.dataSource = self
            displays.append(display)
            self.addArrangedSubview(display)
            print("Added subview")
            //self.addSubview(display)
            
            

            //add constraints
            if(i == 0){
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


            } else {
                
            }
//            self.append(display)
        }
        //self.updateConstraintsIfNeeded()
//        self.arrangedSubviews
        setupConstraints()
        updateValues()
    }
    
    func updateValues(){
        
    }
    
    // Use PureLayout to set up constraints for positioning the subviews.
    private func setupConstraints() {
//        if displays.count == 0 {
//            return
//        }
        //displays[0].addConstraint(NSLayoutConstraint(item: displays[0], attribute: NSLayoutAttribute.RightMargin, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.RightMargin, multiplier: 1, constant: 0))
       // let zeroInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        leftButton.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Right)
//        leftButton.autoSetDimensionsToSize(CGSizeMake(buttonSize, buttonSize))
//        
//        rightButton.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Left)
//        rightButton.autoSetDimensionsToSize(CGSizeMake(buttonSize, buttonSize))
//        
//        dateLabel.autoCenterInSuperview()
//        dateLabel.autoSetDimensionsToSize(CGSizeMake(dateLabelWidth, dateLabelHeight))
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
