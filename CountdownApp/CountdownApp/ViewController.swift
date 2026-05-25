//
//  ViewController.swift
//  CountdownApp
//
//  Created by Scott A. Beeker on 7/14/16.
//  Copyright © 2016 Scott A. Beeker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
  @IBOutlet var datePicker: UIDatePicker!
  
  
  @IBOutlet var countingLabel: UILabel!
  
  var timer = NSTimer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    timer = NSTimer.scheduledTimerWithTimeInterval(
      1,
      target:self,
      selector: #selector(ViewController.updateCounter),
      userInfo: nil, repeats: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func updateCounter() {
    let timeLeft = datePicker.date.timeIntervalSinceNow
    countingLabel.text = timeLeft.time
  }
  
}

extension NSTimeInterval {
  var time:String {
    return String(format:"%02dd %02dh %02dm %02ds",
                  Int((self/86400)), Int((self/3600.0)%24), Int((self/60.0)%60), Int((self)%60))
  }
}

