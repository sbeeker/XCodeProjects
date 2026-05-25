//
//  ViewController.swift
//  Shopping List
//
//  Created by Scott A. Beeker on 6/19/16.
//  Copyright © 2016 Scott A. Beeker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemList = [String]()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func addButton(sender: UIButton) {
        
        let newItem = textField.text
        itemList.append(newItem!)
        textField.resignFirstResponder()
        textField.text = ""
        tableView.reloadData()
        NSUserDefaults.standardUserDefaults().setObject(itemList, forKey: "shoppingList")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if NSUserDefaults.standardUserDefaults().objectForKey("shoppingList") != nil {
            
            itemList = NSUserDefaults.standardUserDefaults().objectForKey("shoppingList") as! [String]
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        cell.textLabel?.text = itemList[indexPath.row]
        cell.textLabel?.textColor = UIColor.redColor()
        
        return (cell)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRow:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if selectedRow.accessoryType == UITableViewCellAccessoryType.None {
            selectedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedRow.tintColor = UIColor.greenColor()
            
        }
        else {
            
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let deletedRow:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            itemList.removeAtIndex(indexPath.row)
        
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            deletedRow.accessoryType = UITableViewCellAccessoryType.None
            
            NSUserDefaults.standardUserDefaults().setObject(itemList, forKey: "shoppingList")
            
            //itemList.reloadData()
            
        }
        
    }


}

