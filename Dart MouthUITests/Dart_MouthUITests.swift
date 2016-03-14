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
        
        //beginning of each test starts with logging in
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
        
        //end of each test logs out (this requires the test to end in the tab bar scene)
        let app = XCUIApplication()
        app.tabBars.buttons["Preferences"].tap()
        app.buttons["Log Out"].tap()
    }
    
    func testDiaryAddRemove() {
        //navigate to menu
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Menus"].tap()
        
        //select food items from the hop deli at lunch time
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Hop"].tap()
        collectionViewsQuery.staticTexts["Lunch"].tap()
        collectionViewsQuery.staticTexts["Deli"].tap()
        
        //search for chicken
        let menusNavigationBar = app.navigationBars["Menus"]
        menusNavigationBar.buttons["Search"].tap()
        menusNavigationBar.searchFields.element.typeText("Chicken")
        
        //select the taco salad
        let chickenTacoSaladStaticText = app.tables.staticTexts["Chicken Taco Salad  "]
        chickenTacoSaladStaticText.tap()
        
        //add to today's lunch
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
        
        //shift menu date 3 days ago
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
        //navigate to menu
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Menus"].tap()
        
        //navigate to hop deli at lunch
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Hop"].tap()
        collectionViewsQuery.staticTexts["Lunch"].tap()
        collectionViewsQuery.staticTexts["Deli"].tap()
        
        //search for chicken
        let menusNavigationBar = app.navigationBars["Menus"]
        menusNavigationBar.buttons["Search"].tap()
        menusNavigationBar.searchFields.element.typeText("Chicken")
        
        let chickenTacoSaladStaticText = app.tables.staticTexts["Chicken Taco Salad  "]
        chickenTacoSaladStaticText.tap()
        
        //add to diary
        let toolbarsQuery = app.toolbars
        toolbarsQuery.buttons["Add to Diary"].tap()
        app.buttons["Lunch"].tap()
        XCUIApplication().navigationBars["Menus"].buttons["Cancel"].tap()
        
        //navigate to diary and find food item
        tabBarsQuery.buttons["Diary"].tap()
        chickenTacoSaladStaticText.tap()
        
        //attempt to change serving size and save
        app.pickers.elementAtIndex(0).swipeUp()
        app.navigationBars["Edit Food"].buttons["Save"].tap()
        
        //select and delete food item
        chickenTacoSaladStaticText.tap()
        toolbarsQuery.buttons["TrashGreen"].tap()
        app.sheets.collectionViews.buttons["Remove Food"].tap()

    }
    
    func testSearchUSDADatabase(){
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Diary"].tap()

        //add food item via diary
        let tablesQuery = app.tables
        tablesQuery.otherElements.containingType(.StaticText, identifier:"Breakfast:").buttons["PlusGray"].tap()
        app.buttons["Database"].tap()
        
        //search USDA database for pizza
        let addFoodNavigationBar = app.navigationBars["Add Food"]
        addFoodNavigationBar.searchFields.element.typeText("Pizza")
        app.buttons["Search"].tap()
        
        //select pizza and add to diary
        let pizzaHut12CheesePizzaPanCrustStaticText = tablesQuery.staticTexts["PIZZA HUT 12\" Cheese Pizza, Pan Crust"]
        pizzaHut12CheesePizzaPanCrustStaticText.tap()
        addFoodNavigationBar.buttons["Add"].tap()
        addFoodNavigationBar.buttons["Cancel"].tap()
        addFoodNavigationBar.buttons["Back"].tap()
        
        //verify and delete item
        pizzaHut12CheesePizzaPanCrustStaticText.tap()
        app.toolbars.buttons["TrashGreen"].tap()
        app.sheets.collectionViews.buttons["Remove Food"].tap()
    }
}
