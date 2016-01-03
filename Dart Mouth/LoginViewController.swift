//
//  LoginViewController.swift
//  Dart Mouth
//
//  Created by Sujay Busam on 1/1/16.
//  Copyright © 2016 Sujay's Dev Center. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    struct Identifiers {
        static let DismissKeyboard = "dismissKeyboard"
    }
    
    struct Validation {
        static let MinimumPasswordLength = 6
        static let MaximumPasswordLength = 25
        static let EmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        static let InvalidEmailTitle = "Invalid Email"
        static let InvalidEmailMessage = "Please sign up with a valid email."
        static let InvalidPasswordTitle = "Invalid Password"
        static let InvalidPasswordMessage = "Please enter a password between \(MinimumPasswordLength) and \(MaximumPasswordLength) characters, inclusive."
        static let NoMatchPasswordsTitle = "Passwords Don't Match"
        static let NoMatchPasswordsMessage = "Please correctly confirm your password."
        static let OkActionTitle = "OK"
    }
    
    var alertView = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
    var alertAction = UIAlertAction(title: Validation.OkActionTitle, style: .Default, handler: nil)
    
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
        return true
    }
    
    
    // MARK: - Button actions
    
    @IBAction func signupButtonPressed(sender: UIButton) {
        let allFieldsValid = !showAlertsForInvalidFields() // intentionally being explicit here
        if allFieldsValid {
            // Sign up
            print("Signup")
        }
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
    }
    
    
    // MARK: - Gesture actions
    
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // MARK: - Validation helper function
    
    func isValidEmail(email: String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", Validation.EmailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let len = password.characters.count
        return len >= Validation.MinimumPasswordLength && len <= Validation.MaximumPasswordLength
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
            alertView.title = Validation.InvalidEmailTitle
            alertView.message = Validation.InvalidEmailMessage
            self.presentViewController(alertView, animated: true, completion: nil)
            return true
        }
        if password == nil || !isValidPassword(password!) {
            alertView.title = Validation.InvalidPasswordTitle
            alertView.message = Validation.InvalidPasswordMessage
            self.presentViewController(alertView, animated: true, completion: nil)
            return true
        }
        if confirmPassword == nil || password! != confirmPassword! {
            alertView.title = Validation.NoMatchPasswordsTitle
            alertView.message = Validation.NoMatchPasswordsMessage
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
