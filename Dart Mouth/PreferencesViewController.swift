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

//import DTPickerPresenter

class PreferencesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, TTRangeSliderDelegate {

    enum Gender : String {
        case Male = "Male", Female = "Female"
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
    
    @IBOutlet weak var estimatedDailyText: UITextField!
    
    @IBOutlet weak var caloriesDisplay: UILabel!
    
    
    
//    @IBOutlet weak var goalCaloriesLabel: UILabel!
//    
//    @IBOutlet weak var goalCaloriesText: UITextField!{
//        didSet{
//            goalCaloriesText.delegate = self
//        }
//    }
    
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
    var age : Int?
    var weight : Int?
    var height : Int?
    
    
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
        static let GenderOptions : [Gender] = [Gender.Male, Gender.Female]
        static let AgeOptions : Range<Int> = 12...99 // years
        static let WeightOptions : Range<Int> = 100...500 // pounds
        static let HeightOptions : Range<Int> = 36...96 // inches
        
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
        caloriesDisplay.textAlignment = .Center
        
        
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
    
    // MARK - UIPickerViewDataSource methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        switch pickerView {
//        case genderPicker : return DisplayOptions.GenderOptions.count
//        case agePicker : return DisplayOptions.AgeOptions.count
//        case weightPicker : return DisplayOptions.WeightOptions.count
//        case heightPicker : return DisplayOptions.HeightOptions.count
//        default : return 0
//        }
        return 10
    }
    
    // MARK - UIPickerViewDelegate methods

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Option"
//        switch pickerView {
//        case genderPicker : return DisplayOptions.GenderOptions[row].rawValue
//        case agePicker : return String(DisplayOptions.AgeOptions.first!)
//        case weightPicker : return String(DisplayOptions.WeightOptions.first!)
//        case heightPicker : return getHeightOptionString(DisplayOptions.HeightOptions.first!)
//        default : return ""
//        }
    }
    
    // MARK: - Gesture actions

    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - UITextField option / update methods
    
    func getOptionsForTextField(textField: UITextField) -> [String]{
        switch textField{
        case genderText: return DisplayOptions.GenderOptions.map({$0.rawValue})
        case ageText: return DisplayOptions.AgeOptions.map({String($0)})
        case weightText: return DisplayOptions.WeightOptions.map({String($0)})
        case heightText: return DisplayOptions.HeightOptions.map({getHeightOptionString($0)})
        default: return []
        }
    }
    
    func getTitleForTextField(textField: UITextField) -> String{
        switch textField{
        case genderText: return "Select Gender"
        case ageText: return "Select Age"
        case weightText: return "Select Weight"
        case heightText: return "Select Height"
        default: return ""
        }
    }
    
    func updateValueForTextField(textField: UITextField, index: Int){
        switch textField{
        case genderText: gender = DisplayOptions.GenderOptions[index]
        case ageText: age = DisplayOptions.AgeOptions.first! + index
        case weightText: weight = DisplayOptions.WeightOptions.first! + index
        case heightText: height = DisplayOptions.HeightOptions.first! + index
        default: return
        }
    }
    
    func getSelectedValueForTextField(textField: UITextField) -> Int{
        switch textField{
        case genderText:
            if let g = gender {
                return g == .Female ? 1 : 0
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
        default: return 0
        }
    }
    
    func updateEstimatedCaloriesIfPossible(){
        if let g = gender, a = age, w = weight, h = height{
            let estimate = getBMR(w, height: h, age: a, gender: g)
            estimatedDailyText.text = String(estimate)
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

    //Base on Mifflin-St Jeor equation
    func getBMR(weight : Int, height : Int, age : Int, gender : Gender) -> Int {
        let genderFactor : Float = (gender == .Male) ? 5.0: -161.0
        return Int(round(22.05 * Float(weight) + 2.4601 * Float(height) - 5.0 * Float(age) + genderFactor))
    }
    
    func getWeightOptionString(value: Int) -> String {
        return "\(weight) lbs"
    }
    func getHeightOptionString(value : Int) -> String {
        let feet = value / 12
        let inches = value % 12
        
        return "\(feet)' \(inches)\""
    }
    
}
