//
//  SwipingViewController.swift
//  ParseStarterProject
//
//  Created by Rob Percival on 13/07/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class SwipingViewController: UIViewController {
  
  @IBOutlet var userImage: UIImageView!
  @IBOutlet var infoLabel: UILabel!
  
  var displayedUserId = ""
  
  func wasDragged(gesture: UIPanGestureRecognizer) {
    
    let translation = gesture.translationInView(self.view)
    let label = gesture.view!
    
    label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
    
    let xFromCenter = label.center.x - self.view.bounds.width / 2
    
    let scale = min(100 / abs(xFromCenter), 1)
    
    
    var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
    
    var stretch = CGAffineTransformScale(rotation, scale, scale)
    
    label.transform = stretch
    
    
    if gesture.state == UIGestureRecognizerState.Ended {
      
      var acceptedOrRejected = ""
      
      if label.center.x < 100 {
        
        acceptedOrRejected = "rejected"
        
      } else if label.center.x > self.view.bounds.width - 100 {
        
        acceptedOrRejected = "accepted"
        
      }
      
      if acceptedOrRejected != "" {
        
        PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey:acceptedOrRejected)
        
        do {
          try PFUser.currentUser()?.saveInBackground()
        }
        catch {
          print("Failure to save PFUser in SwipingViewController")
        }
        
      }
      
      rotation = CGAffineTransformMakeRotation(0)
      
      stretch = CGAffineTransformScale(rotation, 1, 1)
      
      label.transform = stretch
      
      label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
      
      updateImage()
      
    }
  }
  
  func updateImage() {

    print("SwipingViewController(): Starting updateImage()")
    
    
    // Setup a GEO Box to evaluate if other users are close to current user.
    let query = PFUser.query()!
    if let latitude = PFUser.currentUser()?["location"]?.latitude {
      if let longitude = PFUser.currentUser()?["location"]?.longitude {
        print("In updateImage - Lattitude: <\(latitude)>, Longitude: <\(longitude)>")
        print("Begin - Creating GEOBox")
        query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast:PFGeoPoint(latitude:latitude + 1, longitude: longitude + 1))
        print("Begin - Creating GEOBox")
      }
      
    }
    
    var interestedIn = "male"
    
    if PFUser.currentUser()!["interestedInWomen"]! as! Bool == true {
      
      interestedIn = "female"
      
    }
    
    var isFemale = true
    
    // if PFUser.currentUser()!["gender"]! as! String == "male" {
    if "male" == "male" {
      
      isFemale = false
      
    }
    
    query.whereKey("gender", equalTo:interestedIn)
    query.whereKey("interestedInWomen", equalTo: isFemale)
    
    var ignoredUsers = [""]
   
    
    if let acceptedUsers = PFUser.currentUser()?["accepted"]  {
      
      ignoredUsers += acceptedUsers as! Array
      
    }
    
    if let rejectedUsers = PFUser.currentUser()?["rejected"] {
      
      ignoredUsers += rejectedUsers as! Array
      
    }
    
  query.whereKey("objectId", notContainedIn: ignoredUsers)
   query.limit = 1
    
    query.findObjectsInBackgroundWithBlock ({(objects, error) in
      
      if error == nil {
        for object in objects! {
          self.displayedUserId = object.objectId!
          let imageFile = object.valueForKey("image") as! PFFile
          
          imageFile.getDataInBackgroundWithBlock ({(imageData, error) in
            if error == nil {
              if let data = imageData {
                self.userImage.image = UIImage(data: data)
              }
            }
            else {
              print ("Error - fetching image in SwipingViewController")
            }
          })
        }
      }
      else {
        print ("Error - fetching other users in SwipingViewController")
      }
    })
    print("SwipingViewController(): Finishing updateImage()")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(SwipingViewController.wasDragged(_:)))
    userImage.addGestureRecognizer(gesture)
    
    userImage.userInteractionEnabled = true
    
    PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
      if error == nil {
        print("SwipingViewController(): Got location successfully")
        PFUser.currentUser()!.setValue(geoPoint, forKey:"location")
        print("SwipingViewController(): Save location")
        PFUser.currentUser()!.saveInBackground()
        print("SwipingViewController(): Saved location sucessfully")
      } else {
        print(error)
      }
    }
    print("SwipingViewController(): Before Invoking updateImage()")
    updateImage()
    print("SwipingViewController(): After Invoking updateImage()")
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    print("SwipingViewController():  Starting prepareForSegue()")
    print("SwipingViewController(): set seque identifier to logOut <\(segue.identifier)>")
    
    if segue.identifier == "logOut" {
      print("SwipingViewController(): before logout User")
      PFUser.logOut()
      //PFUser.currentUser() = nil
      print("SwipingViewController(): after logout User")
      
    }
    
    print("SwipingViewController():  Finishing prepareForSegue()")  }
  
}
