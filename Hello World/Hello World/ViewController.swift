//
//  ViewController.swift
//  Hello World
//
//  Created by Rob Percival on 15/06/2015.
//  Copyright © 2015 Appfish. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var textField: UITextField!

    @IBAction func submit(sender: AnyObject) {
        
        print("Button tapped")
        
        label.text = textField.text
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello Rob!")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

