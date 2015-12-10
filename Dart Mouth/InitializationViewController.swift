//
//  InitializationViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/11/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import RealmSwift
import Parse
import SwiftyJSON

class InitializationViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        testQuery2()
        self.performSegueWithIdentifier("Start After Initialization", sender: self)
    }
    
    // Testing Parse
    private func testQuery() {
        let query = PFQuery(className: "Offering", predicate: NSPredicate(format: "month = %d AND day = %d", 11, 30))
        query.limit = 1000
        query.getFirstObjectInBackgroundWithBlock {
            (offering: PFObject?, error: NSError?) -> Void in
            print("Offering: \(offering)")
            
            let relation = offering!.relationForKey("recipes")
            let relationQuery = relation.query()
            relationQuery.limit = 1000
            relationQuery.findObjectsInBackgroundWithBlock {
                (recipes: [PFObject]?, error: NSError?) -> Void in
                
                print("Recipes: \(recipes)")
            }
        }
    }
    
    // Testing Parse
    private func testQuery2() {
        let offeringQuery = PFQuery(className: "Offering")
        let todaysDate = DateUtil.getTodaysDate()
        
        offeringQuery.whereKey("month", equalTo: 11)
        offeringQuery.whereKey("day", equalTo: 24)
        offeringQuery.whereKey("year", equalTo: todaysDate.year)
        offeringQuery.whereKey("venueKey", equalTo: "CYC")
        offeringQuery.whereKey("mealName", equalTo: "Lunch")
        
        print("Start fetching")
        offeringQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let offerings = objects {
                    // Get all Recipes for these Offerings
                    print("Offerings count: \(offerings.count)")
                    var relationQueries = [PFQuery]()
                    for offering in offerings {
                        relationQueries.append(offering.relationForKey("recipes").query())
                    }
                    
                    let query = PFQuery.orQueryWithSubqueries(relationQueries)
                    query.limit = 1000
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            print("Recipes: \(objects!.count)")
                            print("Recipe 1: \(objects![0])")
                        } else {
                            print("Error fetching Recipes for Offerings.")
                        }
                    }
                }
            } else {
                // Error
                print("Error fetching today's Offerings.")
            }
        }
    }
    
    /*
        If there are no Recipes for today, fetch and save them. Then segue to main UITabViewController.
        It is done this way so that we can display some kind of loading screen while this Recipe data loads.
        
        TODO(Sujay): think about moving this away from app initialization. Maybe load right in the menu view controller.
    */
//    private func loadTodaysRecipes() {
//        let api = DartFoodAPI()
//        let realm = try! Realm()
//        let predicate = DateUtil.getTodaysDatePredicate()
//        
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        activityIndicator.startAnimating()
//        
//        if realm.objects(LastFetch).filter(predicate).isEmpty {
//            // Today's Recipes are not already loaded, so load them.
//            let todaysDate = DateUtil.getTodaysDate()
//            api.getRecipesForDate(day: todaysDate.day, month: todaysDate.month, year: todaysDate.year, successHandler: completionHandler)
//        } else {
//            self.performSegueWithIdentifier("Start After Initialization", sender: self)
//        }
//    }
//    
//    private func completionHandler(json: JSON) {
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//        self.activityIndicator.stopAnimating()
//        Recipe.saveRecipes(json)
//        // Create a LastFetch so that today is marked as being fetched and doesn't repeat.
//        print("Writing Last Fetch")
//        LastFetch.createLastFetchForToday()
//        
//        self.performSegueWithIdentifier("Start After Initialization", sender: self)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    

}
