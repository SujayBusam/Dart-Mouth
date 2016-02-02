//
//  PreferencesViewController.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/14/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import UIKit
import TTRangeSlider
import ChameleonFramework

class PreferencesViewController: UIViewController, UITextFieldDelegate, TTRangeSliderDelegate {


    
    @IBOutlet weak var goalCaloriesLabel: UILabel!
    
    @IBOutlet weak var goalCaloriesText: UITextField!{
        didSet{
            goalCaloriesText.delegate = self
        }
    }
    
    @IBOutlet weak var macroSlider: TTRangeSlider!{
        didSet{
            macroSlider.delegate = self
        }
    }
    
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var proteinGramsLabel: UILabel!
    @IBOutlet weak var carbsGramsLabel: UILabel!
    @IBOutlet weak var fatGramsLabel: UILabel!
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        // TODO: error handling
        CustomUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            let destinationVC = self.storyboard!
                .instantiateViewControllerWithIdentifier(Constants.ViewControllers.Signup)
            self.navigationController!.presentViewController(destinationVC, animated: true, completion: nil)
        }
    }
    
    struct Identifiers {
        static let DismissKeyboard = "dismissKeyboard"
    }
    
    private struct DisplayOptions{
        static let GramLabelColor = FlatGray()
        
        static let MinCalories = 1000
        static let MaxCalories = 5000
        
    }
    
    var calories : Int = Constants.NutritionalConstants.DefaultCalories
    
    let percentFormatter = NSNumberFormatter()
    let gramFormatter = NSNumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self,
            action: NSSelectorFromString(Identifiers.DismissKeyboard))
        view.addGestureRecognizer(tap)

        
        goalCaloriesLabel.text = "Goal Calories"
        goalCaloriesText.textAlignment = .Center
        
        
        goalCaloriesText.text = String(calories)
        
        percentFormatter.numberStyle = .PercentStyle
        gramFormatter.numberStyle = .DecimalStyle
        gramFormatter.roundingIncrement = 0.5
        macroSlider.numberFormatterOverride = percentFormatter
        
        macroSlider.minValue = 0.0
        macroSlider.maxValue = 1.0
        macroSlider.selectedMinimum = Constants.NutritionalConstants.DefaultProteinPercent
        macroSlider.selectedMaximum = 1.0 - Constants.NutritionalConstants.DefaultFatPercent
        macroSlider.tintColor = Constants.Colors.appPrimaryColor

        proteinGramsLabel.textColor = DisplayOptions.GramLabelColor
        carbsGramsLabel.textColor = DisplayOptions.GramLabelColor
        fatGramsLabel.textColor = DisplayOptions.GramLabelColor
        
        updateMacroLabels()
        
        
    }
    
    // MARK: - Gesture actions

    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - UITextField protocol methods

    //only calories field is delegated to this class
    
    func textFieldDidEndEditing(textField: UITextField) {
        caloriesEntered()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        caloriesEntered()
        return true
    }
    
    func caloriesEntered(){
        if var newValue : Int = Int(goalCaloriesText.text!){
            newValue = min(newValue, DisplayOptions.MaxCalories)
            newValue = max(newValue, DisplayOptions.MinCalories)
            calories = newValue
        }
        goalCaloriesText.text = String(calories)
        updateMacroLabels()
    }
    
    
    
    //MARK: - TTRangeSliderDelegate protocol methods
    
    func rangeSlider(sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        updateMacroLabels()
    }
    
    func updateMacroLabels(){
        let proteinFloat = macroSlider.selectedMinimum
        let fatFloat = 1.0 - macroSlider.selectedMaximum
        let carbFloat = 1.0 - proteinFloat - fatFloat
        
        let proteinGrams = Float(calories) * proteinFloat / Constants.NutritionalConstants.ProteinCaloriesToGram
        let carbsGrams = Float(calories) * carbFloat / Constants.NutritionalConstants.CarbsCaloriesToGram
        let fatGrams = Float(calories) * fatFloat / Constants.NutritionalConstants.FatCaloriesToGram
        
        let proteinLabelString = NSMutableAttributedString(string: "Protein : " + percentFormatter.stringFromNumber(proteinFloat)!)
        proteinLabelString.addAttribute(NSForegroundColorAttributeName, value: Constants.Colors.ProteinColor, range: NSMakeRange(0, "Protein".length))
        let carbsLabelString = NSMutableAttributedString(string: "Carbs : " + percentFormatter.stringFromNumber(carbFloat)!)
        carbsLabelString.addAttribute(NSForegroundColorAttributeName, value: Constants.Colors.CarbColor, range: NSMakeRange(0, "Carbs".length))
        let fatLabelString = NSMutableAttributedString(string: "Fat : " + percentFormatter.stringFromNumber(fatFloat)!)
        fatLabelString.addAttribute(NSForegroundColorAttributeName, value: Constants.Colors.FatColor, range: NSMakeRange(0, "Fat".length))
        
        proteinLabel.attributedText = proteinLabelString
        carbsLabel.attributedText = carbsLabelString
        fatLabel.attributedText = fatLabelString

        proteinGramsLabel.text = gramFormatter.stringFromNumber(proteinGrams)! + "g"
        carbsGramsLabel.text = gramFormatter.stringFromNumber(carbsGrams)! + "g"
        fatGramsLabel.text = gramFormatter.stringFromNumber(fatGrams)! + "g"
    }
    
    
    
    




}
