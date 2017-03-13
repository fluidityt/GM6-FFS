//
//  func addKid.swift
//  GM6 FFS

import SpriteKit

typealias Succeeded = Bool

func addKid(_ theKid: IGE, to theMother: IGE) -> Succeeded {

  // Please note this is reversed from pram order:
  switch (theMother, theKid) {
    
  case (let mother as Choice, let kid as Prompt):
    kid.mother = mother
    
    mother.scene!.addChild(kid)
    mother.child = kid
    sys.currentNode = kid
    
    
    align(mother)
    
  case (let mother as IGE_CanDraw, let kid as Choice):
    kid.mother = mother

    mother.scene!.addChild(kid)
    mother.childs.append(kid)
    sys.currentNode = kid
    
    draw(mother)
    resize(mother)

  default: return false
    
  }
  
  return true
}
