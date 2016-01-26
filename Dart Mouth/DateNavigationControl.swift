//
//  DateNavigationControl.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/9/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import PureLayout

protocol DateNavigationControlDelegate: class {
    func dateForDateNavigationControl(sender: DateNavigationControl) -> NSDate
    func leftArrowWasPressed(sender: UIButton) -> Void
    func rightArrowWasPressed(sender: UIButton) -> Void
}

/*
    This is a custom UIView that shows a date and left and right arrows.
    Pressing the left arrow decrements the date, pressing the right arrow increments it.
*/

class DateNavigationControl: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    // Subviews
    var leftButton: UIButton!
    var rightButton: UIButton!
    var dateLabel: UILabel!
    
    weak var delegate: DateNavigationControlDelegate?
    
    // Calculated dimensions
    var buttonSize: CGFloat { return CGFloat(min(frame.height, frame.width)) }
    var dateLabelHeight: CGFloat { return CGFloat(frame.height) }
    var dateLabelWidth: CGFloat { return CGFloat(frame.width - 2 * buttonSize) }
    
    // Setup left arrow, right arrow, and date label.
    private func setupSubviews() {
        self.backgroundColor = UIColor.clearColor()
        
        // Setup left button
        leftButton = UIButton(frame: CGRectMake(0, 0, buttonSize, buttonSize))
        leftButton.setImage(UIImage(named: Constants.Images.LeftArrowWhite), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: "leftArrowWasPressed:", forControlEvents: .TouchUpInside)
        
        // Setup right button
        rightButton = UIButton(frame: CGRectMake(0, 0, buttonSize, buttonSize))
        rightButton.setImage(UIImage(named: Constants.Images.RightArrowWhite), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: "rightArrowWasPressed:", forControlEvents: .TouchUpInside)
        
        // Setup date label
        dateLabel = UILabel(frame: CGRectMake(0, 0, dateLabelWidth, dateLabelHeight))
        dateLabel.textAlignment = NSTextAlignment.Center
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
        dateLabel.adjustsFontSizeToFitWidth = true
        updateDateLabel()
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    // Use PureLayout to set up constraints for positioning the subviews.
    private func setupConstraints() {
        leftButton.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Right)
        leftButton.autoSetDimensionsToSize(CGSizeMake(buttonSize, buttonSize))
        
        rightButton.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Left)
        rightButton.autoSetDimensionsToSize(CGSizeMake(buttonSize, buttonSize))

        dateLabel.autoCenterInSuperview()
        dateLabel.autoSetDimensionsToSize(CGSizeMake(dateLabelWidth, dateLabelHeight))
    }
    
    func updateDateLabel() {
        if let date = delegate?.dateForDateNavigationControl(self) {
            // Display date in the format of "Thu, Jan 10" for example.
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE, MMM d"
            dateLabel.text = formatter.stringFromDate(date)
        } else {
            dateLabel.text = "N/A"
        }
    }
    
    func leftArrowWasPressed(sender: UIButton) { delegate?.leftArrowWasPressed(sender) }
    func rightArrowWasPressed(sender: UIButton) { delegate?.rightArrowWasPressed(sender) }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
