//
//  GameScene.swift
//  CookieCrunch
//
//  Created by Razeware on 13/04/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  // MARK: Properties
  
  // This is marked as ! because it will not initially have a value, but pretty
  // soon after the GameScene is created it will be given a Level object, and
  // from then on it will always have one (it will never be nil again).
  var level: Level!
  
  let TileWidth: CGFloat = 32.0
  let TileHeight: CGFloat = 36.0
  
  let gameLayer = SKNode()
  let cookiesLayer = SKNode()
  let tilesLayer = SKNode()
  
  // The column and row numbers of the cookie that the player first touched
  // when he started his swipe movement. These are marked ? because they may
  // become nil (meaning no swipe is in progress).
  var swipeFromColumn: Int?
  var swipeFromRow: Int?
  
  // The scene handles touches. If it recognizes that the user makes a swipe,
  // it will call this swipe handler. This is how it communicates back to the
  // ViewController that a swap needs to take place. You could also use a
  // delegate for this.
  var swipeHandler: ((Swap) -> ())?
  
  // Sprite that is drawn on top of the cookie that the player is trying to swap.
  var selectionSprite = SKSpriteNode()
  
  // Pre-load sounds
  let swapSound = SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: false)
  let invalidSwapSound = SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
  let matchSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
  let fallingCookieSound = SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)
  let addCookieSound = SKAction.playSoundFileNamed("Drip.wav", waitForCompletion: false)
  
  
  // MARK: Init
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    
    anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    // Put an image on the background. Because the scene's anchorPoint is
    // (0.5, 0.5), the background image will always be centered on the screen.
    let background = SKSpriteNode(imageNamed: "Background")
    background.size = size
    addChild(background)
    
    // Add a new node that is the container for all other layers on the playing
    // field. This gameLayer is also centered in the screen.
    addChild(gameLayer)
    
    let layerPosition = CGPoint(
      x: -TileWidth * CGFloat(NumColumns) / 2,
      y: -TileHeight * CGFloat(NumRows) / 2)
    
    // The tiles layer represents the shape of the level. It contains a sprite
    // node for each square that is filled in.
    tilesLayer.position = layerPosition
    gameLayer.addChild(tilesLayer)
    
    // This layer holds the Cookie sprites. The positions of these sprites
    // are relative to the cookiesLayer's bottom-left corner.
    cookiesLayer.position = layerPosition
    gameLayer.addChild(cookiesLayer)
    
    // nil means that these properties have invalid values.
    swipeFromColumn = nil
    swipeFromRow = nil
  }
  
  
  // MARK: Level Setup
  
  func addTiles() {
    for row in 0..<NumRows {
      for column in 0..<NumColumns {
        // If there is a tile at this position, then create a new tile
        // sprite and add it to the mask layer.
        if level.tileAtColumn(column, row: row) != nil {
          let tileNode = SKSpriteNode(imageNamed: "Tile")
          tileNode.size = CGSize(width: TileWidth, height: TileHeight)
          tileNode.position = pointForColumn(column, row: row)
          tilesLayer.addChild(tileNode)
        }
      }
    }
  }
  
  func addSpritesForCookies(cookies: Set<Cookie>) {
    for cookie in cookies {
      // Create a new sprite for the cookie and add it to the cookiesLayer.
      let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName)
      sprite.size = CGSize(width: TileWidth, height: TileHeight)
      sprite.position = pointForColumn(cookie.column, row: cookie.row)
      cookiesLayer.addChild(sprite)
      cookie.sprite = sprite
    }
  }
  
  
  // MARK: Point conversion
  
  // Converts a column,row pair into a CGPoint that is relative to the cookieLayer.
  func pointForColumn(column: Int, row: Int) -> CGPoint {
    return CGPoint(
      x: CGFloat(column)*TileWidth + TileWidth/2,
      y: CGFloat(row)*TileHeight + TileHeight/2)
  }
  
  // Converts a point relative to the cookieLayer into column and row numbers.
  func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
    // Is this a valid location within the cookies layer? If yes,
    // calculate the corresponding row and column numbers.
    if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
      point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
      return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
    } else {
      return (false, 0, 0)  // invalid location
    }
  }
  
  
  // MARK: Cookie Swapping
  
  // We get here after the user performs a swipe. This sets in motion a whole
  // chain of events: 1) swap the cookies, 2) remove the matching lines, 3)
  // drop new cookies into the screen, 4) check if they create new matches,
  // and so on.
  func trySwapHorizontal(horzDelta: Int, vertical vertDelta: Int) {
    let toColumn = swipeFromColumn! + horzDelta
    let toRow = swipeFromRow! + vertDelta
    
    // Going outside the bounds of the array? This happens when the user swipes
    // over the edge of the grid. We should ignore such swipes.
    guard toColumn >= 0 && toColumn < NumColumns else { return }
    guard toRow >= 0 && toRow < NumRows else { return }
    
    // Can't swap if there is no cookie to swap with. This happens when the user
    // swipes into a gap where there is no tile.
    if let toCookie = level.cookieAtColumn(toColumn, row: toRow),
       let fromCookie = level.cookieAtColumn(swipeFromColumn!, row: swipeFromRow!),
       let handler = swipeHandler {
         // Communicate this swap request back to the ViewController.
         let swap = Swap(cookieA: fromCookie, cookieB: toCookie)
         handler(swap)
    }
  }
  
  func animateSwap(swap: Swap, completion: () -> ()) {
    let spriteA = swap.cookieA.sprite!
    let spriteB = swap.cookieB.sprite!
    
    spriteA.zPosition = 100
    spriteB.zPosition = 90
    
    let duration: NSTimeInterval = 0.3
    
    let moveA = SKAction.moveTo(spriteB.position, duration: duration)
    moveA.timingMode = .EaseOut
    spriteA.runAction(moveA, completion: completion)
    
    let moveB = SKAction.moveTo(spriteA.position, duration: duration)
    moveB.timingMode = .EaseOut
    spriteB.runAction(moveB)
    
    runAction(swapSound)
  }
  
  func animateInvalidSwap(swap: Swap, completion: () -> ()) {
    let spriteA = swap.cookieA.sprite!
    let spriteB = swap.cookieB.sprite!
    
    spriteA.zPosition = 100
    spriteB.zPosition = 90
    
    let duration: NSTimeInterval = 0.2
    
    let moveA = SKAction.moveTo(spriteB.position, duration: duration)
    moveA.timingMode = .EaseOut
    
    let moveB = SKAction.moveTo(spriteA.position, duration: duration)
    moveB.timingMode = .EaseOut
    
    spriteA.runAction(SKAction.sequence([moveA, moveB]), completion: completion)
    spriteB.runAction(SKAction.sequence([moveB, moveA]))
    
    runAction(invalidSwapSound)
  }
  
  func showSelectionIndicatorForCookie(cookie: Cookie) {
    if selectionSprite.parent != nil {
      selectionSprite.removeFromParent()
    }
    
    if let sprite = cookie.sprite {
      let texture = SKTexture(imageNamed: cookie.cookieType.highlightedSpriteName)
      selectionSprite.size = CGSize(width: TileWidth, height: TileHeight)
      selectionSprite.runAction(SKAction.setTexture(texture))
      
      sprite.addChild(selectionSprite)
      selectionSprite.alpha = 1.0
    }
  }
  
  func hideSelectionIndicator() {
    selectionSprite.runAction(SKAction.sequence([
      SKAction.fadeOutWithDuration(0.3),
      SKAction.removeFromParent()]))
  }
  
  
  // MARK: Cookie Swipe Handlers
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    guard let touch = touches.first else { return }
    // Convert the touch location to a point relative to the cookiesLayer.
    let location = touch.locationInNode(cookiesLayer)
    
    // If the touch is inside a square, then this might be the start of a
    // swipe motion.
    let (success, column, row) = convertPoint(location)
    if success {
      // The touch must be on a cookie, not on an empty tile.
      if let cookie = level.cookieAtColumn(column, row: row) {
        // Remember in which column and row the swipe started, so we can compare
        // them later to find the direction of the swipe. This is also the first
        // cookie that will be swapped.
        swipeFromColumn = column
        swipeFromRow = row
        showSelectionIndicatorForCookie(cookie)
      }
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    // If swipeFromColumn is nil then either the swipe began outside
    // the valid area or the game has already swapped the cookies and we need
    // to ignore the rest of the motion.
    guard swipeFromColumn != nil else { return }
    
    guard let touch = touches.first else { return }
    let location = touch.locationInNode(cookiesLayer)
    
    let (success, column, row) = convertPoint(location)
    if success {
      // Figure out in which direction the player swiped. Diagonal swipes
      // are not allowed.
      var horzDelta = 0, vertDelta = 0
      if column < swipeFromColumn! {          // swipe left
        horzDelta = -1
      } else if column > swipeFromColumn! {   // swipe right
        horzDelta = 1
      } else if row < swipeFromRow! {         // swipe down
        vertDelta = -1
      } else if row > swipeFromRow! {         // swipe up
        vertDelta = 1
      }
      
      // Only try swapping when the user swiped into a new square.
      if horzDelta != 0 || vertDelta != 0 {
        trySwapHorizontal(horzDelta, vertical: vertDelta)
        hideSelectionIndicator()
        
        // Ignore the rest of this swipe motion from now on.
        swipeFromColumn = nil
      }
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    // Remove the selection indicator with a fade-out. We only need to do this
    // when the player didn't actually swipe.
    if selectionSprite.parent != nil && swipeFromColumn != nil {
      hideSelectionIndicator()
    }
    
    // If the gesture ended, regardless of whether if was a valid swipe or not,
    // reset the starting column and row numbers.
    swipeFromColumn = nil
    swipeFromRow = nil
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    if let touches = touches {
      touchesEnded(touches, withEvent: event)
    }
  }
  
}