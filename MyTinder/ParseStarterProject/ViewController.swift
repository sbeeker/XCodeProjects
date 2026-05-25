//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class ViewController: UIViewController {
 
  @IBAction func signIn(sender: AnyObject) {
        
        let permissions = ["public_profile", "email"]
        
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {(user, error)  in
          
            if error != nil {
                
                print(error)
                
            } else {
                
                 if FBSDKAccessToken.currentAccessToken() != nil {
                    
                    if let interestedInWomen = user!.valueForKey("interestedInWomen") {
                        
                        self.performSegueWithIdentifier("logUserIn", sender: self)
                      
                    } else {
                    
                        self.performSegueWithIdentifier("showSigninScreen", sender: self)
                    
                    }
                    
                }
                
                
                
            }
            
            
            
        })

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        if let username = PFUser.currentUser()?.username {
            
            if let interestedInWomen = PFUser.currentUser()?.valueForKey("interestedInWomen") {
                
                self.performSegueWithIdentifier("logUserIn", sender: self)
                
            } else {
                
                self.performSegueWithIdentifier("showSigninScreen", sender: self)
                
            }
            
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

