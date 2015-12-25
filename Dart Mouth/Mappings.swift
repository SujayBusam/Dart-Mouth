//
//  Mappings.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/24/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

struct Mappings {
    
    // Maps Venue enum to display and Parse field strings
    // For the values, the Parse string should always be first,
    // and the display string second.
    static let StringsForVenue: [Venue : [String]] = [
        Venue.Foco: [
            Constants.VenueStrings.FocoParse,
            Constants.VenueStrings.FocoDisplay
        ],
        
        Venue.Hop: [
            Constants.VenueStrings.HopParse,
            Constants.VenueStrings.HopDisplay
        ],
        
        Venue.Novack: [
            Constants.VenueStrings.NovackParse,
            Constants.VenueStrings.NovackDisplay
        ]
    ]
    
    // Maps MealTime enum to display and Parse field strings
    // For the values, the Parse string should always be first,
    // and the display string second.
    static let StringsForMealTime: [MealTime : [String]] = [
        MealTime.Breakfast: [
            Constants.MealTimeStrings.BreakfastParse,
            Constants.MealTimeStrings.BreakfastDisplay
        ],
        
        MealTime.Lunch: [
            Constants.MealTimeStrings.LunchParse,
            Constants.MealTimeStrings.LunchDisplay
        ],
        
        MealTime.Dinner: [
            Constants.MealTimeStrings.DinnerParse,
            Constants.MealTimeStrings.DinnerDisplay
        ],
        
        MealTime.LateNight: [
            Constants.MealTimeStrings.LateNightParse,
            Constants.MealTimeStrings.LateNightDisplay
        ],
        
        MealTime.AllDay: [
            Constants.MealTimeStrings.AllDayParse,
            Constants.MealTimeStrings.AllDayDisplay
        ],
    ]
    
    // Maps Menu enum to display and Parse field strings
    // For the values, the Parse string should always be first,
    // and the display string second.
    static let StringsForMenu: [Menu : [String]] = [
        Menu.Specials: [
            Constants.MenuStrings.SpecialsParse,
            Constants.MenuStrings.SpecialsDisplay
        ],
        
        Menu.EverydayItems: [
            Constants.MenuStrings.EverydayItemsParse,
            Constants.MenuStrings.EverydayItemsDisplay
        ],
        
        Menu.Beverage: [
            Constants.MenuStrings.BeverageParse,
            Constants.MenuStrings.BeverageDisplay
        ],
        
        Menu.Cereal: [
            Constants.MenuStrings.CerealParse,
            Constants.MenuStrings.CerealDisplay
        ],
        
        Menu.Condiments: [
            Constants.MenuStrings.CondimentsParse,
            Constants.MenuStrings.CondimentsDisplay
        ],
        
        Menu.GlutenFree: [
            Constants.MenuStrings.GlutenFreeParse,
            Constants.MenuStrings.GlutenFreeDisplay
        ],
        
        Menu.Deli: [
            Constants.MenuStrings.DeliParse,
            Constants.MenuStrings.DeliDisplay
        ],
        
        Menu.Grill: [
            Constants.MenuStrings.GrillParse,
            Constants.MenuStrings.GrillDisplay
        ],
        
        Menu.GrabGo: [
            Constants.MenuStrings.GrabGoParse,
            Constants.MenuStrings.GrabGoDisplay
        ],
        
        Menu.Snacks: [
            Constants.MenuStrings.SnacksParse,
            Constants.MenuStrings.SnacksDisplay
        ],
    ]
    
    
    
    // Maps Venue enum to MealTime enums
    static let MealTimesForVenue: [Venue : [MealTime]] = [
        Venue.Foco: [
            MealTime.Breakfast,
            MealTime.Lunch,
            MealTime.Dinner,
        ],
        
        Venue.Hop: [
            MealTime.Breakfast,
            MealTime.Lunch,
            MealTime.Dinner,
            MealTime.LateNight,
        ],
        
        Venue.Novack: [
            MealTime.AllDay
        ],
    ]
    
    // Maps Venue enum to Menu enums
    static let MenusForVenue: [Venue: [Menu]] = [
        Venue.Foco: [
            Menu.Specials,
            Menu.EverydayItems,
            Menu.GlutenFree,
            Menu.Beverage,
            Menu.Condiments,
        ],
        
        Venue.Hop: [
            Menu.Specials,
            Menu.EverydayItems,
            Menu.Deli,
            Menu.Grill,
            Menu.GrabGo,
            Menu.Snacks,
            Menu.Beverage,
            Menu.Cereal,
            Menu.Condiments,
        ],
        
        Venue.Novack: [
            Menu.Specials,
            Menu.EverydayItems,
        ]
    ]
}