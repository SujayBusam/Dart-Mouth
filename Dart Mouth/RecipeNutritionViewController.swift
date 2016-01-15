//
//  RecipeNutritionViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/7/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit

/*
* UIViewController for a selected Recipe's nutritional information
*/
class RecipeNutritionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate {
    
    struct Strings {
        static let ErrorNutrientValue = "N/A"
    }
    
    struct PickerValues {
        static let ZeroIndicator = "-"
        static let NumComponents = 3
        static let MaxNumServings = 1000
        static let ServingsStringSingular = "Serving"
        static let ServingsStringPlural = "Servings"
        static let AlphaValue: CGFloat = 0.8
    }
    
    struct Colors {
        static let PickerBackgroud = UIColor(hexString: "F7F7F7")
    }
    
    let fractions: [(String, Float)] = [
        (PickerValues.ZeroIndicator, 0),
        ("\u{215B}", 1/8),
        ("\u{00BC}", 1/4),
        ("\u{2153}", 1/3),
        ("\u{00BD}", 1/2),
        ("\u{2154}", 2/3),
        ("\u{00BE}", 3/4),
    ]
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var caloriesValue: UILabel!
    @IBOutlet weak var totalFatValue: UILabel!
    @IBOutlet weak var saturatedFatValue: UILabel!
    @IBOutlet weak var cholesterolValue: UILabel!
    @IBOutlet weak var sodiumValue: UILabel!
    @IBOutlet weak var totalCarbsValue: UILabel!
    @IBOutlet weak var fiberValue: UILabel!
    @IBOutlet weak var sugarsValue: UILabel!
    @IBOutlet weak var proteinValue: UILabel!
    @IBOutlet weak var servingSizeValue: UILabel!
    
    @IBOutlet weak var servingSizePicker: UIPickerView! {
        didSet {
            servingSizePicker.dataSource = self;
            servingSizePicker.delegate = self;
        }
    }
    
    var recipe: Recipe! {
        didSet { updateUI() }
    }
    
    var servingSizeMultiplier: Float = 1 {
        didSet { updateUI() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSubViews() {
        servingSizePicker.backgroundColor = Colors.PickerBackgroud
        servingSizePicker.alpha = PickerValues.AlphaValue
        servingSizePicker.selectRow(1, inComponent: 0, animated: false)
    }
    
    // Method to call if any or all displayed nutrition values need updating.
    func updateUI() {
        guard servingSizePicker != nil else { return }
        
        recipeName?.text = recipe.name
        caloriesValue?.text = "\(getMultipliedIntegerValue(recipe.getCalories()) ?? Strings.ErrorNutrientValue)"
        totalFatValue?.text = "\(getMultipliedFloatValue(recipe.getTotalFat()) ?? Strings.ErrorNutrientValue) g"
        saturatedFatValue?.text = "\(getMultipliedFloatValue(recipe.getSaturatedFat()) ?? Strings.ErrorNutrientValue) g"
        cholesterolValue?.text = "\(getMultipliedFloatValue(recipe.getCholesterol()) ?? Strings.ErrorNutrientValue) mg"
        sodiumValue?.text = "\(getMultipliedFloatValue(recipe.getSodium()) ?? Strings.ErrorNutrientValue) mg"
        totalCarbsValue?.text = "\(getMultipliedFloatValue(recipe.getTotalCarbs()) ?? Strings.ErrorNutrientValue) g"
        fiberValue?.text = "\(getMultipliedFloatValue(recipe.getFiber()) ?? Strings.ErrorNutrientValue) g"
        sugarsValue?.text = "\(getMultipliedFloatValue(recipe.getFiber()) ?? Strings.ErrorNutrientValue) g"
        proteinValue?.text = "\(getMultipliedFloatValue(recipe.getProtein()) ?? Strings.ErrorNutrientValue) g"
        servingSizeValue?.text = "\(recipe.getServingSizeGrams()?.description ?? Strings.ErrorNutrientValue) g"
        
    }
    
    // Helper function to apply the multiplier to a float value and return a formatted string
    // Rounds the value to 1 decimal place.
    func getMultipliedFloatValue(value: Float?) -> String? {
        guard value != nil else { return nil }
        
        let newValue = self.servingSizeMultiplier * value!
        let roundedValue = Float(round(newValue * 10) / 10)
        return String(format: "%.1f", roundedValue)
    }
    
    // Helper function to apply the multiplier to an Integer value and return a formatted string
    // Rounds the value to the nearest integer
    func getMultipliedIntegerValue(value: Int?) -> String? {
        guard value != nil else { return nil }
        
        let newValue: Float = self.servingSizeMultiplier * Float(value!)
        return String(Int(round(newValue)))
    }
    
    
    // MARK: - UIPickerViewDataSource protocol methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return PickerValues.NumComponents
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return PickerValues.MaxNumServings
        case 1:
            return fractions.count
        case 2:
            return 1
        default:
            return -1
        }
    }
    
    // MARK: - UIPickerViewDelegate protocol methods
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            if row == 0 { return PickerValues.ZeroIndicator }
            return "\(row)"
        case 1:
            return fractions[row].0
        case 2:
            return getTextComponentForPickerView(pickerView)
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.servingSizeMultiplier = Float(pickerView.selectedRowInComponent(0)) +
            fractions[pickerView.selectedRowInComponent(1)].1
        pickerView.reloadComponent(2)
    }
    
    // Helper function to get the text for the third component in the picker view
    func getTextComponentForPickerView(pickerView: UIPickerView) -> String {
        let servingDigit = pickerView.selectedRowInComponent(0)
        let servingFraction = pickerView.selectedRowInComponent(1)
        if servingDigit == 0 || (servingDigit == 1 && servingFraction == 0) {
            return PickerValues.ServingsStringSingular
        }
        return PickerValues.ServingsStringPlural
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showDiaryAdder":
                if let diaryAdderVC = segue.destinationViewController as? DiaryAdderViewController {
                    if let ppc = diaryAdderVC.popoverPresentationController {
                        ppc.delegate = self
                    }
                    diaryAdderVC.sourceVC = self
                    diaryAdderVC.recipe = self.recipe
                    diaryAdderVC.servingsMultiplier = self.servingSizeMultiplier
                    diaryAdderVC.date = NSDate()
                }
            default:
                break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func presentAddedToDiaryAlert() {
        let alertView = UIAlertController(title: "Success",
            message: "Item added to diary!", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: Constants.Validation.OkActionTitle, style: .Default, handler: nil)
        alertView.addAction(alertAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
}
