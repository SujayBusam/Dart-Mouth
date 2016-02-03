//
//  WeekNavigationControl.swift
//  Dart Mouth
//
//  Created by Thomas Kidder on 1/18/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class WeekNavigationControl : DateNavigationControl {
    
    override func updateDateLabel() {
        if let date = delegate?.dateForDateNavigationControl(self) {
            let formatter = NSDateFormatter()
            let endDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 6, toDate: date, options: NSCalendarOptions.MatchNextTime)!
            formatter.dateFormat = "M/dd"
            let text = "Week of " + formatter.stringFromDate(date) + " to " + formatter.stringFromDate(endDate)
            dateLabel.setTitle(text, forState: .Normal)
            
        } else {
            dateLabel.setTitle("", forState: .Normal)
        }
    }
}
