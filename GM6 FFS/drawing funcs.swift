//
//  drawing funcs.swift
//  GM6 FFS

import SpriteKit

func align(_ choice: Choice) {
  guard let theChild = choice.child else { print("align: no child"); return }
  theChild.position = choice.position
  theChild.position.x += choice.frame.width + 10
  draw(theChild as! Prompt)
}

func draw(_ igecd: IGE_CanDraw) {
  
  var y: CGFloat? = CGFloat(0)
  for child in igecd.childs {
    child.position = igecd.position
    child.position.y += y!
    child.position.x += igecd.frame.width + 10
    align(child)
    y! += 30 // Set height for next one.
  }
  y = nil
}

func resize(_ igecd: IGE_CanDraw) {
  igecd.size = CGSize(width: igecd.size.width,
                      height: CGFloat(igecd.childs.count * 30))
  switch (igecd.childs.count) {
  case 0:  print("resize: no childs found")
  default: print("resize: no case found")
  }
  sys.frames[igecd.name!] = igecd.frame
}

func swapChoices(detectedChoice: inout Choice) {
  guard sys.currentNode is Choice else { fatalError("swapChoice: sys.curnode ! choice") }
  print("swapping choices")
  
  let tempNode    = sys.currentNode!.copy() as! Choice // For use with detectedChoice.
  sys.currentNode = detectedChoice.copy()   as! Choice
  detectedChoice  = tempNode.copy()         as! Choice
  
  // FIXME: determine which one is further left
  align(detectedChoice)
  align(sys.currentNode! as! Choice)
  
  // guard var curNode = sys.currentNode as? Choice else { fatalError("swapChoice: not a Choice selected") }
  // swap(&curNode, &detectedChoice)
}

