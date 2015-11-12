//
//  InitializationViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/11/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class InitializationViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadTodaysRecipes()
    }
    
    /*
        If there are no Recipes for today, fetch and save them. Then segue to main UITabViewController.
        It is done this way so that we can display some kind of loading screen while this Recipe data loads.
    */
    private func loadTodaysRecipes() {
        let api = DartFoodAPI()
        let realm = try! Realm()
        let predicate = DateUtil.getTodaysDatePredicate()
        
        // Activity indicator start
        activityIndicator.startAnimating()
        
        if realm.objects(LastFetch).filter(predicate).isEmpty {
            // Today's Recipes are not already loaded, so load them.
            let todaysDate = DateUtil.getTodaysDate()
            api.getRecipesForDate(day: todaysDate.day, month: todaysDate.month, year: todaysDate.year, successHandler: completionHandler)
        } else {
            self.performSegueWithIdentifier("Start After Initializing", sender: self)
        }
    }
    
    private func completionHandler(json: JSON) {
        Recipe.saveRecipes(json)
        // Create a LastFetch so that today is marked as being fetched and doesn't repeat.
        LastFetch.createLastFetchForToday()
        activityIndicator.stopAnimating()
        self.performSegueWithIdentifier("Start After Initializing", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
