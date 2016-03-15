//
//  FractionUtil.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/20/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Foundation

class FractionUtil {
    
    /**
     Returns a tuple with the closest compound fraction possible with Unicode's built-in "vulgar fractions".
     See here: http://www.unicode.org/charts/PDF/U2150.pdf
     :param: number The floating point number to convert.
     :returns: A tuple (String, Double): the string representation of the closest possible vulgar fraction and the value of that string
     */
    func vulgarFraction(number: Double) -> (String, Double) {
        let fractions: [(String, Double)] = [("", 1), ("\u{215E}", 7/8),
            ("\u{215A}", 5/6), ("\u{2158}", 4/5), ("\u{00BE}", 3/4), ("\u{2154}", 2/3),
            ("\u{215D}", 5/8), ("\u{2157}", 3/5), ("\u{00BD}", 1/2), ("\u{2156}", 2/5),
            ("\u{215C}", 3/8), ("\u{2153}", 1/3), ("\u{00BC}", 1/4), ("\u{2155}", 1/5),
            ("\u{2159}", 1/6), ("\u{2150}", 1/7), ("\u{215B}", 1/8), ("\u{2151}", 1/9),
            ("\u{2152}", 1/10), ("", 0)]
        let whole = Int(number)
        let sign = whole < 0 ? -1 : 1
        let fraction = number - Double(whole)
        
        for i in 1..<fractions.count {
            if abs(fraction) > (fractions[i].1 + fractions[i - 1].1) / 2 {
                if fractions[i - 1].1 == 1.0 {
                    return ("\(whole + sign)", Double(whole + sign))
                } else {
                    if whole == 0 {
                        return ("\(fractions[i - 1].0)", Double(whole) + Double(sign) * fractions[i - 1].1)
                    } else {
                        return ("\(whole) \(fractions[i - 1].0)", Double(whole) + Double(sign) * fractions[i - 1].1)
                    }
                }
            }
        }
        return ("\(whole)", Double(whole))
    }
    
    /* 
        Given a Float value, returns a tuple that contains the whole number portion as an Int and the
        decimal portion as a unicode fraction String.
    
        Examples:
            -34.125 returns (-34, "1/8")
            3.999 returns (4, "0")
    */
    func splitFloatIntoWholeAndFraction(number: Float) -> (Int, String) {
        let wholePortion = Int(number)
        let sign = wholePortion < 0 ? -1 : 1
        let decimalPortion = number - Float(wholePortion)
        let vulgarFrac = vulgarFraction(Double(decimalPortion))
        
        // Deal with case where decimal portion rounds to 1
        if vulgarFrac.0 == "1" {
            return (sign + wholePortion, "0")
        }
        return (wholePortion, vulgarFrac.0)
    }
}