//
//  DateUtil.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/10/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

class DateUtil {
    
    struct CustomDate {
        var day: Int = 0
        var month: Int = 0
        var year: Int = 0
        
        init(day: Int, month: Int, year: Int) {
            self.day = day
            self.month = month
            self.year = year
        }
    }
    
    class func getTodaysDate() -> CustomDate {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Year.union(NSCalendarUnit.Month.union(NSCalendarUnit.Day)), fromDate: date)
        
        return CustomDate(day: components.day, month: components.month, year: components.year)
    }
    
    class func getTodaysDatePredicate() -> NSPredicate  {
        let todaysDate = getTodaysDate()
        return NSPredicate(format: "day == %d AND month == %d AND year == %d", todaysDate.day, todaysDate.month, todaysDate.year)
    }
}