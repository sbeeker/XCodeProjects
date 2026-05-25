//
//  GameViewController.swift
//  Monsters
//
//  Created by Scott A. Beeker on 7/15/16.
//  Copyright (c) 2016 Scott A. Beeker. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let scene = GameScene(size: view.bounds.size)
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    //scene.scaleMode = .AspectFill
    scene.scaleMode = .ResizeFill
    
    skView.presentScene(scene)
    
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
