//
//  NSDate+ConvenienceInit.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/29/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

extension NSDate {
    
    // Allows initialization of NSDate by passing in a string with the format:
    // "yyy-MM-dd"
    convenience init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}