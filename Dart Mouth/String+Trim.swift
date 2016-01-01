//
//  String+Trim.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/1/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import Foundation

extension String {
    
    // Returns a new String made by removing whitespace and newline
    // from both ends of itself.
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}