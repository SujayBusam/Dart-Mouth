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
import ActionSheetPicker_3_0

class PreferencesViewController: UIViewController, UITextFieldDelegate, TTRangeSliderDelegate {

    enum Gender : Int {
        case Male = 0, Female
    }
    
    enum ActivityLevel : Int {
        case Sedentary = 0, Light, Moderate, Very, Extra
    }
    
    
    @IBOutlet weak var genderText: UITextField!{
        didSet{
            genderText.delegate = self
        }
    }
    
    @IBOutlet weak var ageText: UITextField!{
        didSet{
            ageText.delegate = self
        }
    }
    
    @IBOutlet weak var weightText: UITextField!{
        didSet{
            weightText.delegate = self
        }
    }
    
    @IBOutlet weak var heightText: UITextField!{
        didSet{
            heightText.delegate = self
        }
    }
    
    @IBOutlet weak var activityText: UITextField!{
        didSet{
            activityText.delegate = self
        }
    }
    
    @IBOutlet weak var goalText: UITextField!{
        didSet{
            goalText.delegate = self
        }
    }
    
    
    @IBOutlet weak var dailyBurnedLabel: UILabel!
    
    @IBOutlet weak var caloriesDisplay: UILabel!
    
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
    
    var picker: ActionSheetStringPicker!
    
    var gender : Gender?
    var activityLevel : ActivityLevel?
    var age : Int?
    var weight : Int?
    var height : Int?
    var goal : Float?
    
    
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
        //COLORS
        static let GramLabelColor = FlatGray()
        
        //PICKER OPTIONS
        static let GenderOptions : [Gender] = [.Male, .Female]
        static let ActivityOptions : [ActivityLevel] = [.Sedentary, .Light, .Moderate, .Very, .Extra]
        static let GoalOptions: [Float] = [-1.5, -1.0, -0.5, 0, 0.5, 1.0, 1.5]
        static let AgeOptions : Range<Int> = 12...99 // years
        static let WeightOptions : Range<Int> = 100...500 // pounds
        static let HeightOptions : Range<Int> = 48...96 // inches
        
