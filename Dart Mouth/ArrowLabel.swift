//
//  ArrowView.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 1/23/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import PureLayout
import ChameleonFramework

/*
This is a custom UIView that shows an arrow that will point up or down 
and animate */


private struct DisplayOptions {
    static let ValueFontNormal = UIFont.systemFontOfSize(8.0)
    static let ValueFontCompact = UIFont.systemFontOfSize(10.0)
    
    static let ArrowSizeNormal : CGFloat = 25.0
    static let ArrowSizeCompact : CGFloat = 15.0
    
    static let ValueLabelHeightNormal : CGFloat = 15.0
    static let ValueLabelHeightCompact : CGFloat = 8.0
    
    static let DescriptionWidthRatio : CGFloat = 0.7
}

class ArrowLabel: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    // Subviews
    var descriptionLabel : UILabel!
    var valueLabel: UILabel!
    var arrow: ArrowDisplay!
    
    // Calculated dimensions

    
    //var valueLabelWidth: CGFloat { return CGFloat(frame.width)}

    
    // Setup arrow and value
    private func setupSubviews() {
        //self.gkgroundColor = UIColor.randomFlatColor()
        
        let descriptionLabelWidth = frame.width * DisplayOptions.DescriptionWidthRatio - 4.0
        let descriptionLabelHeight = DisplayOptions.ArrowSizeNormal
        
        print(descriptionLabelWidth)
        print(descriptionLabelHeight)
        descriptionLabel = UILabel(frame: CGRectMake(0, 0, descriptionLabelWidth, descriptionLabelHeight))
        
        // Setup arrow
        arrow = ArrowDisplay(frame: CGRectMake(descriptionLabelWidth + 4.0, 0, DisplayOptions.ArrowSizeNormal, DisplayOptions.ArrowSizeNormal))
        
        valueLabel = UILabel(frame: CGRectMake(descriptionLabelWidth + 4.0, DisplayOptions.ArrowSizeNormal, DisplayOptions.ArrowSizeNormal, DisplayOptions.ValueLabelHeightNormal))
        valueLabel.text = ""
        valueLabel.font = DisplayOptions.ValueFontNormal
        valueLabel.textAlignment = .Center

        descriptionLabel.text = ""
        descriptionLabel.font = UIFont.systemFontOfSize(12.0)
        descriptionLabel.textAlignment = .Right
        //descriptionLabel.adjustsFontSizeToFitWidth = true
        
        //valueLabel.adjustsFontSizeToFitWidth = true
        //arrow = ArrowDisplay(frame: CGRectMake(0, 0, 30, 30))
        
        // Setup Label
//        valueLabel = UILabel(frame: CGRectMake(0, 0, valueLabelWidth, valueLabelHeight))
//        valueLabel.textAlignment = NSTextAlignment.Center
//        valueLabel.textColor = UIColor.blackColor()
//        valueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
//        valueLabel.adjustsFontSizeToFitWidth = true
//            
        self.addSubview(arrow)
        self.addSubview(valueLabel)
        self.addSubview(descriptionLabel)

        
        setupConstraints()
    }
    
    private func drawArrow(){
        //draw circle
//        var path = UIBezierPath(ovalInRect: CGRectMake(0, 0, arrowSize, arrowSize))
//        dataSource?.colorForArrowView(self).setFill()
//        path.fill()
    }
    
    
    func updateDescription(description : String){
        descriptionLabel.text = description
    }
    func updateAttributedDescription(description : NSAttributedString){
        descriptionLabel.attributedText = description
    }
    
    func updateValue(value : Int, unit : String, valence : Bool){
        let direction : ArrowDisplay.Direction = (value >= 0) ? .Positive : .Negative
        valueLabel.text = String(value) + unit
        arrow.update(direction, valence: valence)
    }

    
    

    
    internal class ArrowDisplay : UIView {
        
        private struct DisplayOptions {
            static let ArrowThickness : CGFloat = 3.0
            static let ArrowLengthRatio : CGFloat = 0.7
            static let ArrowArmRatio : CGFloat = 0.3
            
            static let AnimationDuration : NSTimeInterval = 0.8
        }

        var direction : Direction = .Neutral
        var hasValence = true
        
        enum Direction : CGFloat {
            case Positive = -89.0, Neutral = 0, Negative = 89.0
        }
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUpLayer()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setUpLayer()
        }
        func update(newDirection : Direction, valence : Bool){
//            let degreeChange : CGFloat = CGFloat(direction.rawValue - newDirection.rawValue) * CGFloat(90.0)
//            let degreeChange : CGFloat = CGFloat(90.0)
//            print(degreeChange)
            
            UIView.animateWithDuration(DisplayOptions.AnimationDuration, animations: {
                self.hasValence = valence
                self.transform = CGAffineTransformMakeRotation((newDirection.rawValue * CGFloat(M_PI)) / 180.0)
            })
        }
        
        func setUpLayer(){
            layer.backgroundColor = UIColor.greenColor().CGColor
            layer.frame = self.frame
            
        }
        
        func updateLayer(){
            var fillColor = UIColor.whiteColor()
            var arrowColor = UIColor.blackColor()
            if(hasValence){
                switch direction {
                case .Positive:
                    fillColor = FlatRed()
                    arrowColor = UIColor.whiteColor()
                case .Negative:
                    fillColor = FlatGreen()
                    arrowColor = UIColor.whiteColor()
                default: break
                }
            }
            
            let fillPath = UIBezierPath(ovalInRect: layer.frame)
            fillColor.setFill()
            fillPath.fill()

        }

