//
//  DatabaseRecipe.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/30/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

/**
    Data model that encapsulates the JSON data returned from USDA
    database after querying for a food item using a search term.

    Note that this does not contain nutrition info, only the ndbno
    used to query for nutrition info.
**/
import Foundation
import Alamofire
import SwiftyJSON

class DatabaseRecipe {
    
    private struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SearchText = "q"
        static let SortType = "sort"
        static let MaxResultCount = "max"
        static let ResultOffset = "offset"
        static let ResponseFormat = "format"
        
        static let NDBNumber = "ndbno"
        static let ReportType = "type"
    }
    
    private struct ParameterValues {
        static let Relevance = "r"
        static let Name = "n"
        static let JSON = "JSON"
        static let XML = "XML"
        
        static let ReportBasic = "b"
        static let ReportFull = "f"
        static let ReportStats = "s"
    }
    
    private struct ReportNutrients {
        static let Calories = "Energy"
        static let TotalFat = "Total lipid (fat)"
        static let SaturatedFat = "Fatty acids, total saturated"
        static let Cholesterol = "Cholesterol"
        static let Sodium = "Sodium, Na"
        static let TotalCarbs = "Carbohydrate, by difference"
        static let Fiber = "Fiber, total dietary"
        static let Protein = "Protein"
    }
    
    var group: String
    var name: String
    var ndbno: String
    
    init(group: String, name: String, ndbno: String) {
        self.group = group
        self.name = name
        self.ndbno = ndbno
    }
    
    
    // MARK: - Useful class helper functions
    
    
    /**
    Asynchronously query the third party food database, create a list of DatabaseRecipe objects from the query
    result, and call the success block by passing in those DatabaseRecipe objects.
     
    Also requires a failure block that gets called by passing in an error message.
    **/
    class func findDatabaseRecipesWithSearchText(searchText: String,
        withSuccesBlock successBlock: ([DatabaseRecipe]) -> Void,
        withFailureBlock failureBlock: (String) -> Void) {
        let parameters: [String : String] = [
            ParameterKeys.ApiKey : Constants.FoodDatabase.ApiKey,
            ParameterKeys.SearchText : searchText,
            ParameterKeys.SortType : ParameterValues.Relevance,
            ParameterKeys.MaxResultCount : "50",
            ParameterKeys.ResultOffset : "0",
            ParameterKeys.ResponseFormat : ParameterValues.JSON,
        ]
        
        Alamofire.request(.GET, Constants.FoodDatabase.SearchBaseUrl, parameters: parameters)
            .responseJSON { (response: Response<AnyObject, NSError>) -> Void in
                guard response.result.error == nil else {
                    // Error in making the request
                    print("Error searching food database for \(searchText)")
                    print(response.result.error!)
                    failureBlock("\(response.result.error!)")
                    return
                }
                
                if let responseValue = response.result.value {
                    let responseJSON = JSON(responseValue)
                    
                    if let dbRecipesJSON = responseJSON["list"]["item"].array {
                        // Create an array of DatabaseRecipes corresponding to the result of this query
                        var dbRecipes = [DatabaseRecipe]()
                        
                        for dbRecipeJSON in dbRecipesJSON {
                            guard DatabaseRecipe.isValidJSON(dbRecipeJSON) else {
                                print("This item: \(dbRecipeJSON) does not have valid fields. Skipping.")
                                continue
                            }
                            
                            let newDbRecipe = DatabaseRecipe(group: dbRecipeJSON["group"].stringValue,
                                name: dbRecipeJSON["name"].stringValue, ndbno: dbRecipeJSON["ndbno"].stringValue)
                            dbRecipes.append(newDbRecipe)
                            
                            // Make sure DatabaseRecipes were actually created. Otherwise, no results were returned.
                            if dbRecipes.isEmpty {
                                failureBlock("No matching results for \(searchText)")
                            } else {
                                successBlock(dbRecipes)
                            }
                        }
                    } else {
                        print("DB items with search text \(searchText) not found.")
                        failureBlock("No matching results for \(searchText)")
                    }
                } else {
                    print("Error getting the result.value after searching for db recipe \(searchText)")
                    failureBlock("Error completing the request")
                }

        }

    }
    
    class func isValidJSON(recipeJSON: JSON) -> Bool {
        return recipeJSON["group"].isExists() && recipeJSON["name"].isExists()
            && recipeJSON["ndbno"].isExists()
    }
    
    class func extractNutrients(dbNutrientsJSONArray: [JSON]) -> [String : [ String : NSObject]] {
        var topLevelDict = [String : [ String : NSObject]]()
        var nutrientsDict = [String : NSObject]()
        
        // Create the inner nutrients dictionary
        for dbNutrientJSON in dbNutrientsJSONArray {
            if let nutrientName = dbNutrientJSON["name"].string {
                switch nutrientName {
                // TODO: implement
                default:
                    break
                }
            }
        }
        
        return topLevelDict
    }
    
    
    
    // MARK: - Useful instance helper functions
    
    /**
        Creates a Recipe from this DatabaseRecipe. Asynchronous so needs a success and failure block.
    
    **/
    func createRecipeWithSuccessBlock(successBlock: (Recipe) -> Void,
        withFailureBlock failureBlock: (String) -> Void) {
        let parameters: [String : String] = [
            ParameterKeys.ApiKey : Constants.FoodDatabase.ApiKey,
            ParameterKeys.NDBNumber : self.ndbno,
            ParameterKeys.ReportType : ParameterValues.ReportStats,
            ParameterKeys.ResponseFormat : ParameterValues.JSON,
        ]
        
        Alamofire.request(.GET, Constants.FoodDatabase.ReportsBaseUrl, parameters: parameters)
            .responseJSON { (response: Response<AnyObject, NSError>) -> Void in
                guard response.result.error == nil else {
                    // Error in making the request
                    print("Error getting report for db recipe: \(self.name)")
                    print(response.result.error!)
                    failureBlock("\(response.result.error!)")
                    return
                }
                
                if let responseValue = response.result.value {
                    let reportJSON = JSON(responseValue)
                    
                    if let dbNutrientsJSON = reportJSON["report"]["food"]["nutrients"].array {
                        // Create a new Recipe object and add all fields, including nutrients dictionary
                        let newRecipe = Recipe()
                        newRecipe.name = self.name
                        newRecipe.createdBy = CustomUser.currentUser()!
                        newRecipe.category = self.group
                        newRecipe.nutrients = DatabaseRecipe.extractNutrients(dbNutrientsJSON)
                        
                        successBlock(newRecipe)
                        
                    } else {
                        print("Db recipe \(self.name) report not found")
                        failureBlock("Nutrition data not available for \(self.name)")
                    }
                } else {
                    print("Error getting the result.value after getting report for db recipe \(self.name)")
                    failureBlock("Error completing the request")
                }
        }
    }
    
}