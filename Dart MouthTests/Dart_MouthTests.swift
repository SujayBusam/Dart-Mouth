//
//  Dart_MouthTests.swift
//  Dart MouthTests
//
//  Created by Sujay Busam on 10/24/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import XCTest
@testable import Dart_Mouth

class Dart_MouthTests: XCTestCase {
    
    struct Constants {
        static let VulgarFractions: [String : String] = [
            "0" : "0",
            "1/8" : "\u{215B}",
            "1/4" : "\u{00BC}",
            "1/3" : "\u{2153}",
            "1/2" : "\u{00BD}",
            "2/3" : "\u{2154}",
            "3/4" : "\u{00BE}",
        ]
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testVulgarFraction() {
        let fracUtil = FractionUtil()
        
        // Test the basic fractions
        
        XCTAssertEqual(fracUtil.vulgarFraction(1/8).0, Constants.VulgarFractions["1/8"]!)
        XCTAssertEqual(fracUtil.vulgarFraction(1/4).0, Constants.VulgarFractions["1/4"]!)
        XCTAssertEqual(fracUtil.vulgarFraction(1/3).0, Constants.VulgarFractions["1/3"]!)
        XCTAssertEqual(fracUtil.vulgarFraction(1/2).0, Constants.VulgarFractions["1/2"]!)
        XCTAssertEqual(fracUtil.vulgarFraction(2/3).0, Constants.VulgarFractions["2/3"]!)
        XCTAssertEqual(fracUtil.vulgarFraction(3/4).0, Constants.VulgarFractions["3/4"]!)
        
        // Test some compound fractions
        
        // Split 0.99 to 1 and "0"
        let compound1: Float = 0.99
        let compound1Result = fracUtil.splitFloatIntoWholeAndFraction(compound1)
        XCTAssertEqual(compound1Result.0, 1)
        XCTAssertEqual(compound1Result.1, Constants.VulgarFractions["0"]!)
        
        // Split -2.124 into -2 and "1/8"
        let compound2: Float = -2.124
        let compound2Result = fracUtil.splitFloatIntoWholeAndFraction(compound2)
        XCTAssertEqual(compound2Result.0, -2)
        XCTAssertEqual(compound2Result.1, Constants.VulgarFractions["1/8"]!)
        
        // Split 5.499 into 5 and "1/2"
        let compound3: Float = 5.499
        let compound3Result = fracUtil.splitFloatIntoWholeAndFraction(compound3)
        XCTAssertEqual(compound3Result.0, 5)
        XCTAssertEqual(compound3Result.1, Constants.VulgarFractions["1/2"]!)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
        
    }
    
}
