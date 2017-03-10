//
//  func addChild.swift
//  GM6 FFS

import SpriteKit

typealias Succeeded = Bool

func addKid(_ theKid: IGE, to theMother: IGE) -> Succeeded {

  // Please note this is reversed from pram order:
  switch (theMother, theKid) {
    
  case (let mother as Choice, let kid as Prompt):
    
    mother.scene!.addChild(kid)
    mother.child = kid
    sys.currentNode = kid
    
    kid.mother = mother
    
    mother.align()
    
  case (let mother as Prompt, let kid as Choice):
    mother.scene!.addChild(kid)
    mother.childs.append(kid)
    sys.currentNode = kid
    
    mother.draw()
    mother.resize()
    
  default: return false
    
  }
  
  return true
}
