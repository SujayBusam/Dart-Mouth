//
//  AppDelegate.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 10/24/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Register all subclasses of PFObject used on frontend
        Offering.registerSubclass()
        Recipe.registerSubclass()
        CustomUser.registerSubclass()
        UserMeal.registerSubclass()
        DiaryEntry.registerSubclass()
        Subscription.registerSubclass()
        Notification.registerSubclass()
        
        // Initialize Parse.
        Parse.setApplicationId("BAihtNGpVTx4IJsuuFV5f9LibJGnD1ZBOsnXk9qp", clientKey: "TRnSXKYLvWENuPULgil1OtMbTS8BBxfkhV5kcQlz")
        
        // Status bar will have white text app-wide
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // App-wide color of Navigation Bar, items, and title text
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
        ]
        UINavigationBar.appearance().barTintColor = Constants.Colors.appPrimaryColorDark
        
        // App-wide color of tab bar
        UITabBar.appearance().tintColor = Constants.Colors.appPrimaryColorDark
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

