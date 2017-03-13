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
