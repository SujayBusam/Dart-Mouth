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
This is a custom UIView that shows an arrow that will point up or down 
and animate */

protocol ArrowLabelDataSource: class {
    func colorForArrowLabel(sender: ArrowLabel) -> UIColor
    func valueForArrowLabel(sender: ArrowLabel) -> Int
    func unitForArrowLabel(sender: ArrowLabel) -> String
    //func descriptionText(sender: ArrowView) -> String
}

class ArrowLabel: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupSubviews()
    }
    
    // Subviews
    var valueLabel: UILabel!
    var arrow: ArrowDisplay!
    
    weak var dataSource: ArrowLabelDataSource?
    
    var arrowHeightRatio : CGFloat = 0.7
    
    // Calculated dimensions
    var arrowSize: CGFloat { return CGFloat(min(frame.height * arrowHeightRatio, frame.width)) }
    var valueLabelHeight: CGFloat { return CGFloat(frame.height * (1.0 - arrowHeightRatio)) }
    
    var valueLabelWidth: CGFloat { return CGFloat(frame.width)}
    
    // Setup arrow and value
    private func setupSubviews() {
        self.backgroundColor = UIColor.randomFlatColor()
        
        // Setup arrow
        arrow = ArrowDisplay(frame: CGRectMake(0, 0, arrowSize, arrowSize))
        //arrow = ArrowDisplay(frame: CGRectMake(0, 0, 30, 30))
        
        // Setup Label
        valueLabel = UILabel(frame: CGRectMake(0, 0, valueLabelWidth, valueLabelHeight))
        valueLabel.textAlignment = NSTextAlignment.Center
        valueLabel.textColor = UIColor.blackColor()
        valueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
        valueLabel.adjustsFontSizeToFitWidth = true
            
        self.addSubview(arrow)
        self.addSubview(valueLabel)
        
        setupConstraints()
    }
    
    private func drawArrow(){
        //draw circle
//        var path = UIBezierPath(ovalInRect: CGRectMake(0, 0, arrowSize, arrowSize))
//        dataSource?.colorForArrowView(self).setFill()
//        path.fill()
    }
    
    private func updateValueLabel(){
        if let value = dataSource?.valueForArrowLabel(self) {
            var suffix = ""
            if let unit = dataSource?.unitForArrowLabel(self){
                suffix = unit
            }
            valueLabel.text = String(value) + suffix
        } else {
            valueLabel.text = ""
        }
    }
    
    internal class ArrowDisplay : UIView {
        
        override func drawRect(rect: CGRect) {
            let path = UIBezierPath(ovalInRect: rect)
            UIColor.blueColor().setFill()
            path.fill()
        }
    }
    
    
    
    // Use PureLayout to set up constraints for positioning the subviews.
    private func setupConstraints() {
//        let zeroInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        leftButton.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Right)
//        leftButton.autoSetDimensionsToSize(CGSizeMake(buttonSize, buttonSize))
//        
//        rightButton.autoPinEdgesToSuperviewEdgesWithInsets(zeroInset, excludingEdge: .Left)
//        rightButton.autoSetDimensionsToSize(CGSizeMake(buttonSize, buttonSize))
//        
//        dateLabel.autoCenterInSuperview()
//        dateLabel.autoSetDimensionsToSize(CGSizeMake(dateLabelWidth, dateLabelHeight))
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
}
