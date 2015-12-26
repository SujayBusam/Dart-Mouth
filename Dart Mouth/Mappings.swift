//
//  Mappings.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/24/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

struct Mappings {
    
    struct StringTypes {
        static let Parse = "parse"
        static let Display = "display"
    }
    
    // Maps Venue enum to Parse field and display strings.
    static let StringsForVenue: [Venue : [String : String]] = [
        Venue.Foco: [
            StringTypes.Parse : Constants.VenueStrings.FocoParse,
            StringTypes.Display : Constants.VenueStrings.FocoDisplay,
        ],
        
        Venue.Hop: [
            StringTypes.Parse : Constants.VenueStrings.HopParse,
            StringTypes.Display : Constants.VenueStrings.HopDisplay,
        ],
        
        Venue.Novack: [
            StringTypes.Parse : Constants.VenueStrings.NovackParse,
            StringTypes.Display : Constants.VenueStrings.NovackDisplay,
        ]
    ]
    
    // Maps MealTime enum to Parse field and display strings.
    static let StringsForMealTime: [MealTime : [String : String]] = [
        MealTime.Breakfast: [
            StringTypes.Parse : Constants.MealTimeStrings.BreakfastParse,
            StringTypes.Display : Constants.MealTimeStrings.BreakfastDisplay,
        ],
        
        MealTime.Lunch: [
            StringTypes.Parse : Constants.MealTimeStrings.LunchParse,
            StringTypes.Display : Constants.MealTimeStrings.LunchDisplay,
        ],
        
        MealTime.Dinner: [
            StringTypes.Parse : Constants.MealTimeStrings.DinnerParse,
            StringTypes.Display : Constants.MealTimeStrings.DinnerDisplay,
        ],
        
        MealTime.LateNight: [
            StringTypes.Parse : Constants.MealTimeStrings.LateNightParse,
            StringTypes.Display : Constants.MealTimeStrings.LateNightDisplay,
        ],
        
        MealTime.AllDay: [
            StringTypes.Parse : Constants.MealTimeStrings.AllDayParse,
            StringTypes.Display : Constants.MealTimeStrings.AllDayDisplay,
        ],
    ]
    
    // Maps Menu enum to Parse field and display strings.
    static let StringsForMenu: [Menu : [String : String]] = [
        Menu.Specials: [
            StringTypes.Parse : Constants.MenuStrings.SpecialsParse,
            StringTypes.Display : Constants.MenuStrings.SpecialsDisplay,
        ],
        
        Menu.EverydayItems: [
            StringTypes.Parse : Constants.MenuStrings.EverydayItemsParse,
            StringTypes.Display : Constants.MenuStrings.EverydayItemsDisplay,
        ],
        
        Menu.Beverage: [
            StringTypes.Parse : Constants.MenuStrings.BeverageParse,
            StringTypes.Display : Constants.MenuStrings.BeverageDisplay,
        ],
        
        Menu.Cereal: [
            StringTypes.Parse : Constants.MenuStrings.CerealParse,
            StringTypes.Display : Constants.MenuStrings.CerealDisplay,
        ],
        
        Menu.Condiments: [
            StringTypes.Parse : Constants.MenuStrings.CondimentsParse,
            StringTypes.Display : Constants.MenuStrings.CondimentsDisplay,
        ],
        
        Menu.GlutenFree: [
            StringTypes.Parse : Constants.MenuStrings.GlutenFreeParse,
            StringTypes.Display : Constants.MenuStrings.GlutenFreeDisplay,
        ],
        
        Menu.Deli: [
            StringTypes.Parse : Constants.MenuStrings.DeliParse,
            StringTypes.Display : Constants.MenuStrings.DeliDisplay,
        ],
        
        Menu.Grill: [
            StringTypes.Parse : Constants.MenuStrings.GrillParse,
            StringTypes.Display : Constants.MenuStrings.GrillDisplay,
        ],
        
        Menu.GrabGo: [
            StringTypes.Parse : Constants.MenuStrings.GrabGoParse,
            StringTypes.Display : Constants.MenuStrings.GrabGoDisplay,
        ],
        
        Menu.Snacks: [
            StringTypes.Parse : Constants.MenuStrings.SnacksParse,
            StringTypes.Display : Constants.MenuStrings.SnacksDisplay,
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