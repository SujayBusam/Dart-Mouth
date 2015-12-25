//
//  Mappings.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/24/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

struct Mappings {
    
    // Maps Venue enum to MealTime enums
    static let MealTimesForVenue: [Venue : [MealTime]] = [
        Venue.Foco: [
            MealTime.Breakfast,
            MealTime.Lunch,
            MealTime.Dinner,
            MealTime.LateNight,
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