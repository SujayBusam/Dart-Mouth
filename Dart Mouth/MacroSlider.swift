//
//  MacroSlider.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 2/19/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import ChameleonFramework


protocol MacroSliderDelegate: class {
    func valueChanged() -> Void
}

extension Float {
    /// Rounds the float to decimal places value
    func roundToPlaces(places : Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return round(self * divisor) / divisor
    }
}


class MacroSlider : UIControl {
    
    enum MacroSelection{
        case None, Protein, Carbs, Fat
    }
    
    var delegate : MacroSliderDelegate?

    var protein : Float {
        return Float(proteinPosition - fatPosition + 1.0).roundToPlaces(2)
    }
    var carbs : Float{
        return Float(carbsPosition - proteinPosition).roundToPlaces(2)
    }
    var fat : Float{
        return Float(fatPosition - carbsPosition).roundToPlaces(2)
    }
    
    var proteinGrams : Int {
        return Int(protein / Constants.NutritionalConstants.ProteinCaloriesToGram * Float(goalCalories))
    }
    var carbsGrams : Int{
        return Int(carbs / Constants.NutritionalConstants.CarbsCaloriesToGram * Float(goalCalories))
    }
    var fatGrams : Int{
        return Int(fat / Constants.NutritionalConstants.FatCaloriesToGram * Float(goalCalories))
    }
    
    var proteinPosition = Constants.NutritionalConstants.DefaultProteinPercent
    
    var carbsPosition = Constants.NutritionalConstants.DefaultCarbsPercent +
                        Constants.NutritionalConstants.DefaultProteinPercent
    
    var fatPosition = Constants.NutritionalConstants.DefaultFatPercent +
                      Constants.NutritionalConstants.DefaultCarbsPercent +
                      Constants.NutritionalConstants.DefaultProteinPercent
    
    var goalCalories = Constants.NutritionalConstants.DefaultCalories
    
    let proteinTrackLayer = CALayer()
    let carbsTrackLayer = CALayer()
    let fatTrackLayer = CALayer()
    
    let proteinSliderLayer = MacroSliderThumbLayer()
    let carbsSliderLayer = MacroSliderThumbLayer()
    let fatSliderLayer = MacroSliderThumbLayer()
    
    var previousLocation = CGPoint()
    var selection : MacroSelection = .None
    //after moving a selector it loses priority to make it easier to make adjustments with overlapping selectors
    var lastPriority : MacroSelection = .None
    private struct DisplayOptions{
        static let SliderRadius : CGFloat = 13
        static let SliderColor = FlatGray()
        
        static let TrackWidth : CGFloat =  6.0
        static let Padding : CGFloat = 60.0 // allows space for label
        
        static let LabelOffset : CGFloat = 15.0 // how far from edge of circle
        static let LabelFont = UIFont.systemFontOfSize(15)
        static let LabelWidth : CGFloat = 90.0
        static let LabelHeight : CGFloat = 40.0
    }

    var circleDiameter : CGFloat {
        return min(bounds.width, bounds.height) - 2.0 * DisplayOptions.Padding
    }
    
    var xInset : CGFloat {
        return (bounds.width - circleDiameter) / 2.0
    }
    
    var yInset : CGFloat {
        return (bounds.height - circleDiameter) / 2.0
    }
    
