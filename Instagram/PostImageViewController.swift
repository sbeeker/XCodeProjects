//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Scott A. Beeker on 7/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


@available(iOS 8.0, *)
class PostImageViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func displayAlert(title:String, message: String) {
    let uiAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    uiAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
      self.dismissViewControllerAnimated(true, completion: nil)
      
      }
      )
    )
    
    self.presentViewController(uiAlert, animated: true, completion: nil)
    
  }
  
  var activityIndicator = UIActivityIndicatorView()

  @IBOutlet var message: UITextField!
  
  @IBOutlet var imageToPost: UIImageView!
  
  
  @IBAction func postImage(sender: AnyObject) {
    
    let post = PFObject(className: "Post")
    let pictureName = "picture"
    
    activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
    activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()

    post["message"] = message.text
    post["userId"] = PFUser.currentUser()!.objectId!
    let imageData = UIImagePNGRepresentation(imageToPost.image!)
     // let imageFile = PFFile(name: "0000picture", data: imageData!)
         // let imageFile = PFFile(name: "picture", data: imageData!)
    let imageFile = PFFile(name: pictureName, data: imageData!)
    // 
    post["imageFile"] = imageFile
    post.saveInBackgroundWithBlock { (success, error) -> Void in
      
      self.activityIndicator.stopAnimating()
      
      UIApplication.sharedApplication().endIgnoringInteractionEvents()
      
      if error == nil {
        
        self.displayAlert("Image Posted", message: "Your image has been posted successfully")
        
        print ("Success")
        self.imageToPost.image = UIImage(named: "Whats-the-difference-between-being-hungry-and....png")
        
        self.message.text = ""
      }
      else {
        print ("Update image to parse failed")
        
             self.displayAlert("Image Posted Failed ", message: "Please Try Again Later")
        
      }
    }
  }
  
  @IBAction func chooseImage(sender: AnyObject) {
    
    let image = UIImagePickerController()
    image.delegate = self
    image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    image.allowsEditing = false
    self.presentViewController(image, animated: true, completion: nil)
    
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    self.dismissViewControllerAnimated(true, completion: nil)
    
      imageToPost.image = image
  }
  

  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
