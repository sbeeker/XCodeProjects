//
//  ContactsViewController.swift
//  ParseStarterProject
//
//  Created by Rob Percival on 14/07/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class ContactsViewController: UITableViewController {
  
  var emails = [String]()
  var images = [UIImage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    let query = PFUser.query()!
    query.whereKey("accepted", equalTo: (PFUser.currentUser()?.objectId!)!)
    query.whereKey("objectId", containedIn: PFUser.currentUser()?["accepted"] as! [String])
    
    query.findObjectsInBackgroundWithBlock ({(results, error)  in
      
      print ("Get all accepted list")
      if results != nil {
        for result in results! {
          
          print("Contacts = <\(results)>")
          self.emails.append(result.valueForKey("email")! as! String)
          
          let imageFile = result.valueForKey("image") as! PFFile
        
          imageFile.getDataInBackgroundWithBlock ({(imageData, error) in
            if error == nil {
              if let data = imageData {
                self.images.append(UIImage(data: data)!)
                self.tableView.reloadData()
              } else {
                print (error)
              }
            }
          })
        }
        self.tableView.reloadData()
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return emails.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    
    cell.textLabel?.text = emails[indexPath.row]
    
    if images.count > indexPath.row {
      
      cell.imageView?.image = images[indexPath.row]
      
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let url = NSURL(string: "mailto:" + emails[indexPath.row])
    
    UIApplication.sharedApplication().openURL(url!)
    
  }
  
  
  
}