        static let CalorieColorDefault = FlatWhiteDark()
        static let CalorieColorCalculated = FlatPowderBlue()
    }
    
    var calories : Int = Constants.NutritionalConstants.DefaultCalories
    
    let percentFormatter = NSNumberFormatter()
    let gramFormatter = NSNumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title to the user's email
        self.navigationItem.title = CustomUser.currentUser()?.email
        
        // Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self,
            action: NSSelectorFromString(Identifiers.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        genderText.textAlignment = .Center
        ageText.textAlignment = .Center
        weightText.textAlignment = .Center
        heightText.textAlignment = .Center
        activityText.textAlignment = .Center
        goalText.textAlignment = .Center
        dailyBurnedLabel.textAlignment = .Center
        dailyBurnedLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
        caloriesDisplay.textAlignment = .Center
        goalText.backgroundColor = Constants.Colors.appPrimaryColor
        goalText.textColor = UIColor.whiteColor()
        caloriesDisplay.textColor = DisplayOptions.CalorieColorCalculated
        
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
        
        retrieveUserStats()
        updateMacroLabels()
        updateEstimatedCaloriesIfPossible()
    }
    
    func retrieveUserStats(){
//        if let a = CustomUser.currentUser()!.valueForKey(CustomUser.KeyNames.) as? Int {
//            age = a
//            
// 
//        } else {
//        }
        CustomUser.currentUser()!.setValue(123, forKey: "age")
        CustomUser.currentUser()!.saveInBackground()
        
    }
    // MARK: - Gesture actions

    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - UITextField option / update methods
    
    func getOptionsForTextField(textField: UITextField) -> [String]{
        switch textField{
        case genderText: return DisplayOptions.GenderOptions.map({getGenderOptionString($0)})
        case activityText: return DisplayOptions.ActivityOptions.map({getActivityOptionString($0)})
        case ageText: return DisplayOptions.AgeOptions.map({String($0)})
        case weightText: return DisplayOptions.WeightOptions.map({String($0)})
        case heightText: return DisplayOptions.HeightOptions.map({getHeightOptionString($0)})
        case goalText: return DisplayOptions.GoalOptions.map({getGoalOptionStringValue($0)})
        default: return []
        }
    }
    
    func getTitleForTextField(textField: UITextField) -> String{
        switch textField{
        case genderText: return "Select Gender"
        case activityText: return "Select Activity Level"
        case ageText: return "Select Age"
        case weightText: return "Select Weight"
        case heightText: return "Select Height"
        case goalText: return "Select Goal"
        default: return ""
        }
    }
    
    func updateValueForTextField(textField: UITextField, index: Int){
        switch textField{
        case genderText:
            gender = DisplayOptions.GenderOptions[index]
            
        case activityText : activityLevel = DisplayOptions.ActivityOptions[index]
        case ageText: age = DisplayOptions.AgeOptions.first! + index
        case weightText: weight = DisplayOptions.WeightOptions.first! + index
        case heightText: height = DisplayOptions.HeightOptions.first! + index
        case goalText: goal = DisplayOptions.GoalOptions[index]
        default: return
        }
    }
    
    func getSelectedValueForTextField(textField: UITextField) -> Int{
        switch textField{
        case genderText:
            if let g = gender {
                return g.rawValue
            } else { return 0 }
        case activityText:
            if let l = activityLevel{
                return l.rawValue
            } else { return 0 }
        case ageText:
            if let a = age {
                return a - DisplayOptions.AgeOptions.first!
            } else { return 0 }
        case weightText:
            if let w = weight {
                print(w)
                print(DisplayOptions.WeightOptions.first!)
                return w - DisplayOptions.WeightOptions.first!
            } else { return 0 }
        case heightText:
            if let h = height{
                return h - DisplayOptions.HeightOptions.first!
            } else { return 0 }
        case goalText:
            if let g = goal {
                return DisplayOptions.GoalOptions.indexOf(g)!
            } else {return 0}
        default: return 0
        }
    }
    
    func updateEstimatedCaloriesIfPossible(){
        if let g = gender, a = age, w = weight, h = height, l = activityLevel{
            let estimate = getBMR(w, height: h, age: a, gender: g, level: l)
            dailyBurnedLabel.text = String(estimate)
            dailyBurnedLabel.textColor = DisplayOptions.CalorieColorCalculated

            
            if let userGoal = goal{
                let goalValue = Int(userGoal * 500)
                let total = estimate + goalValue
                let op = userGoal >= 0 ? "+" : "-"

                caloriesDisplay.text = "\(estimate) \(op) \(abs(goalValue))= \(total)"
            } else {
                caloriesDisplay.text = ""
            }
        } else {
            dailyBurnedLabel.text = String(Constants.NutritionalConstants.DefaultCalories)
            dailyBurnedLabel.textColor = DisplayOptions.CalorieColorDefault
        }
    }
    // MARK: - UITextField protocol methods

    //only calories field is delegated to this class
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let title = getTitleForTextField(textField)
        let options = getOptionsForTextField(textField)
        let selected = getSelectedValueForTextField(textField)
        
        picker = ActionSheetStringPicker(title: title, rows: options, initialSelection: selected, doneBlock: {
            picker, index, value in
            self.updateValueForTextField(textField, index: index)
            textField.text = String(value)
            self.updateEstimatedCaloriesIfPossible()
            textField.resignFirstResponder()
            return
            }, cancelBlock: {
            ActionStringCancelBlock in
            textField.resignFirstResponder()
            return
            }, origin: textField)
        picker.showActionSheetPicker()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        caloriesEntered()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        caloriesEntered()
        
        picker = ActionSheetStringPicker(title: "Title", rows: ["Male", "Female"], initialSelection: 0, doneBlock: {
              picker, value, index in
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            return
            }, cancelBlock: {ActionStringCancelBlock in return}, origin: textField)
        picker.showActionSheetPicker()
        return true
    }
    
    
    

    
    func caloriesEntered(){
//        if var newValue : Int = Int(goalCaloriesText.text!){
//            newValue = min(newValue, DisplayOptions.MaxCalories)
//            newValue = max(newValue, DisplayOptions.MinCalories)
//            calories = newValue
//        }
//        goalCaloriesText.text = String(calories)
//        updateMacroLabels()
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
    
    

    //MARK: - Utility Methods

    func getActivityMultiplier(level : ActivityLevel) -> Float{
        switch(level){
        case .Sedentary: return 1.2
        case .Light: return 1.375
        case .Moderate: return 1.55
        case .Very: return 1.725
        case .Extra: return 1.9
        }
    }
    //Base on Mifflin-St Jeor equation
    func getBMR(weight : Int, height : Int, age : Int, gender : Gender, level : ActivityLevel) -> Int {
        let activityMultiplier = getActivityMultiplier(level)
        let genderFactor : Float = (gender == .Male) ? 5.0: -161.0
        return Int(round(activityMultiplier * (4.536 * Float(weight) + 15.875 * Float(height) - 5.0 * Float(age) + genderFactor)))
    }
    
    func getGenderOptionString(gender: Gender) -> String {
        switch gender{
        case .Male: return "Male"
        case .Female: return "Female"
        }
    }
    
    func getActivityOptionString(level: ActivityLevel) -> String {
        switch level{
        case .Sedentary: return "Sedentary"
        case .Light: return "Light"
        case .Moderate: return "Moderate"
        case .Very: return "High"
        case .Extra: return "Extreme"
        }
    }
    
    
    func getWeightOptionString(value: Int) -> String {
        return "\(weight) lbs"
    }
    func getHeightOptionString(value : Int) -> String {
        let feet = value / 12
        let inches = value % 12
        
        return "\(feet)' \(inches)\""
    }
    
    func getGoalOptionStringValue(value: Float) -> String {
        if value == 0.0{
            return "I want to stay the same weight"
        }
        let verb = (value > 0) ? "gain" : "lose"
        return "I want to \(verb) \(abs(value)) lbs/week!"
    }
    
}
