//
//  NutrientUtil.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/11/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

class NutrientUtil {
    
    struct Constants {
        static let regex = try! NSRegularExpression(pattern: "\\d+\\.*\\d*", options: NSRegularExpressionOptions.CaseInsensitive)
    }
    
    /*
        In the Nutrients JSON, many values are strings such as "0mg", "34g", or even "less than 1g".
        This function parses out the value and discards units and extraneous characters. It returns the float value.
        If the string is empty, this returns 0
        We don't need to preserve the units, since they are known beforehand and never change TODO(Sujay): check on this! Potentially use this function to store units.
    */
    class func parseNutrientValue(value: String) -> Float {
        if value.isEmpty { return 0 }
    
        let nsString = value as NSString
        let results = Constants.regex.matchesInString(value, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, nsString.length))
        
        let numbers = results.map({ Float(nsString.substringWithRange($0.range))! })
        
        return numbers[0]
    }
}