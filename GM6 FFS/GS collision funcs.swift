//
//  collision funcs.swift
//  GM6 FFS

import SpriteKit

extension GameScene {
  
  func swapChoices(choice1: Choice, choice2: Choice) {
    print("swapping choices")
   
    let tempColor = choice1.color
    
    choice1.color = choice2.color
    choice2.color = tempColor
    
    // FIXME: determine which one is further left
    align(choice1)
    align(choice2)
    
  }
  
  
  func doCollision(with curNode:  IGE,
                   against collidedNode:  IGE) {
    print("doing collisions...")
    // Should probably use multi-switch here...
    // FIXME: Will need to determine which one is closest for multi-hits
    // Determine if hit node is a prompt or choice:
    if let prompt = collidedNode as? Prompt {
      // ...
      _=prompt
    }
    else if let collidedChoice = collidedNode as? Choice {
      if let curChoice = curNode as? Choice {
        swapChoices(choice1: curChoice, choice2: collidedChoice)
      }
    }
    sys.collided = nil // FIXME: not sure if this works
  }


  func checkCollisions() {
    
    
    guard let currentNode = sys.currentNode else {
      print("checkCollision: curNode was nil!")
      return
    }
    
    for child in children {
      if child.name == "bkg" { continue }
      if child.name == sys.currentNode!.name { continue }
      
      
      if currentNode.frame.intersects(child.frame) {
        print("hit detected")
        // FIXME: should be IGE
        if let collidedChoice = child as? Choice {
          sys.collided = collidedChoice
        }
      }
      
    }
    // Base case:
  }
}
