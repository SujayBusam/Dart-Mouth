//
//  MenuViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/9/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, DateNavigationControlDelegate {
    
    var date: NSDate = NSDate() {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var dateNavigationControl: DateNavigationControl! {
        didSet {
            dateNavigationControl.delegate = self
        }
    }
    
    override func viewDidLoad() {
        print("Loading vc")
        super.viewDidLoad()
        
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        print("Updating control UI")
        dateNavigationControl.updateDateLabel()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
