//
//  TouchTypes.swift
//  GM6 FFS

import SpriteKit

func handleTouch(riskyTouch: Touch) -> CheckCollisions {
  guard let theTouch = riskyTouch else { return false }
  if theTouch.0 == .moved { if !sys.isTouching { fatalError() } }
  if theTouch.0 == .ended { if !sys.isTouching { fatalError() } }
  defer { sys.touch = nil }
  
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
    sys.isTouching = false
    return true
    
  case (.added,_, _):
    guard let curNode = sys.currentNode else {
      print("tb: no node selected")
      return false
    }
    var returner = true
    print("<<", curNode.name as Any, ">> is selected")
    
    if let      prompt = curNode as? Prompt {
      prompt.addChild(Choice(title: "added prompt", mother: prompt))
      draw(prompt)
    }
    else if let superNode = curNode as? Super {
      superNode.addChild(Choice(title: "added super", mother: superNode))
      draw(superNode)
    }
    else if let choice = curNode as? Choice {
      choice.addChild(Prompt(title: "added choice", mother: choice))
      // FIXME: improve this:
      if sys.igeCounter > 1 { choice.color = SKColor.green }
    }
    else { returner = false}
    return returner
    
  default: return false
  }
}
