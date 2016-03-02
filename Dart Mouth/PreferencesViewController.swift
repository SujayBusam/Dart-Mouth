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
import VBFPopFlatButton
import AMPopTip

class PreferencesViewController: UIViewController, UITextFieldDelegate {

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
    
    
    @IBOutlet weak var dailyEstimate: UILabel!
    
    @IBOutlet weak var dailyBurned: UITextField!{
        didSet{
            dailyBurned.delegate = self
        }
    }
    
    @IBOutlet weak var caloriesDisplay: UILabel!
    
    @IBOutlet weak var macroSlider: MacroSlider!
    
    @IBOutlet weak var setEstimatedButton: VBFPopFlatButton!{
        didSet{
            setEstimatedButton.addTarget(self, action: "buttonPressed", forControlEvents: .TouchUpInside)
        }
    }
  
    @IBOutlet weak var activityTipImage: UIImageView!{
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("tipTapped"))
            activityTipImage.userInteractionEnabled = true
            activityTipImage.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    var activityTipPopUp = AMPopTip()
    
    var picker: ActionSheetStringPicker!
    
    var gender : Gender?
    var activityLevel : ActivityLevel?
    var age : Int?
    var weight : Int?
    var height : Int?
    var goal : Float?
    
    var protein : Float = Float(Constants.NutritionalConstants.DefaultProteinPercent)
    var carbs : Float = Float(Constants.NutritionalConstants.DefaultCarbsPercent)
    var fat : Float = Float(Constants.NutritionalConstants.DefaultFatPercent)

