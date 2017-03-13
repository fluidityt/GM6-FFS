//
//  TouchTypes.swift
//  GM6 FFS

import SpriteKit

extension GameScene {
  
  func handleTouch(riskyTouch: Touch) -> CheckCollisions {
    
    guard let theTouch = riskyTouch else { return false }
    // FIXME: Apparently this was possible >.>()
    if theTouch.0 == .moved { if !sys.isTouching { fatalError("how possible??") } }
    if theTouch.0 == .ended { if !sys.isTouching { fatalError("how possible??") } }
    defer { sys.touch = nil } // VERY IMPORTANT
    
    switch theTouch {
      
    case (.began, let ige as IGE, _):
      sys.currentNode = ige
      sys.isTouching = true
      return false
      
    case (.moved, let prompt as Prompt, let xy as CGPoint):
      prompt.position = xy
      draw(prompt)
      return false
      
    case (.moved, let choice as Choice, let xy as CGPoint):
      choice.position = xy
      align(choice)
      return false
      
    case (.ended, _, _):
      checkCollisions()
      if let collidedChoice = sys.collided as? Choice {
        if let currentChoice = sys.currentNode as? Choice {

          swapChoices(choice1: collidedChoice, choice2: currentChoice)
          //doCollision(with: sys.collided! as! Choice, against: sys.currentNode! as! Choice)
        }
      }
      
      sys.isTouching = false
      return true
      
    case (.added,_, _):
      guard let curNode = sys.currentNode else {
        print("tb: no node selected")
        return false
      }
      print("<<", curNode.name as Any, ">> is selected")
      
      if let      prompt = curNode as? Prompt {
        if !addKid(Choice(title: "added prompt", mother: prompt), to: prompt) {
          draw(prompt)
          return true
        } else { return false }
      }
      else if let superNode = curNode as? Super {
        if !addKid(Choice(title: "added super", mother: superNode), to: superNode) {
          draw(superNode)
          return true
        } else { return false }
      }
      else if let choice = curNode as? Choice {
        if sys.igeCounter > 1 { choice.color = SKColor.green } // FIXME: why does this not work in the brackets?
        if !addKid(Prompt(title: "added choice", mother: choice), to: choice) {
          return true
        } else { return false }
      }
      else {
        return false
      }
      
    default: return false
    }
  }
}
