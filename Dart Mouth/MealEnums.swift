//
//  MealEnums.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 12/25/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import Foundation

let parse = Mappings.StringTypes.Parse
let display = Mappings.StringTypes.Display

enum Venue: ParseFieldCompatible {
    case Foco
    case Hop
    case Novack
    
    var parseField: String {
        return Mappings.StringsForVenue[self]![parse]!
    }
    
    var displayString: String {
        return Mappings.StringsForVenue[self]![display]!
    }
    
    var mealTimes: [MealTime] {
        return Mappings.MealTimesForVenue[self]!
    }
    
    var menus: [Menu] {
        return Mappings.MenusForVenue[self]!
    }
}


enum MealTime: ParseFieldCompatible {
    case Breakfast
    case Lunch
    case Dinner
    case LateNight
    case AllDay
    
    var parseField: String {
        return Mappings.StringsForMealTime[self]![parse]!
    }
    
    var displayString: String {
        return Mappings.StringsForMealTime[self]![display]!
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
        return Mappings.StringsForMenu[self]![parse]!
    }
    
    var displayString: String {
        return Mappings.StringsForMenu[self]![display]!
    }
}