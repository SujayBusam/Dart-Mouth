//
//  DateNavigationControl.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/9/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import PureLayout

/*
    This is a custom UIView that shows a date and left and right arrows.
    Pressing the left arrow decrements the date, pressing the right arrow increments it.
*/

protocol DateNavigationControlDataSource: class {
    func dateForDateNavigationControl(sender: DateNavigationControl) -> NSDate
}

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
    
    // Data source and delegate
    weak var dataSource: DateNavigationControlDataSource?
    
    // Calculated dimensions
    var buttonSize: CGFloat { return CGFloat(min(frame.height, frame.width)) }
    var dateLabelHeight: CGFloat { return CGFloat(frame.height) }
    var dateLabelWidth: CGFloat { return CGFloat(frame.width - 2 * buttonSize) }
    
    // Setup left arrow, right arrow, and date label.
    private func setupSubviews() {
        self.backgroundColor = UIColor.blackColor()
        
        // Setup left button
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        leftButton.setImage(UIImage(named: "LeftArrowWhite"), forState: UIControlState.Normal)
        leftButton.backgroundColor = UIColor.redColor()
        
        // Setup right button
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        rightButton.setImage(UIImage(named: "RightArrowWhite"), forState: UIControlState.Normal)
        rightButton.backgroundColor = UIColor.blueColor()
        
        // Setup date label
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dateLabelWidth, height: dateLabelHeight))
        dateLabel.textAlignment = NSTextAlignment.Center
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.backgroundColor = UIColor.greenColor()
        updateDateLabel()
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    // Use PureLayout to set up constraints for positioning the subviews.
    private func setupConstraints() {
        let zeroInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        leftButton.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Right)
        leftButton.autoSetDimensionsToSize(CGSize(width: buttonSize, height: buttonSize))
        
        rightButton.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Left)
        rightButton.autoSetDimensionsToSize(CGSize(width: buttonSize, height: buttonSize))

        dateLabel.autoCenterInSuperview()
        dateLabel.autoSetDimensionsToSize(CGSize(width: dateLabelWidth, height: dateLabelHeight))
    }
    
    func updateDateLabel() {
        if let date = dataSource?.dateForDateNavigationControl(self) {
            // Display date in the format of "Thu, Jan 10" for example.
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE, MMM d"
            dateLabel.text = formatter.stringFromDate(date)
        } else {
            dateLabel.text = "N/A"
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
