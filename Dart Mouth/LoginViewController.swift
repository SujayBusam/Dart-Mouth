//
//  LoginViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/4/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    struct Identifiers {
        static let PostLoginSegue = "startAfterLogin"
    }
    
    var alertView = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
    var alertAction = UIAlertAction(title: Constants.Validation.OkActionTitle, style: .Default, handler: nil)
    
    
    // MARK: - Text field outlets
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button actions
    @IBAction func backToSignupPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
