//
//  ViewController.swift
//  Working With Audio
//
//  Created by Rob Percival on 23/06/2015.
//  Copyright © 2015 Appfish. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var slider: UISlider!
    
    @IBAction func play(sender: AnyObject) {
        
         player.play()
        
    }
    
    @IBAction func pause(sender: AnyObject) {
        
        player.pause()
        
    }
    
    @IBAction func adjustVolume(sender: AnyObject) {
        
        player.volume = slider.value
        
    }
    
    var player: AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioPath = NSBundle.mainBundle().pathForResource("bach", ofType: "mp3")!
        
        do {
            
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            
            
        } catch {
            
            // Process error here
            
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