    override var frame : CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){
        proteinSliderLayer.slider = self
        layer.addSublayer(proteinSliderLayer)
        
        carbsSliderLayer.slider = self
        layer.addSublayer(carbsSliderLayer)
        
        fatSliderLayer.slider = self
        layer.addSublayer(fatSliderLayer)
        
        updateLayerFrames()
        updatePriority()
    }
    func updateLayerFrames(){
        proteinTrackLayer.frame = bounds.insetBy(dx: xInset, dy: yInset)
        proteinTrackLayer.setNeedsDisplay()
        
        carbsTrackLayer.frame = bounds.insetBy(dx: xInset, dy: yInset)
        carbsTrackLayer.setNeedsDisplay()
        
        fatTrackLayer.frame = bounds.insetBy(dx: xInset, dy: yInset)
        fatTrackLayer.setNeedsDisplay()
        
        proteinSliderLayer.frame = frameForSliderValue(proteinPosition)
        proteinSliderLayer.setNeedsDisplay()
        
        carbsSliderLayer.frame = frameForSliderValue(carbsPosition)
        carbsSliderLayer.setNeedsDisplay()
        
        fatSliderLayer.frame = frameForSliderValue(fatPosition)
        fatSliderLayer.setNeedsDisplay()
        
        self.setNeedsDisplay()
    }
    
    // MARK - Tracking Methods

    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousLocation = touch.locationInView(self)
        
        
        // Hit test the thumb layers
        if proteinSliderLayer.frame.contains(previousLocation) {
            proteinSliderLayer.highlighted = true
            selection = .Protein
        } else if carbsSliderLayer.frame.contains(previousLocation) {
            carbsSliderLayer.highlighted = true
            selection = .Carbs
        } else if fatSliderLayer.frame.contains(previousLocation) {
            fatSliderLayer.highlighted = true
            selection = .Fat
        } else {
            selection = .None
            return false
        }
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let value = getPositionForSelection()
        let newLocation = touch.locationInView(self)
        let delta = getValueChangeForDrag(value, start: previousLocation, end: newLocation)
        updatePositionForSelection(delta)
        //update the UI
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayerFrames()
        CATransaction.commit()
        previousLocation = newLocation
        delegate?.valueChanged()
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        updatePriority()
        selection = .None
        saveMacroValues()
    }
    
    // MARK - Drawing
    
    override func drawRect(rect: CGRect) {
        
        //draw tracks in macro respective colors
        let proteinArc = UIBezierPath(arcCenter: centerOfCircle(), radius: circleDiameter / 2.0, startAngle: getRadians(fatPosition), endAngle: getRadians(proteinPosition), clockwise: true)
        proteinArc.lineWidth = DisplayOptions.TrackWidth
        Constants.Colors.ProteinColor.setStroke()
        proteinArc.stroke()
        
        let carbsArc = UIBezierPath(arcCenter: centerOfCircle(), radius: circleDiameter / 2.0, startAngle: getRadians(proteinPosition), endAngle: getRadians(carbsPosition), clockwise: true)
        carbsArc.lineWidth = DisplayOptions.TrackWidth
        Constants.Colors.CarbColor.setStroke()
        carbsArc.stroke()
        
        let fatArc = UIBezierPath(arcCenter: centerOfCircle(), radius: circleDiameter / 2.0, startAngle: getRadians(carbsPosition), endAngle: getRadians(fatPosition), clockwise: true)
        fatArc.lineWidth = DisplayOptions.TrackWidth
        Constants.Colors.FatColor.setStroke()
        fatArc.stroke()
        
        
        //draw slider cirlces
        DisplayOptions.SliderColor.setFill()
        let proteinSlider = UIBezierPath(arcCenter: centerForSlider(proteinPosition),
            radius: DisplayOptions.SliderRadius, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        proteinSlider.fill()
        
        let carbSlider = UIBezierPath(arcCenter: centerForSlider(carbsPosition),
            radius: DisplayOptions.SliderRadius, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        carbSlider.fill()
        
        let fatSlider = UIBezierPath(arcCenter: centerForSlider(fatPosition),
            radius: DisplayOptions.SliderRadius, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        fatSlider.fill()
        
        //draw labels
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        textStyle.lineBreakMode = .ByClipping
        let textFontAttributes = [NSFontAttributeName: DisplayOptions.LabelFont,
            NSParagraphStyleAttributeName: textStyle]
        
        let proteinLabel : NSString = "Protein \(Int(protein * 100))% \n\(proteinGrams)g"
        proteinLabel.drawInRect(frameForLabel(fatPosition - 1.0, afterPosition: proteinPosition), withAttributes: textFontAttributes)
        
        let carbsLabel : NSString = "Carbs \(Int(carbs * 100))% \n\(carbsGrams)g"
        carbsLabel.drawInRect(frameForLabel(proteinPosition, afterPosition: carbsPosition), withAttributes: textFontAttributes)

        let fatLabel : NSString = "Fat \(Int(fat * 100))% \n\(fatGrams)g"
        fatLabel.drawInRect(frameForLabel(carbsPosition, afterPosition: fatPosition), withAttributes: textFontAttributes)
    }
    
    

    
    // MARK - Utility Methods
    
    //converts the 0 - 1.0 position scale to angle in terms of radians, converted
    func getRadians(position : Double) -> CGFloat {
        return CGFloat((position - 0.25) * 2.0 * M_PI)
    }
    
    //a dynamic radius added to absolute radius to account for clunky width/height of frame label is drawn in
    func getFlexLabelOffset(position : Double) -> CGFloat {
        let extraWidth = CGFloat((-cos(position * M_PI * 4.0) + 1.0)) * DisplayOptions.LabelWidth / 4.0
        let extraHeight = CGFloat((cos(position * M_PI * 4.0) + 1.0)) * DisplayOptions.LabelHeight / 4.0
        return DisplayOptions.LabelOffset + extraWidth + extraHeight
    }
    
    func centerOfCircle() -> CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    //converts angle/radius to a CGPoint
    func getPositionInCircle(position : Double, radius : CGFloat) -> CGPoint {
        let dx = CGFloat(sin(position * M_PI * 2.0)) * radius
        let dy = CGFloat(-cos(position * M_PI * 2.0)) * radius
        return CGPoint(x: bounds.midX + dx, y: bounds.midY + dy)
    }
    
    func centerForSlider(position : Double) -> CGPoint{
        return getPositionInCircle(position, radius: circleDiameter / 2.0)
    }
    
    func frameForSliderValue(position : Double) -> CGRect {
        let center = centerForSlider(position)
        return CGRect(x: center.x - DisplayOptions.SliderRadius,
            y: center.y - DisplayOptions.SliderRadius,
            width: DisplayOptions.SliderRadius * 2.0,
            height: DisplayOptions.SliderRadius * 2.0)
        
    }
    
    func frameForLabel(beforePosition : Double, afterPosition : Double) -> CGRect{
        let position = (beforePosition + afterPosition) / 2.0
        let center = getPositionInCircle(position, radius: circleDiameter / 2.0 + getFlexLabelOffset(position))
        return CGRect(x: center.x - DisplayOptions.LabelWidth / 2.0,
            y: center.y - DisplayOptions.LabelHeight / 2.0,
            width: DisplayOptions.LabelWidth,
            height: DisplayOptions.LabelHeight)
    }

    
    func getValueChangeForDrag(value : Double, start : CGPoint, end : CGPoint) -> Double {
        //vector from center of Circle to start point
        let startVect = CGVector(dx: start.x - bounds.midX, dy: start.y - bounds.midY)
        //vector from center of Circle to end point
        let endVect = CGVector(dx: end.x - bounds.midX, dy: end.y - bounds.midY)
        
        let magnitude = sqrt(pow(startVect.dx, 2) + pow(startVect.dy, 2)) *
                        sqrt(pow(endVect.dx, 2) + pow(endVect.dy, 2))
        let dotProduct = startVect.dx * endVect.dx + startVect.dy * endVect.dy
        
        //angle different between start and end vectors
        let dTheta = acos(dotProduct / magnitude)
        
        //calculate sign
        //vector tangent to circle circumference
        let normalTheta = (value + 0.25) * M_PI * 2.0
        let normalVect = CGVector(dx: sin(normalTheta), dy: -cos(normalTheta))
        let normalDotProduct = normalVect.dx * endVect.dx + normalVect.dy * endVect.dy
        let sign = normalDotProduct > 0 ? 1.0 : -1.0
        
        return Double(dTheta) * sign / (M_PI * 2.0)
    }
    
    func getPositionForSelection() -> Double{
        switch selection {
        case .Protein : return proteinPosition
        case .Carbs : return carbsPosition
        case .Fat : return fatPosition
        case .None : return 0.0
        }
    }
    
    func bound(value : Double, minValue : Double, maxValue : Double) -> Double{
        return max(min(maxValue, value), minValue)
    }
    

    // MARK - Update Methods

    
    func updatePositionForSelection(delta : Double){
        switch selection {
        case .Protein : proteinPosition = bound(proteinPosition + delta, minValue: fatPosition - 1.0, maxValue: carbsPosition)
        case .Carbs : carbsPosition = bound(carbsPosition + delta, minValue: proteinPosition, maxValue: fatPosition)
        case .Fat : fatPosition = bound(fatPosition + delta, minValue: carbsPosition, maxValue: proteinPosition + 1.0)
        case .None : break
        }
    }
    
    func updatePriority(){
        lastPriority = selection
        switch selection {
        case .Protein :
            proteinSliderLayer.zPosition = -1.0
            carbsSliderLayer.zPosition = 0.0
            fatSliderLayer.zPosition = 0.0
        case .Carbs :
            proteinSliderLayer.zPosition = 0.0
            carbsSliderLayer.zPosition = -1.0
            fatSliderLayer.zPosition = 0.0
        case .Fat :
            proteinSliderLayer.zPosition = 0.0
            carbsSliderLayer.zPosition = 0.0
            fatSliderLayer.zPosition = -1.0
        case .None :
            proteinSliderLayer.zPosition = 0.0
            carbsSliderLayer.zPosition = 0.0
            fatSliderLayer.zPosition = 0.0
        }
    }
    
    func updateCalories(calories : Int){
        self.goalCalories = calories
        self.setNeedsDisplay()
    }
    
    func updateMacroValues(protein : Float, carbs : Float, fat : Float){
        proteinPosition = Double(protein)
        carbsPosition = Double(protein + carbs)
        fatPosition = Double(protein + carbs + fat)
    }
    
    func saveMacroValues(){
        CustomUser.currentUser()!.setValue(protein, forKey: Constants.Parse.UserKeys.GoalProtein)
        CustomUser.currentUser()!.setValue(carbs, forKey: Constants.Parse.UserKeys.GoalCarbs)
        CustomUser.currentUser()!.setValue(fat, forKey: Constants.Parse.UserKeys.GoalFat)

        CustomUser.currentUser()!.saveInBackground()
    }
    
}