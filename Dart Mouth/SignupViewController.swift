//
//  SignupViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/1/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    struct Identifiers {
        static let DismissKeyboard = "dismissKeyboard"
        static let PostSignupSegue = "startAfterSignup"
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
    
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet { confirmPasswordTextField.delegate = self }
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
    
    
    // MARK: - UITextFieldDelegate protocol methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    // MARK: - Button actions
    
    @IBAction func signupButtonPressed(sender: UIButton) {
        let allFieldsValid = !showAlertsForInvalidFields() // intentionally being explicit here
        if allFieldsValid {
            // Sign up using Parse
            let user = CustomUser()
            user.email = emailTextField.text!
            user.username = emailTextField.text!
            user.password = passwordTextField.text!
            
            user.goalDailyCalories = Constants.NutritionalConstants.DefaultCalories
            
            let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinningActivity.userInteractionEnabled = false
            user.signUpInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    self.alertView.title = Constants.Validation.SignupErrorTitle
                    if let errorString = error.userInfo["error"] as? String {
                        self.alertView.message = errorString
                    } else {
                        self.alertView.message = Constants.Validation.SignupErrorDefaultMessage
                    }
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.presentViewController(self.alertView, animated: true, completion: nil)
                } else {
                    // No error. Proceed.
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.performSegueWithIdentifier(Identifiers.PostSignupSegue, sender: self)
                }
            })
        }
    }
    
    
    // MARK: - Gesture actions
    
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // MARK: - Validation helper functions
    
    func isValidEmail(email: String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", Constants.Validation.EmailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let len = password.characters.count
        return len >= Constants.Validation.MinimumPasswordLength && len <= Constants.Validation.MaximumPasswordLength
    }
    
    /*
    Helper function that shows at most one alert for an invalid email, password, or password
    confirmation field. Returns true if an alert was shown. Returns false if all fields are valid.
    */
    func showAlertsForInvalidFields() -> Bool {
        let email: String? = emailTextField.text
        let password: String? = passwordTextField.text
        let confirmPassword: String? = confirmPasswordTextField.text
        
        if email == nil || !isValidEmail(email!) {
            alertView.title = Constants.Validation.InvalidEmailTitle
            alertView.message = Constants.Validation.InvalidEmailMessage
            self.presentViewController(alertView, animated: true, completion: nil)
            return true
        }
        if password == nil || !isValidPassword(password!) {
            alertView.title = Constants.Validation.InvalidPasswordTitle
            alertView.message = Constants.Validation.InvalidPasswordMessage
            self.presentViewController(alertView, animated: true, completion: nil)
            return true
        }
        if confirmPassword == nil || password! != confirmPassword! {
            alertView.title = Constants.Validation.NoMatchPasswordsTitle
            alertView.message = Constants.Validation.NoMatchPasswordsMessage
            self.presentViewController(alertView, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - Miscellaneous
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