//        override func drawRect(rect: CGRect) {
//            self.backgroundColor = UIColor.clearColor()
//            var fillColor = UIColor.whiteColor()
//            var arrowColor = UIColor.blackColor()
//            if(hasValence){
//                switch direction {
//                case .Positive:
//                    fillColor = FlatRed()
//                    arrowColor = UIColor.whiteColor()
//                case .Negative:
//                    fillColor = FlatGreen()
//                    arrowColor = UIColor.whiteColor()
//                default: break
//                }
//            }
//            
//            let fillPath = UIBezierPath(ovalInRect: rect)
//            fillColor.setFill()
//            fillPath.fill()
//            
//            let arrowTail = CGPoint(x: rect.midX - CGFloat(rect.width * DisplayOptions.ArrowLengthRatio / 2.0), y: rect.midY)
//            let arrowHead = CGPoint(x: rect.midX + CGFloat(rect.width * DisplayOptions.ArrowLengthRatio / 2.0), y: rect.midY)
//            let arrowLeftArmEnd = CGPoint(x: rect.midX + CGFloat(rect.width * ((DisplayOptions.ArrowLengthRatio / 2.0) - DisplayOptions.ArrowArmRatio)), y: rect.midY + rect.height * DisplayOptions.ArrowArmRatio)
//            let arrowRightArmEnd = CGPoint(x: rect.midX + CGFloat(rect.width * ((DisplayOptions.ArrowLengthRatio / 2.0) - DisplayOptions.ArrowArmRatio)), y: rect.midY - rect.height * DisplayOptions.ArrowArmRatio)
////            let arrowTail = CGPoint(x: 0 , y: 0)
////            let arrowHead = CGPoint(x: 10, y: 10)
//
//            let arrowPath = UIBezierPath()
//            arrowPath.lineWidth = DisplayOptions.ArrowThickness
//            arrowPath.lineCapStyle = .Round
//            arrowPath.moveToPoint(arrowTail)
//            arrowPath.addLineToPoint(arrowHead)
//            arrowPath.moveToPoint(arrowLeftArmEnd)
//            arrowPath.addLineToPoint(arrowHead)
//            arrowPath.moveToPoint(arrowRightArmEnd)
//            arrowPath.addLineToPoint(arrowHead)
//            
//            arrowColor.setStroke()
//            arrowPath.stroke()
//        }
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
          //arrow.autoPinEdge(.Top, toEdge: .Top, ofView: self)
          //valueLabel.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
}
