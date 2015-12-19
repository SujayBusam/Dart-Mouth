//
//  MenuViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/9/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import PureLayout
import ChameleonFramework
import AKPickerView_Swift

class MenuViewController: UIViewController, DateNavigationControlDelegate, AKPickerViewDataSource, AKPickerViewDelegate {
    
    // String constants, in case we ever need to change them
    private struct Constants {
        static let Foco = "Foco"
        static let Hop = "HOP"
        static let Novack = "Novack"
        
        static let Breakfast = "Breakfast"
        static let Lunch = "Lunch"
        static let Dinner = "Dinner"
        static let LateNight = "Late Night"
    }
    
    // Constants for segments
    private struct Segments {
        static let Venues = [Constants.Foco, Constants.Hop, Constants.Novack]
        static let MealTimes = [Constants.Breakfast, Constants.Lunch, Constants.Dinner, Constants.LateNight]
    }
    
    // The current menu date.
    var date: NSDate = NSDate() {
        didSet {
            updateUI()
        }
    }
    
    var venueSegmentedControl: UISegmentedControl!
    var mealtimeSegmentedControl: UISegmentedControl!
    var menuPickerView: AKPickerView! {
        didSet {
            menuPickerView.delegate = self
            menuPickerView.dataSource = self
        }
    }

    @IBOutlet weak var dateNavigationControl: DateNavigationControl! {
        didSet { dateNavigationControl.delegate = self }
    }
    
    override func viewDidLoad() {
        print("Loading vc")
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        venueSegmentedControl.selectedSegmentIndex = 0
        mealtimeSegmentedControl.selectedSegmentIndex = 0 // TODO: select smarter default based on current time
        
        updateUI()
    }
    
    func updateUI() {
        print("Updating control UI")
        dateNavigationControl.updateDateLabel()
    }
    
    func setupViews() {
        venueSegmentedControl = UISegmentedControl(items: Segments.Venues)
        
        mealtimeSegmentedControl = UISegmentedControl(items: Segments.MealTimes)
        
        menuPickerView = AKPickerView()
        menuPickerView.textColor = ColorUtil.appPrimaryColorLight
        menuPickerView.interitemSpacing = 10
        
        self.view.addSubview(venueSegmentedControl)
        self.view.addSubview(mealtimeSegmentedControl)
        self.view.addSubview(menuPickerView)
    }
    
    func setupConstraints() {
        venueSegmentedControl.autoPinToTopLayoutGuideOfViewController(self, withInset: self.view.layoutMargins.top)
        venueSegmentedControl.autoPinEdgeToSuperviewMargin(.Left)
        venueSegmentedControl.autoPinEdgeToSuperviewMargin(.Right)
        
        mealtimeSegmentedControl.autoPinEdge(.Top, toEdge: .Bottom, ofView: venueSegmentedControl, withOffset: venueSegmentedControl.layoutMargins.bottom)
        mealtimeSegmentedControl.autoPinEdgeToSuperviewMargin(.Left)
        mealtimeSegmentedControl.autoPinEdgeToSuperviewMargin(.Right)
        
        menuPickerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: mealtimeSegmentedControl, withOffset: mealtimeSegmentedControl.layoutMargins.bottom)
        menuPickerView.autoPinEdgeToSuperviewMargin(.Left)
        menuPickerView.autoPinEdgeToSuperviewMargin(.Right)
    }
    
    // MARK: - Event functions for segmented controls
    
    
    
    // MARK: - Delegate functions for custom DateNavigationControl
    
    func dateForDateNavigationControl(sender: DateNavigationControl) -> NSDate {
        return date
    }

    func leftArrowWasPressed(sender: UIButton) {
        if let dayBefore = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: self.date, options: []) {
            self.date = dayBefore
        } else {
            print("Date decrement calculation failed")
        }
    }
    
    func rightArrowWasPressed(sender: UIButton) {
        if let dayAfter = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: self.date, options: []) {
            self.date = dayAfter
        } else {
            print("Date increment calculation failed")
        }
    }
    
    // MARK: - AKPickerViewDataSource
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return 9
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return ["some", "thing", "here", "more", "again", "so", "123", "asdf", "ninth"][item]
    }
    
    // MARK: - AKPickerViewDelegate
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        print("Item \(item) selected.")
    }
    
    // MARK: - Miscellaneous
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
