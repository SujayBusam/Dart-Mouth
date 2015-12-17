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
    var buttonHeight: CGFloat { return CGFloat(self.bounds.height) }
    var buttonWidth: CGFloat { return CGFloat(self.bounds.height) }
    var dateLabelHeight: CGFloat { return CGFloat(self.bounds.height) }
    var dateLabelWidth: CGFloat { return CGFloat(self.bounds.width - 2 * buttonWidth) }
    
    // Setup left arrow, right arrow, and date label.
    private func setupSubviews() {
        self.backgroundColor = UIColor.clearColor()
        
        // Setup left button
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        leftButton.setImage(UIImage(named: "LeftArrowWhite"), forState: UIControlState.Normal)
        
        // Setup right button
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        rightButton.setImage(UIImage(named: "RightArrowWhite"), forState: UIControlState.Normal)
        
        // Setup date label
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dateLabelWidth, height: dateLabelHeight))
        dateLabel.textAlignment = NSTextAlignment.Center
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        dateLabel.adjustsFontSizeToFitWidth = true
        updateDate()
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(dateLabel)
        
        leftButton.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .Right)
        rightButton.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .Left)
        dateLabel.autoCenterInSuperview()
    }
    
    func updateDate() {
        if let date = dataSource?.dateForDateNavigationControl(self) {
            // Display date in the format of "Thu, Jan. 10" for example.
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE, MMM. d"
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
