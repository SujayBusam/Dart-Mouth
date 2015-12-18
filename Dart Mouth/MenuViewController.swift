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

class MenuViewController: UIViewController, DateNavigationControlDelegate {
    
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
        venueSegmentedControl.tintColor = ColorUtil.appPrimaryColorLight
        
        mealtimeSegmentedControl = UISegmentedControl(items: Segments.MealTimes)
        mealtimeSegmentedControl.tintColor = ColorUtil.appPrimaryColorLight
        
        self.view.addSubview(venueSegmentedControl)
        self.view.addSubview(mealtimeSegmentedControl)
    }
    
    func setupConstraints() {
        venueSegmentedControl.autoPinToTopLayoutGuideOfViewController(self, withInset: self.view.layoutMargins.top)
        venueSegmentedControl.autoPinEdgeToSuperviewMargin(.Left)
        venueSegmentedControl.autoPinEdgeToSuperviewMargin(.Right)
        
        mealtimeSegmentedControl.autoPinEdge(.Top, toEdge: .Bottom, ofView: venueSegmentedControl, withOffset: venueSegmentedControl.layoutMargins.bottom)
        mealtimeSegmentedControl.autoPinEdgeToSuperviewMargin(.Left)
        mealtimeSegmentedControl.autoPinEdgeToSuperviewMargin(.Right)
    }
    
    
    // MARK: Delegate functions for custom DateNavigationControl
    
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
    
    // MARK: Miscellaneous
    
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
