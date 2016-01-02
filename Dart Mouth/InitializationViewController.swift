//
//  InitializationViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 11/11/15.
//  Copyright © 2015 Sujay's Dev Center. All rights reserved.
//

import UIKit

class InitializationViewController: UIViewController {
    
    struct Identifiers {
        static let StartSegue = "startAfterInitialization"
        static let SignupSegue = "showSignupFromInitialization"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = CustomUser.currentUser()
        if currentUser != nil {
            performSegueWithIdentifier(Identifiers.StartSegue, sender: self)
        } else {
            performSegueWithIdentifier(Identifiers.SignupSegue, sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    

}
