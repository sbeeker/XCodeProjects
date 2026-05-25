//
//  DriverViewController.swift
//  ParseStarterProject
//
//  Created by Rob Percival on 07/07/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class DriverViewController: UITableViewController, CLLocationManagerDelegate {
  
  var usernames = [String]()
  var locations = [CLLocationCoordinate2D]()
  var distances = [CLLocationDistance]()
  
  var locationManager:CLLocationManager!
  
  var latitude: CLLocationDegrees = 0
  var longitude: CLLocationDegrees = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    let location:CLLocationCoordinate2D = manager.location!.coordinate
    
    self.latitude = location.latitude
    self.longitude = location.longitude
    if PFUser.currentUser() != nil {
      
      print ("Update driver: \(PFUser.currentUser()!.username!) current location ")
      let query = PFQuery(className:"driverLocation")
      query.whereKey("username", equalTo:PFUser.currentUser()!.username!)
      query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        
        if error == nil {
          
          
          if let objects = objects {
            
            if objects.count > 0 {
              
              for object in objects {
                
                let query = PFQuery(className:"driverLocation")
                query.getObjectInBackgroundWithId(object.objectId!) {
                  (object: PFObject?, error: NSError?) -> Void in
                  if error != nil {
                    print("Error querying driver location info: \(error)")
                  } else if let object = object {
                    
                    object["driverLocation"] = PFGeoPoint(latitude:location.latitude, longitude:location.longitude)
                    object.saveInBackground()
                  }
                }
                
              }
              
            } else {
              
              let driverLocation = PFObject(className:"driverLocation")
              driverLocation["username"] = PFUser.currentUser()?.username
              driverLocation["driverLocation"] = PFGeoPoint(latitude:location.latitude, longitude:location.longitude)
              driverLocation.saveInBackground()
            }
          }
        } else {
          print("Error updating driver location info: \(error)")
        }
      }
      
      print ("Update driver reequest table:  Current User <\(PFUser.currentUser()!.username!)> rider request table info ")

      
      let requestQuery = PFQuery(className: "riderRequest")
      let driverCLLocation: CLLocation = CLLocation(latitude: location.latitude,longitude: location.longitude)
      requestQuery.whereKey("location", nearGeoPoint: PFGeoPoint(location: driverCLLocation))
      requestQuery.whereKeyDoesNotExist("driverResponded")
      requestQuery.limit = 10
      requestQuery.findObjectsInBackgroundWithBlock({ (objects, error) in
        if objects != nil {
          self.usernames.removeAll()
          self.locations.removeAll()
          for object in objects! {
            if let username = object["username"] as? String, location = object["location"] as? PFGeoPoint {
              self.usernames.append(username)
              let requestLocation = CLLocationCoordinate2DMake(location.latitude, location.longitude)
              self.locations.append(requestLocation)
              let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
              let driverCLLoction = CLLocation(latitude: self.latitude, longitude: self.longitude)
              let distance = driverCLLoction.distanceFromLocation(requestCLLocation)
              self.distances.append(distance / 1000)
            }
          }
          self.tableView.reloadData()
        }
      })
    }
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
    return usernames.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    
    let distanceDouble = Double(distances[indexPath.row])
    
    let roundedDistance = Double(round(distanceDouble * 10) / 10)
    
    cell.textLabel?.text = usernames[indexPath.row] + " - " + String(roundedDistance) + "km away"
    
    return cell
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "logoutDriver" {
      
      navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
      
      PFUser.logOut()
      
    } else if segue.identifier == "showViewRequests" {
      
      if let destination = segue.destinationViewController as? RequestViewController {
        
        destination.requestLocation = locations[(tableView.indexPathForSelectedRow?.row)!]
        destination.requestUsername = usernames[(tableView.indexPathForSelectedRow?.row)!]
        
      }
      
      
    }
    
  }
  
  
}
