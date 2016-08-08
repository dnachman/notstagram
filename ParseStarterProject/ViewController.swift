/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

@available(iOS 8.0, *)
class ViewController: UIViewController {
    
    var signupActive = false
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var switchText: UILabel!
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func switchMode(sender: AnyObject) {
        if signupActive == true {
            primaryButton.setTitle("Log In", forState: UIControlState.Normal)
            switchText.text = "Not registered?"
            switchButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
        }
        else {
            primaryButton.setTitle("Sign Up", forState: UIControlState.Normal)
            switchText.text = "Already registered?"
            switchButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
        }
    }
    
    @IBAction func doPrimaryAction(sender: AnyObject) {
        
        if username.text == "" || password == "" {
            displayAlert("Error in form", message: "Please enter a username and password")
        }
        else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if signupActive == true {
            
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                
                
                user.signUpInBackgroundWithBlock({ (success, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        // signup success
                        self.performSegueWithIdentifier("login", sender: self)
                    }
                    else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed SignUp", message: errorMessage)
                    }
                    
                })
            }
            else {
                // login
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        // logged in!
                        self.performSegueWithIdentifier("login", sender: self)
                    }
                    else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed Login", message: errorMessage)
                    }
                    
                })
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
