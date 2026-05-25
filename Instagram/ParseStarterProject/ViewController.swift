//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)
class ViewController: UIViewController {
  
  var signupActive = true
  
  @IBOutlet var userName: UITextField!
  
  @IBOutlet var passWord: UITextField!
  
  
  @IBOutlet var registeredText: UILabel!
  
  @IBOutlet var signUpButton: UIButton!
  
  @IBOutlet var logInButton: UIButton!
  
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  func displayAlert(title:String, message: String) {
    let uiAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    uiAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
      self.dismissViewControllerAnimated(true, completion: nil)
      
      }
      )
    )
    
    self.presentViewController(uiAlert, animated: true, completion: nil)
    
  }
  
  @IBAction func signUp(sender: AnyObject) {
    
    if userName.text == "" || passWord.text == "" {
      
        displayAlert("Error in form", message: "Please Enter Username and Password")
      
    }
    else {
      
      activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
      activityIndicator.center = self.view.center
      activityIndicator.hidesWhenStopped = true
      activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
      view.addSubview(activityIndicator)
      activityIndicator.startAnimating()
      UIApplication.sharedApplication().beginIgnoringInteractionEvents()
      
      var errorMessage = "Please Try Again Later"
      
      if signupActive == true {
        let user = PFUser()
        user.username = userName.text
        user.password = passWord.text
        
        user.signUpInBackgroundWithBlock({(success,error) -> Void in
          
          self.activityIndicator.stopAnimating()
          UIApplication.sharedApplication().endIgnoringInteractionEvents()
          
          if error == nil {
            // Signup successful
            print ("Success on signup")
          }
          else {
            
            if let errorString = error!.userInfo["error"] as? String {
              
              errorMessage = errorString
              
            }
            
            self.displayAlert("Failed Signup", message: errorMessage)
            
          }
        })
      }
      else {
        
        PFUser.logInWithUsernameInBackground(userName.text!, password: passWord.text!, block:
          {(user,error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
              // Logged In
              print ("Logged In")
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
  
  
  @IBAction func logIn(sender: AnyObject) {
    
    if signupActive == true {
      
      signUpButton.setTitle("Log In", forState: UIControlState.Normal)
      
      registeredText.text = "Not registered?"
      
      logInButton.setTitle("Sign Up", forState: UIControlState.Normal)
      
      signupActive = false
      
    } else {
      
      signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
      
      registeredText.text = "Already registered?"
      
      logInButton.setTitle("Login", forState: UIControlState.Normal)
      
      signupActive = true
      
    }
    
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(animated: Bool) {
    if PFUser.currentUser() != nil {
      // Already Logged In
      print ("Already Logged In")
      self.performSegueWithIdentifier("login", sender: self)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

