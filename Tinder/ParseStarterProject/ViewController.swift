//
//  ViewController.swift
//  ParseStarterProject
//
//  Created by Scott A. Beeker on 7/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let permissions = ["public_profile", "email"]
    
    
    PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
      (user: PFUser?, error: NSError?) -> Void in
      
      if let error = error {
        
        print(error)
        
      } else {
        if let user = user {
          print(user)
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

