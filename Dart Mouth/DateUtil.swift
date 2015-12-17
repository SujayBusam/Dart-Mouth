//
//  DateUtil.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/10/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

struct DateUtil {
    
    static let weekdayMap = [
        1: "Sunday",
        2: "Monday",
        3: "Tuesday",
        4: "Wednesday",
        5: "Thursday",
        6: "Friday",
        7: "Saturday",
    ]
    
    static func weekdayStringForInt(day: Int) -> String {
        return weekdayMap[day]!
    }
    
    static func shortWeekdayStringForInt(day: Int) -> String {
        let weekday = weekdayStringForInt(day)
        return weekday.substringToIndex(weekday.startIndex.advancedBy(3))
    }
    
    struct CustomDate {
        var day: Int = 0
        var month: Int = 0
        var year: Int = 0
        var weekday: Int = 0
        
        func weekdayString() -> String {
            return weekdayMap[self.weekday]!
        }
        
        func shortWeekdayString() -> String {
            let weekday = weekdayString()
            return weekday.substringToIndex(weekday.startIndex.advancedBy(3))
        }
    }
    
    func getTodaysDate() -> CustomDate {
        let unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday]
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: NSDate())
        
        return CustomDate(day: components.day, month: components.month, year: components.year, weekday: components.weekday)
    }
    
    func getTodaysDatePredicate() -> NSPredicate  {
        let todaysDate = getTodaysDate()
        return NSPredicate(format: "day == %d AND month == %d AND year == %d", todaysDate.day, todaysDate.month, todaysDate.year)
    }
}