//
//  Constants.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/24/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation
import ChameleonFramework

struct Constants {
    
    struct VenueStrings {
        static let FocoDisplay = "Foco"
        static let FocoParse = "DDS"
        
        static let HopDisplay = "Hop"
        static let HopParse = "CYC"
        
        static let NovackDisplay = "Novack"
        static let NovackParse = "NOVACK"
    }
    
    struct MealTimeStrings {
        static let BreakfastDisplay = "Breakfast"
        static let BreakfastParse = "Breakfast"
        
        static let LunchDisplay = "Lunch"
        static let LunchParse = "Lunch"
        
        static let DinnerDisplay = "Dinner"
        static let DinnerParse = "Dinner"
        
        static let LateNightDisplay = "Late Night"
        static let LateNightParse = "Late Night"
        
        static let AllDayDisplay = "All Day"
        static let AllDayParse = "Every Day"
        
        // Used just for Diary
        static let SnacksDisplay = "Snacks"
    }
    
    struct MenuStrings {
        static let AllItemsDisplay = "All Items"
        
        static let SpecialsDisplay = "Today's Specials"
        static let SpecialsParse = "Today's Specials"
        
        static let EverydayItemsDisplay = "Everyday Items"
        static let EverydayItemsParse = "Everyday Items"
        
        static let BeverageDisplay = "Beverage"
        static let BeverageParse = "Beverage"
        
        static let CerealDisplay = "Cereal"
        static let CerealParse = "Cereal"
        
        static let CondimentsDisplay = "Condiments"
        static let CondimentsParse = "Condiments"
        
        static let GlutenFreeDisplay = "Gluten Free"
        static let GlutenFreeParse = "Additional Gluten Free"
        
        static let DeliDisplay = "Deli"
        static let DeliParse = "Courtyard Deli"
        
        static let GrillDisplay = "Grill"
        static let GrillParse = "Courtyard Grill"
        
        static let GrabGoDisplay = "Grab & Go"
        static let GrabGoParse = "Grab & Go"
        
        static let SnacksDisplay = "Snacks"
        static let SnacksParse = "Courtyard Snacks"
    }
    
    struct Colors {
        static let appPrimaryColor = FlatMint()
        static let appPrimaryColorDark = FlatMintDark()
        static let appSecondaryColor = FlatNavyBlue()
        static let appSecondaryColorDark = FlatNavyBlueDark()
    }
    
    struct Validation {
        static let MinimumPasswordLength = 6
        static let MaximumPasswordLength = 25
        static let EmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        static let InvalidEmailTitle = "Invalid Email"
        static let InvalidEmailMessage = "Please sign up with a valid email."
        static let InvalidPasswordTitle = "Invalid Password"
        static let InvalidPasswordMessage = "Please enter a password between \(MinimumPasswordLength) and \(MaximumPasswordLength) characters, inclusive."
        static let NoMatchPasswordsTitle = "Passwords Don't Match"
        static let NoMatchPasswordsMessage = "Please correctly confirm your password."
        static let SignupErrorTitle = "Signup Error"
        static let SignupErrorDefaultMessage = "Unknown error signing up."
        static let SigninErrorTitle = "Signin Error"
        static let SigninErrorDefaultMessage = "Unknown error signing in."
        static let OkActionTitle = "OK"
    }
    
    struct ParseIDS {
        static let DDSUser = "95xfYTL7GG"
    }
    
    struct ViewControllers {
        static let Signup = "SignupViewController"
        static let MenuContainer = "MenuContainerViewController"
        static let MenuView = "MenuViewController"
        static let RecipeNutritionAdderContainer = "RecipeNutritonAdderContainerViewController"
        static let RecipeNutrition = "RecipeNutritionViewController"
        static let DiaryEntryEditContainer = "DiaryEntryEditContainerViewController"
        static let DiaryEntryMealPicker = "DiaryEntryMealPickerViewController"
        static let DiaryEntryAddContainer = "DiaryEntryAddContainerViewController"
        static let DiaryEntryNutritionAdderContainer = "DiaryEntryNutritionAdderContainerViewController"
        static let PreviousRecipes = "PreviousRecipesViewController"
        static let CustomRecipes = "CustomRecipesViewController"
        static let PreviousMeals = "PreviousMealsViewController"
        static let DatabaseRecipes = "DatabaseRecipesViewController"
    }
    
    struct Images {
        static let LeftArrowWhite = "LeftArrowWhite"
        static let RightArrowWhite = "RightArrowWhite"
        static let LeftArrowBlack = "LeftArrowBlack"
        static let RightArrowBlack = "RightArrowBlack"
        static let SearchIcon = "Search"
        static let TrashGreen = "TrashGreen"
    }
    
    struct FoodDatabase {
        static let ApiKey = "2eB2uYJaVyEVZuhLy6WR6s7TdXSouIKjnybrvcQe"
    }
}