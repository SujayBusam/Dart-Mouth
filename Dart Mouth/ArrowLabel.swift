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
    static let ValueFontNormal = UIFont.systemFontOfSize(11.0)
    static let ValueFontCompact = UIFont.systemFontOfSize(8.0)
    
    static let DescriptionFontNormal = UIFont.systemFontOfSize(13.0)
    static let DescriptionFontCompact = UIFont.systemFontOfSize(10.0)

    
    static let ArrowSizeNormal : CGFloat = 30.0
    static let ArrowSizeCompact : CGFloat = 20.0
    
    static let ValueLabelHeightNormal : CGFloat = 20.0
    static let ValueLabelHeightCompact : CGFloat = 15.0
    
    static let DescriptionPadding : CGFloat = 4.0
    static let DescriptionWidthRatio : CGFloat = 0.7
    
    static let AnimationDuration : NSTimeInterval = 0.6
    static let FadeDuration : NSTimeInterval = 0.3
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
    
    private func setupSubviews() {
        let descriptionLabelWidth = frame.width * DisplayOptions.DescriptionWidthRatio - DisplayOptions.DescriptionPadding
        let descriptionLabelHeight = DisplayOptions.ArrowSizeNormal
        
        descriptionLabel = UILabel(frame: CGRectMake(0, 0, descriptionLabelWidth, descriptionLabelHeight))
        
        arrow = ArrowDisplay(frame: CGRectMake(descriptionLabelWidth + DisplayOptions.DescriptionPadding, 0, DisplayOptions.ArrowSizeNormal, DisplayOptions.ArrowSizeNormal))
        
        valueLabel = UILabel(frame: CGRectMake(descriptionLabelWidth + DisplayOptions.DescriptionPadding, DisplayOptions.ArrowSizeNormal, DisplayOptions.ArrowSizeNormal, DisplayOptions.ValueLabelHeightNormal))
        valueLabel.text = ""
        //valueLabel.font = DisplayOptions.ValueFontNormal
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.textAlignment = .Center

        descriptionLabel.text = ""
        descriptionLabel.font = DisplayOptions.DescriptionFontNormal
        descriptionLabel.textAlignment = .Right
        self.addSubview(arrow)
        self.addSubview(valueLabel)
        self.addSubview(descriptionLabel)

    }
    
    func updateDescription(description : String){
        descriptionLabel.text = description
    }
    func updateAttributedDescription(description : NSAttributedString){
        descriptionLabel.attributedText = description
    }
    
    func updateValue(value : Int, unit : String, type : ArrowDisplay.DisplayType){
        let direction : ArrowDisplay.Direction = (value >= 0) ? .Positive : .Negative
        valueLabel.text = String(abs(value)) + unit
        
        if(type == .Hidden){
            //hide labels early
            UIView.animateWithDuration(DisplayOptions.FadeDuration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.descriptionLabel.alpha = 0.0
                self.valueLabel.alpha = 0.0
                }, completion: nil)
        } else {
            //labels appear later into animation
            UIView.animateWithDuration(DisplayOptions.FadeDuration, delay: DisplayOptions.AnimationDuration, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.descriptionLabel.alpha = 1.0
                self.valueLabel.alpha = 1.0
                }, completion: nil)
        }
        
        arrow.update(type, newDirection: direction)
    }
    
    internal class ArrowDisplay : UIView {
        
        private struct DisplayOptions {
            static let ArrowThickness : CGFloat = 3.0
            static let ArrowLengthRatio : CGFloat = 0.7
            static let ArrowArmRatio : CGFloat = 0.3
            
            static let AnimationDuration : NSTimeInterval = 0.6
            
            static let ProteinColor = UIColor(hexString: "189090")
            static let CarbColor = UIColor(hexString: "F0B428")
            static let FatColor = UIColor(hexString: "E42640")
        }

        let arrowLayer = CAShapeLayer()
        
        let circleLayer = CAShapeLayer()
        
        var type = DisplayType.Hidden
        var direction : Direction = .Positive
        var hasValence = false
        
        enum Direction : CGFloat {
            case Positive = -89.0, Negative = 89.0
        }
        
        enum DisplayType {
            case Calorie, Carb, Protein, Fat, Hidden
        }
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUpLayers()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setUpLayers()
        }
        func update(newType : DisplayType, newDirection : Direction){
            UIView.animateWithDuration(DisplayOptions.AnimationDuration, animations: {
                self.transform = CGAffineTransformMakeRotation((newDirection.rawValue * CGFloat(M_PI)) / 180.0)
            })
            
            circleLayer.fillColor = getCircleColor(newType, direction: newDirection).CGColor
            let circleColorAnimation = CABasicAnimation(keyPath: "fillColor")
            circleColorAnimation.duration = 0.8
            circleColorAnimation.fromValue = getCircleColor(type, direction: direction).CGColor
            direction = newDirection
            circleColorAnimation.toValue = getCircleColor(newType, direction: newDirection).CGColor
            circleColorAnimation.autoreverses = false
            circleLayer.addAnimation(circleColorAnimation, forKey: "fillColor")
            
            getArrowColor(newType).CGColor
            arrowLayer.strokeColor = getArrowColor(newType).CGColor
            let arrowColorAnimation = CABasicAnimation(keyPath: "strokeColor")
            arrowColorAnimation.duration = 0.8
            arrowColorAnimation.fromValue = getArrowColor(type).CGColor
            arrowColorAnimation.toValue = getArrowColor(newType).CGColor
            arrowColorAnimation.autoreverses = false
            arrowLayer.addAnimation(arrowColorAnimation, forKey: "strokeColor")
            
            direction = newDirection
            type = newType
        }
        
        func setUpLayers(){
            layer.backgroundColor = UIColor.clearColor().CGColor
            layer.frame = self.frame
            
            let circlePath = UIBezierPath(ovalInRect: self.bounds)
            circleLayer.fillColor = UIColor.clearColor().CGColor
            circleLayer.path = circlePath.CGPath
            circleLayer.frame = self.bounds
            
            let arrowTail = CGPoint(x: bounds.midX - CGFloat(bounds.width * DisplayOptions.ArrowLengthRatio / 2.0), y: bounds.midY)
            let arrowHead = CGPoint(x: bounds.midX + CGFloat(bounds.width * DisplayOptions.ArrowLengthRatio / 2.0), y: bounds.midY)
            let arrowLeftArmEnd = CGPoint(x: bounds.midX + CGFloat(bounds.width * ((DisplayOptions.ArrowLengthRatio / 2.0) - DisplayOptions.ArrowArmRatio)), y: bounds.midY + bounds.height * DisplayOptions.ArrowArmRatio)
            let arrowRightArmEnd = CGPoint(x: bounds.midX + CGFloat(bounds.width * ((DisplayOptions.ArrowLengthRatio / 2.0) - DisplayOptions.ArrowArmRatio)), y: bounds.midY - bounds.height * DisplayOptions.ArrowArmRatio)
            
            let arrowPath = UIBezierPath()
            arrowPath.lineWidth = DisplayOptions.ArrowThickness
            arrowPath.lineCapStyle = .Round
            arrowPath.moveToPoint(arrowTail)
            arrowPath.addLineToPoint(arrowHead)
            arrowPath.moveToPoint(arrowLeftArmEnd)
            arrowPath.addLineToPoint(arrowHead)
            arrowPath.moveToPoint(arrowRightArmEnd)
            arrowPath.addLineToPoint(arrowHead)
            
            arrowLayer.path = arrowPath.CGPath
            arrowLayer.lineCap = kCALineCapRound
            arrowLayer.lineWidth = DisplayOptions.ArrowThickness
            arrowLayer.strokeColor = getArrowColor(type).CGColor
            arrowLayer.frame = self.bounds
            
            layer.addSublayer(circleLayer)
            layer.addSublayer(arrowLayer)
        }
        
        
        private func getCircleColor(type : DisplayType, direction : Direction) -> UIColor{
            if(type == .Calorie){
                switch direction {
                case .Positive: return FlatRed()
                case .Negative: return FlatGreen()
                }
            }
            return UIColor.clearColor()
        }
        
        private func getArrowColor(type : DisplayType) -> UIColor{
            switch type {
            case .Calorie: return UIColor.clearColor()
            case .Carb : return DisplayOptions.CarbColor
            case .Protein : return DisplayOptions.ProteinColor
            case .Fat : return DisplayOptions.FatColor
            case .Hidden : return UIColor.whiteColor()
            }
        }
    }
}
