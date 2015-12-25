//
//  MealEnums.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/25/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

enum Venue: ParseFieldCompatible {
    case Foco
    case Hop
    case Novack
    
    var parseField: String {
        switch self {
        case .Foco:
            return Constants.VenueStrings.FocoParse
        case .Hop:
            return Constants.VenueStrings.HopParse
        case .Novack:
            return Constants.VenueStrings.NovackParse
        }
    }
    
    var displayString: String {
        switch self {
        case .Foco:
            return Constants.VenueStrings.FocoDisplay
        case .Hop:
            return Constants.VenueStrings.HopDisplay
        case .Novack:
            return Constants.VenueStrings.NovackDisplay
        }
    }
    
    
}


enum MealTime: ParseFieldCompatible {
    case Breakfast
    case Lunch
    case Dinner
    case LateNight
    case AllDay
    
    var parseField: String {
        switch self {
        case .Breakfast:
            return Constants.MealTimeStrings.BreakfastParse
        case .Lunch:
            return Constants.MealTimeStrings.LunchParse
        case .Dinner:
            return Constants.MealTimeStrings.DinnerParse
        case .LateNight:
            return Constants.MealTimeStrings.LateNightParse
        case .AllDay:
            return Constants.MealTimeStrings.AllDayParse
        }
    }
    
    var displayString: String {
        switch self {
        case .Breakfast:
            return Constants.MealTimeStrings.BreakfastDisplay
        case .Lunch:
            return Constants.MealTimeStrings.LunchDisplay
        case .Dinner:
            return Constants.MealTimeStrings.DinnerDisplay
        case .LateNight:
            return Constants.MealTimeStrings.LateNightDisplay
        case .AllDay:
            return Constants.MealTimeStrings.AllDayDisplay
        }
    }
}


enum Menu: ParseFieldCompatible {
    case Specials
    case EverydayItems
    case Beverage
    case Cereal
    case Condiments
    case GlutenFree
    case Deli
    case Grill
    case GrabGo
    case Snacks
    
    var parseField: String {
        switch self {
        case .Specials:
            return Constants.MenuStrings.SpecialsParse
        case .EverydayItems:
            return Constants.MenuStrings.EverydayItemsParse
        case .Beverage:
            return Constants.MenuStrings.BeverageParse
        case .Cereal:
            return Constants.MenuStrings.CerealParse
        case .Condiments:
            return Constants.MenuStrings.CondimentsParse
        case .GlutenFree:
            return Constants.MenuStrings.GlutenFreeParse
        case .Deli:
            return Constants.MenuStrings.DeliParse
        case .Grill:
            return Constants.MenuStrings.GrillParse
        case .GrabGo:
            return Constants.MenuStrings.GrabGoParse
        case .Snacks:
            return Constants.MenuStrings.SnacksParse
        }
    }
    
    var displayString: String {
        switch self {
        case .Specials:
            return Constants.MenuStrings.SpecialsDisplay
        case .EverydayItems:
            return Constants.MenuStrings.EverydayItemsDisplay
        case .Beverage:
            return Constants.MenuStrings.BeverageDisplay
        case .Cereal:
            return Constants.MenuStrings.CerealDisplay
        case .Condiments:
            return Constants.MenuStrings.CondimentsDisplay
        case .GlutenFree:
            return Constants.MenuStrings.GlutenFreeDisplay
        case .Deli:
            return Constants.MenuStrings.DeliDisplay
        case .Grill:
            return Constants.MenuStrings.GrillDisplay
        case .GrabGo:
            return Constants.MenuStrings.GrabGoDisplay
        case .Snacks:
            return Constants.MenuStrings.SnacksDisplay
        }
    }
}