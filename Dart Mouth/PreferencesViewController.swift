//
//  PreferencesViewController.swift
//  Dartmouth Nutrition
//
//  Created by Thomas Kidder on 10/14/15.
//  Copyright © 2015 Thomas Kidder. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        // TODO: error handling
        CustomUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            let destinationVC = self.storyboard!
                .instantiateViewControllerWithIdentifier(Constants.ViewControllers.Signup)
            self.navigationController!.presentViewController(destinationVC, animated: true, completion: nil)
        }
    }
    
}
