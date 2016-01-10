//
//  DiaryViewController.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/14/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController, DateNavigationControlDelegate, CalorieBudgetViewDelegate {
    
    // MARK: - Local Constants
    
    private struct Dimensions {
        static let NavBarItemHeight: CGFloat = 35
        static let DateNavControlWidth: CGFloat = 190
    }

    
    // MARK: - Instance variables
    
    // The current diary date.
    var date: NSDate = NSDate() {
        didSet { updateUI() }
    }
    
    var dateNavigationControl: DateNavigationControl! {
        didSet { dateNavigationControl.delegate = self }
    }
    
    var calorieBudget: Int = 0 {
        didSet { calorieBudgetView.updateLabels() }
    }
    
    var foodCalories: Int = 0 {
        didSet { calorieBudgetView.updateLabels() }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var calorieBudgetView: CalorieBudgetView! {
        didSet { calorieBudgetView.delegate = self }
    }
    
    // MARK: - Controller / View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateUI()
    }
    
    func updateUI() {
        dateNavigationControl.updateDateLabel()
    }
    
    private func setupViews() {
        // Create and setup date navigation control
        dateNavigationControl = DateNavigationControl(frame: CGRectMake(0, 0, Dimensions.DateNavControlWidth, Dimensions.NavBarItemHeight))
        self.navigationItem.titleView = dateNavigationControl
        
        // Initialize calorie budget values
        self.calorieBudget = CustomUser.currentUser()!.goalDailyCalories
        self.foodCalories = 0
    }
    
    
    // MARK: - DateNavigationControlDelegate protocol methods
    
    func dateForDateNavigationControl(sender: DateNavigationControl) -> NSDate {
        return self.date
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
    
    
    // MARK: - CalorieBudgetViewDelegate protocol methods
    
    func budgetValueForCalorieBudgetView(sender: CalorieBudgetView) -> Int {
        return self.calorieBudget
    }
    
    func foodValueForCalorieBudgetView(sender: CalorieBudgetView) -> Int {
        return self.foodCalories
    }
}
