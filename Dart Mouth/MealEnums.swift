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
        return Mappings.StringsForVenue[self]!.first!
    }
    
    var displayString: String {
        return Mappings.StringsForVenue[self]!.last!
    }
    
    
}


enum MealTime: ParseFieldCompatible {
    case Breakfast
    case Lunch
    case Dinner
    case LateNight
    case AllDay
    
    var parseField: String {
        return Mappings.StringsForMealTime[self]!.first!
    }
    
    var displayString: String {
        return Mappings.StringsForMealTime[self]!.last!
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
        return Mappings.StringsForMenu[self]!.first!
    }
    
    var displayString: String {
        return Mappings.StringsForMenu[self]!.last!
    }
}