    @IBAction func logoutButtonPressed(sender: UIButton) {
        // TODO: error handling
        CustomUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            let destinationVC = self.storyboard!
                .instantiateViewControllerWithIdentifier(Constants.ViewControllers.Signup)
            self.navigationController!.presentViewController(destinationVC, animated: true, completion: nil)
        }
    }
    
    func buttonPressed(){
        if let cal:Int = Int(dailyEstimate.text!){
            dailyBurned.text = dailyEstimate.text
            burnedCalories = cal
        }
        updateEstimatedCaloriesIfPossible()
    }
    
    func tipTapped(){
        activityTipPopUp.showText(DisplayOptions.ActivityTip, direction: .Left, maxWidth: DisplayOptions.MaxTipWidth, inView: self.view, fromFrame: activityTipImage.frame)
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
        
        static let CalorieColorDefault = UIColor.blackColor()
        static let CalorieColorCalculated = FlatPowderBlueDark()
        static let EstimateButtonActive = Constants.Colors.appPrimaryColor
        static let EstimateButtonInactive = FlatWhiteDark()
        
        static let MinCalories = 1000
        static let MaxCalories = 5000
        
        static let MaxTipWidth : CGFloat = 200.0
        
        static let ActivityTip = "Sedentary: Little to no exercise\nLight: Light: Light exercise 1-3 times/week\nModerate: Moderate exercise 3-5 times/week\n High: Hard exercise 6-7 days/week\n Extreme: Very hard exercise/sports and physically demanding job"
        
        
    }
    
    var burnedCalories : Int = Constants.NutritionalConstants.DefaultCalories
    var goalCalories : Int = Constants.NutritionalConstants.DefaultCalories
    
    
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
        caloriesDisplay.textAlignment = .Center
        goalText.backgroundColor = Constants.Colors.appPrimaryColor
        goalText.textColor = UIColor.whiteColor()
        caloriesDisplay.textColor = DisplayOptions.CalorieColorCalculated
        dailyBurned.textColor = DisplayOptions.CalorieColorCalculated
        setEstimatedButton.setTitle("", forState: .Normal)
        setEstimatedButton.currentButtonStyle = .buttonPlainStyle
        
        activityTipPopUp.shouldDismissOnTap = true
        activityTipPopUp.shouldDismissOnTapOutside = true
        activityTipPopUp.shouldDismissOnSwipeOutside = true
        activityTipPopUp.popoverColor = Constants.Colors.appSecondaryColor

        percentFormatter.numberStyle = .PercentStyle
        gramFormatter.numberStyle = .DecimalStyle
        gramFormatter.roundingIncrement = 0.5
        
        retrieveUserStats()
        updateEstimatedCaloriesIfPossible()
        macroSlider.updateCalories(goalCalories)
        macroSlider.updateMacroValues(protein, carbs: carbs, fat: fat)
    }
    
    func retrieveUserStats(){
        if let savedGender = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.Gender) as? Int {
            gender = Gender(rawValue: savedGender)
            genderText.text = String(DisplayOptions.GenderOptions[savedGender])
        }
        
        if let savedAge = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.Age) as? Int{
            age = savedAge
            ageText.text = String(savedAge)
        }
        
        if let savedWeight = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.Weight) as? Int{
            weight = savedWeight
            weightText.text = String(savedWeight)
        }
        
        if let savedHeight = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.Height) as? Int{
            height = savedHeight
            heightText.text = getHeightOptionString(savedHeight)
        }
        
        if let savedGoal = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.GoalChange) as? Float {
            goal = savedGoal
            goalText.text = getGoalOptionStringValue(savedGoal)
        }
        
        if let savedActivity = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.Activity) as? Int {
            activityLevel = ActivityLevel(rawValue: savedActivity)
            activityText.text = getActivityOptionString(activityLevel!)
        }
        
        if let savedGoalCalories = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.GoalCalories) as? Int{
            goalCalories = savedGoalCalories
            let burned = savedGoalCalories - Int(500 * goal!)
            burnedCalories = burned
            dailyBurned.text = String(burned)
        }
        
        if let savedProtein = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.GoalProtein) as? Float{
            protein = savedProtein
        }
        
        if let savedCarbs = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.GoalCarbs) as? Float{
            carbs = savedCarbs
        }
        
        if let savedFat = CustomUser.currentUser()!.objectForKey(Constants.Parse.UserKeys.GoalFat) as? Float{
            fat = savedFat
        }
        
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
            CustomUser.currentUser()!.setValue(gender?.rawValue, forKey: Constants.Parse.UserKeys.Gender)
        case activityText :
            activityLevel = DisplayOptions.ActivityOptions[index]
            CustomUser.currentUser()!.setValue(activityLevel?.rawValue, forKey: Constants.Parse.UserKeys.Activity)
        case ageText:
            age = DisplayOptions.AgeOptions.first! + index
            CustomUser.currentUser()!.setValue(age, forKey: Constants.Parse.UserKeys.Age)
        case weightText:
            weight = DisplayOptions.WeightOptions.first! + index
            CustomUser.currentUser()!.setValue(weight, forKey: Constants.Parse.UserKeys.Weight)
        case heightText:
            height = DisplayOptions.HeightOptions.first! + index
            CustomUser.currentUser()!.setValue(height, forKey: Constants.Parse.UserKeys.Height)
        case goalText:
            goal = DisplayOptions.GoalOptions[index]
            CustomUser.currentUser()!.setValue(goal, forKey: Constants.Parse.UserKeys.GoalChange)
        default: return
        }
        CustomUser.currentUser()!.saveInBackground()
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
            dailyEstimate.text = String(estimate)
            dailyEstimate.textColor = DisplayOptions.CalorieColorCalculated
            
            if (burnedCalories != estimate){
                setEstimatedButton.animateToType(.buttonForwardType)
                setEstimatedButton.tintColor = DisplayOptions.EstimateButtonActive
            } else {
                setEstimatedButton.animateToType(.buttonMenuType)
                setEstimatedButton.tintColor = DisplayOptions.EstimateButtonInactive
            }
        } else {
            setEstimatedButton.animateToType(.buttonMenuType)
            setEstimatedButton.tintColor = DisplayOptions.EstimateButtonInactive

            dailyEstimate.text = "---"
            dailyEstimate.textColor = DisplayOptions.CalorieColorDefault
        }
        
        //also update total
        if let userGoal = goal{
            let goalValue = Int(userGoal * 500.0)
            let total = burnedCalories + goalValue
            let op = userGoal >= 0 ? "+" : "-"
            
            caloriesDisplay.text = "\(burnedCalories) \(op) \(abs(goalValue))= \(total)"
            
            goalCalories = total
            CustomUser.currentUser()!.setValue(goalCalories, forKey: Constants.Parse.UserKeys.GoalCalories)
            CustomUser.currentUser()!.saveInBackground()            
            updateMacroLabels()
        } else {
            caloriesDisplay.text = ""
        }
    }
    
    func caloriesEntered(){
        if var newValue : Int = Int(dailyBurned.text!){
            newValue = min(newValue, DisplayOptions.MaxCalories)
            newValue = max(newValue, DisplayOptions.MinCalories)
            burnedCalories = newValue
        }
        dailyBurned.text = String(burnedCalories)
    }
    
    func updateMacroLabels(){
        macroSlider.updateCalories(goalCalories)
    }
    
    
    
    // MARK: - UITextField protocol methods

    //only calories field is delegated to this class
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField == dailyBurned){
            return
        }
        textField.resignFirstResponder()

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
        if(textField == dailyBurned){
            if let cal:Int = Int(textField.text!) {
                burnedCalories = cal
            }
            updateEstimatedCaloriesIfPossible()
        }
        textField.resignFirstResponder()

        caloriesEntered()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == dailyBurned){
            caloriesEntered()
            updateEstimatedCaloriesIfPossible()
        }
        
//        picker = ActionSheetStringPicker(title: "Title", rows: ["Male", "Female"], initialSelection: 0, doneBlock: {
//              picker, value, index in
//            return
//            }, cancelBlock: {ActionStringCancelBlock in return}, origin: textField)
//        picker.showActionSheetPicker()
        return true
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
