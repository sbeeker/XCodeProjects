//
//  ViewController.swift
//  Webviews
//
//  Created by Rob Percival on 24/04/2015.
//  Copyright (c) 2015 Appfish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        
        var url = NSURL(string: "https://www.ecowebhosting.co.uk")
        
        var request = NSURLRequest(URL: url!)
        
        webview.loadRequest(request)
        
        */
        
        var html = "<html><body><h1>My Page</h1><p>This is my web page.</p></body></html>"
        
        webview.loadHTMLString(html, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

