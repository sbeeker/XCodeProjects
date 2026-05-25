//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
   @IBOutlet var importedImage: UIImageView!
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    
    print("Image Selected")
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
    importedImage.image = image
  }
  
  
  //func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
  
  
  @IBAction func pause(sender: AnyObject){
    activityIndicator=UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.Gray
    view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
  }
  
  @available(iOS 8.0, *)
  @IBAction func createAlert(sender: AnyObject) {
    
    var alert = UIAlertController(title: "Alert Alert", message: "Are you sure", preferredStyle: UIAlertControllerStyle.Alert)
    
    
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
      self.dismissViewControllerAnimated(true, completion: nil)
    }))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  @IBAction func restore(sender: AnyObject) {
    activityIndicator.stopAnimating()
    // UIApplication.sharedApplication().endIgnoringInteractionEvents()
  }
  @IBAction func importImage(sender: AnyObject) {
    
    var image = UIImagePickerController()
    image.delegate = self
    image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    image.allowsEditing = false
    
    self.presentViewController(image, animated: true, completion: nil)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    
      /*
      let product = PFObject(className: "Products")
     
      product["name"] = "Ice Cream"
      
      product["description"] = "Tuity Fruity"
      
      product["price"] = 4.99
      
      product.saveInBackgroundWithBlock { (success, error) -> Void in
        
        if success == true {
          print ("Successful!");
          print ("Product saved with ID \(product.objectId)")
        }
        else {
          print ("Failed");
          print (errno);
        }}
      
      var query = PFQuery(className: "Products")
      query.getObjectInBackgroundWithId("fpfCphKqlf") { (object: PFObject?, error: NSError?) -> Void in
        if error != nil {
          print (error)
        }
        else if let product = object {
          //print(object)
          //print(object?.objectForKey("description"))
          product["description"] = "Rocky Road"
          product["price"] = 7.99
          product.saveInBackground()
        }
      }
 */
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

