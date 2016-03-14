//
//  Dart_MouthUITests.swift
//  Dart MouthUITests
//
//  Created by Thomas Kidder on 3/10/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import XCTest

class Dart_MouthUITests: XCTestCase {
    
    private struct TestConfigurations{
        static let Username = "test@gmail.com"
        static let Password = "password"
    }
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launch()
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText(TestConfigurations.Username)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(TestConfigurations.Password)
        loginButton.tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        let app = XCUIApplication()
        app.tabBars.buttons["Preferences"].tap()
        app.buttons["Log Out"].tap()
        
        
        
    }
    
    func testDiaryAddRemove() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Menus"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Hop"].tap()
        collectionViewsQuery.staticTexts["Lunch"].tap()
        collectionViewsQuery.staticTexts["Deli"].tap()
        
        let menusNavigationBar = app.navigationBars["Menus"]
        menusNavigationBar.buttons["Search"].tap()
        menusNavigationBar.searchFields.element.typeText("Chicken")
        
        let chickenTacoSaladStaticText = app.tables.staticTexts["Chicken Taco Salad  "]
        chickenTacoSaladStaticText.tap()
        
        let toolbarsQuery = app.toolbars
        toolbarsQuery.buttons["Add to Diary"].tap()
        app.buttons["Lunch"].tap()
        XCUIApplication().navigationBars["Menus"].buttons["Cancel"].tap()
        
        //navigate to diary, verify and delete item
        tabBarsQuery.buttons["Diary"].tap()
        chickenTacoSaladStaticText.tap()
        toolbarsQuery.buttons["TrashGreen"].tap()
        app.sheets.collectionViews.buttons["Remove Food"].tap()
    }
    
    func testCalenderNavigation(){
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Menus"].tap()
        
        //shift menu date
        let leftarrowwhiteButtonMenus = app.navigationBars["Menus"].buttons["LeftArrowWhite"]
        leftarrowwhiteButtonMenus.tap()
        leftarrowwhiteButtonMenus.tap()
        leftarrowwhiteButtonMenus.tap()
        
        //add food item to lunch
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Hop"].tap()
        collectionViewsQuery.staticTexts["Lunch"].tap()
        collectionViewsQuery.staticTexts["Deli"].tap()
        
        let menusNavigationBar = app.navigationBars["Menus"]
        menusNavigationBar.buttons["Search"].tap()
        menusNavigationBar.searchFields.element.typeText("Chicken")
        
        let chickenTacoSaladStaticText = app.tables.staticTexts["Chicken Taco Salad  "]
        chickenTacoSaladStaticText.tap()
        
        let toolbarsQuery = app.toolbars
        toolbarsQuery.buttons["Add to Diary"].tap()
        app.buttons["Lunch"].tap()
        XCUIApplication().navigationBars["Menus"].buttons["Cancel"].tap()


        //shift to same date in diary
        tabBarsQuery.buttons["Diary"].tap()
        let leftarrowwhiteButtonDiary = XCUIApplication().navigationBars["Diary"].buttons["LeftArrowWhite"]
        leftarrowwhiteButtonDiary.tap()
        leftarrowwhiteButtonDiary.tap()
        leftarrowwhiteButtonDiary.tap()

        
        //verify/delete food
        chickenTacoSaladStaticText.tap()
        toolbarsQuery.buttons["TrashGreen"].tap()
        app.sheets.collectionViews.buttons["Remove Food"].tap()
        
        //reset diary date
        let rightarrowwhiteButtonDiary = XCUIApplication().navigationBars["Diary"].buttons["RightArrowWhite"]
        rightarrowwhiteButtonDiary.tap()
        rightarrowwhiteButtonDiary.tap()
        rightarrowwhiteButtonDiary.tap()
        
        //reset menu date
        tabBarsQuery.buttons["Menus"].tap()
        let rightarrowwhiteButtonMenu = XCUIApplication().navigationBars["Menus"].buttons["RightArrowWhite"]
        rightarrowwhiteButtonMenu.tap()
        rightarrowwhiteButtonMenu.tap()
        rightarrowwhiteButtonMenu.tap()
    }
    
    func testEditServingSize(){
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Menus"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Hop"].tap()
        collectionViewsQuery.staticTexts["Lunch"].tap()
        collectionViewsQuery.staticTexts["Deli"].tap()
        
        let menusNavigationBar = app.navigationBars["Menus"]
        menusNavigationBar.buttons["Search"].tap()
        menusNavigationBar.searchFields.element.typeText("Chicken")
        
        let chickenTacoSaladStaticText = app.tables.staticTexts["Chicken Taco Salad  "]
        chickenTacoSaladStaticText.tap()
        
        let toolbarsQuery = app.toolbars
        toolbarsQuery.buttons["Add to Diary"].tap()
        app.buttons["Lunch"].tap()
        XCUIApplication().navigationBars["Menus"].buttons["Cancel"].tap()
        
        //navigate to diary, verify and delete item
        tabBarsQuery.buttons["Diary"].tap()
        chickenTacoSaladStaticText.tap()
        
        app.pickers.elementAtIndex(0).swipeUp()
        app.pickers.elementAtIndex(0).swipeUp()
        app.navigationBars["Edit Food"].buttons["Save"].tap()
        
        chickenTacoSaladStaticText.tap()
        toolbarsQuery.buttons["TrashGreen"].tap()
        app.sheets.collectionViews.buttons["Remove Food"].tap()

    }
    
    func testSearchUSDADatabase(){
        
    }
    
    
}
