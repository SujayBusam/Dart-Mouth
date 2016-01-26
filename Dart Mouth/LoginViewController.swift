//
//  LoginViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/4/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    struct Identifiers {
        static let DismissKeyboard = "dismissKeyboard"
        static let PostLoginSegue = "startAfterLogin"
    }
    
    var alertView = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
    var alertAction = UIAlertAction(title: Constants.Validation.OkActionTitle, style: .Default, handler: nil)
    
    
    // MARK: - Text field outlets
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet { emailTextField.delegate = self }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet { passwordTextField.delegate = self }
    }
    
    
    // MARK: - View setup

    override func viewDidLoad() {
        super.viewDidLoad()

        // Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self,
            action: NSSelectorFromString(Identifiers.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        alertView.addAction(alertAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITextFieldDelegate protocol methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            textField.resignFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
            performLogin()
        default:
            break
        }
        return false
    }
    
    
    // MARK: - Button actions
    
    @IBAction func backToSignupPressed(sender: UIButton) {
        // VC was modally presented, so dismissing self goes back to signup
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
        performLogin()
    }
    
    @IBAction func resetPasswordButtonPressed(sender: UIButton) {
        // TODO: implement
    }
    
    
    // MARK: - Gesture actions
    
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // MARK: - Helper functions
    
    func performLogin() {
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.userInteractionEnabled = false
        
        CustomUser.logInWithUsernameInBackground(emailTextField.text!.lowercaseString, password: passwordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.performSegueWithIdentifier(Identifiers.PostLoginSegue, sender: self)
            } else {
                if let error = error {
                    self.alertView.title = Constants.Validation.SigninErrorTitle
                    if let errorString = error.userInfo["error"] as? String {
                        self.alertView.message = errorString
                    } else {
                        self.alertView.message = Constants.Validation.SigninErrorDefaultMessage
                    }
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.presentViewController(self.alertView, animated: true, completion: nil)
                }
            }
        }
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
