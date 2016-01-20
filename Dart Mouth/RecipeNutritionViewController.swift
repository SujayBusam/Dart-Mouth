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
class RecipeNutritionViewController: UIViewController, UIPickerViewDataSource,
    UIPickerViewDelegate, UIPopoverPresentationControllerDelegate,
    DiaryAdderViewControllerDelegate {
    
    // MARK: - Local Constants
    
    struct Identifiers {
        static let ErrorNutrientValue = "N/A"
    }
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
    }
    
    struct PickerValues {
        static let ZeroIndicator = "-"
        static let NumComponents = 3
        static let MaxNumServings = 1000
        static let ServingsStringSingular = "Serving"
        static let ServingsStringPlural = "Servings"
        static let AlphaValue: CGFloat = 1.0
    }
    
    struct Colors {
        static let PickerBackground = UIColor(hexString: "F7F7F7")
    }
    
    let fractions: [(stringValue: String, floatValue: Float)] = [
        (PickerValues.ZeroIndicator, 0),
        ("\u{215B}", 1/8),
        ("\u{00BC}", 1/4),
        ("\u{2153}", 1/3),
        ("\u{00BD}", 1/2),
        ("\u{2154}", 2/3),
        ("\u{00BE}", 3/4),
    ]
    
    
    // MARK: - Outlets
    
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
    
    
    // MARK: - Instance Variables
    
    var recipe: Recipe! {
        didSet { updateUI() }
    }
    
    var servingSizeMultiplier: Float = 1 {
        didSet { updateUI() }
    }
    
    var addToDiaryBarButtonItem: UIBarButtonItem?
    
    var allBarButtonItems: [UIBarButtonItem] {
        // Add more items here as needed.
        
        var items = [UIBarButtonItem]()
        if self.addToDiaryBarButtonItem != nil {
            items.append(self.addToDiaryBarButtonItem!)
        }
        
        return items
    }
    
    // MARK: - View Setup
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
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
        // Setup serving size picker
        servingSizePicker.backgroundColor = Colors.PickerBackground
        servingSizePicker.alpha = PickerValues.AlphaValue
        servingSizePicker.selectRow(1, inComponent: 0, animated: false)
        
        // Add toolbar items
        self.setToolbarItems(self.allBarButtonItems, animated: false)
    }
    
    // Method to call if any or all displayed nutrition values need updating.
    func updateUI() {
        guard servingSizePicker != nil else { return }
        
        recipeName?.text = recipe.name
        caloriesValue?.text = "\(getMultipliedIntegerValue(recipe.getCalories()) ?? Identifiers.ErrorNutrientValue)"
        totalFatValue?.text = "\(getMultipliedFloatValue(recipe.getTotalFat()) ?? Identifiers.ErrorNutrientValue) g"
        saturatedFatValue?.text = "\(getMultipliedFloatValue(recipe.getSaturatedFat()) ?? Identifiers.ErrorNutrientValue) g"
        cholesterolValue?.text = "\(getMultipliedFloatValue(recipe.getCholesterol()) ?? Identifiers.ErrorNutrientValue) mg"
        sodiumValue?.text = "\(getMultipliedFloatValue(recipe.getSodium()) ?? Identifiers.ErrorNutrientValue) mg"
        totalCarbsValue?.text = "\(getMultipliedFloatValue(recipe.getTotalCarbs()) ?? Identifiers.ErrorNutrientValue) g"
        fiberValue?.text = "\(getMultipliedFloatValue(recipe.getFiber()) ?? Identifiers.ErrorNutrientValue) g"
        sugarsValue?.text = "\(getMultipliedFloatValue(recipe.getFiber()) ?? Identifiers.ErrorNutrientValue) g"
        proteinValue?.text = "\(getMultipliedFloatValue(recipe.getProtein()) ?? Identifiers.ErrorNutrientValue) g"
        servingSizeValue?.text = "\(recipe.getServingSizeGrams()?.description ?? Identifiers.ErrorNutrientValue) g"
        
    }
    
    
    // MARK: - Helper functions
    
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
    
    // MARK: - Button actions
    
    // Action for pressing cancel button on the left of navigation bar
    // Note - this isn't being used right now.
    func cancelBarButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addToDiaryButtonPressed(sender: UIBarButtonItem) {
        let popoverContentVC = self.storyboard!
            .instantiateViewControllerWithIdentifier(Constants.ViewControllers.DiaryAdder) as! DiaryAdderViewController
        
        // Configure the popover content VC (the diary adder)
        popoverContentVC.delegate = self
        popoverContentVC.recipe = self.recipe
        popoverContentVC.servingsMultiplier = self.servingSizeMultiplier
        popoverContentVC.date = NSDate() // Current date
        popoverContentVC.modalPresentationStyle = .Popover
        
        // Configure popover presentation controller
        let presentationController = popoverContentVC.popoverPresentationController!
        presentationController.barButtonItem = self.addToDiaryBarButtonItem
        presentationController.delegate = self
        
        self.presentViewController(popoverContentVC, animated: true, completion: nil)
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
            return fractions[row].stringValue
        case 2:
            return getTextComponentForPickerView(pickerView)
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.servingSizeMultiplier = Float(pickerView.selectedRowInComponent(0)) +
            fractions[pickerView.selectedRowInComponent(1)].floatValue
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
    
    
    // MARK: - UIPopoverPresentationControllerDelegate protocol methods
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    // MARK: - DiaryAdderViewControllerDelegate protocol methods
    
    func presentAddedToDiaryAlertForDiaryAdder(sender: DiaryAdderViewController) {
        let alertView = UIAlertController(title: "Success",
            message: "Item added to diary!", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: Constants.Validation.OkActionTitle, style: .Default, handler: nil)
        alertView.addAction(alertAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
}
