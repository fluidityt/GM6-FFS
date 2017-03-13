//
//  classes.swift
//  GM6 FFS

import SpriteKit

//
// IGEs:
//

class IGE: SKSpriteNode {
  
  // Don't use:
  override var parent: SKNode?           { fatalError("IGE: Don't call .parent!"  ) }
  override var children: [SKNode]        { fatalError("IGE: Don't call .children!") }
  /*override func addChild(_ node: SKNode) { fatalError("IGE: Don't call .addChild!") }*/
  
  // Touch signaler:
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.touch = (TouchTypes.began,
                 self,
                 touches.first!.location(in: scene!))
  }
  
  // Init stuff:
  private func findName(title: String) -> String {
    let myType = String(describing: type(of: self))
    return (myType + ": " + title + String(sys.igeCounter))
  }
  
  private func findColor() -> SKColor {
    let myType = String(describing: type(of: self))
    if myType == "Prompt" || myType == "Super" {
      return .blue
    } else { return .red }
  }
  
  private func findSize() -> CGSize {
    let myType = String(describing: type(of: self))
    if myType == "Prompt" || myType == "Super" {
      return sizes.prompt
    } else { return sizes.choice }
  }
  
  init(title: String) {
    super.init(texture: nil, color: .black, size: CGSize.zero)
    sys.igeCounter += 1
    
    name        = findName(title: title)
    color       = findColor()
    size        = findSize()
    anchorPoint = CGPoint.zero
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("fe")}
  
};

// FIXME: Make a protocol
class IGE_CanDraw: IGE {
  
  var childs: [Choice] = []

  override func addChild(_ node: SKNode) {
    guard let child = node as? Choice else { print("addChild: not a choice"); return }
    let didAdd = addKid(child, to: self)
    if !didAdd { print("addChild: did not add child") }
    
  }
};

final class Super: IGE_CanDraw {
};

final class Prompt: IGE_CanDraw {
  
  var mother: Choice
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.touch = (TouchTypes.moved,
                 self,
                 touches.first!.location(in: scene!))
  }
  
  override func addChild(_ node: SKNode) {
    guard let kid = node as? Choice else { print("addChild: not a choice"); return }
    if !addKid(kid, to: self) { print("addChild: couldn't add kidd") }
  }
  
  init(title: String, mother: Choice) {
    self.mother = mother
    super.init(title: title)
  }
  required init?(coder aDecoder: NSCoder) { fatalError("") }
};

final class Choice: IGE {
  
  var mother: IGE_CanDraw
  weak var child: IGE?
  
  override func addChild(_ node: SKNode) {
    if child != nil { print("addChild: already has prompt"); return }
    guard let kid = node as? Prompt else { print("not a prompt"); return }
    if !addKid(kid, to: self) { print("addChild: no add kid") }
    
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.touch = (TouchTypes.moved,
                 self,
                 touches.first!.location(in: scene!))
  }
  
  init(title: String, mother: IGE_CanDraw) {
    self.mother = mother
    super.init(title: title)
  }
  required init?(coder aDecoder: NSCoder) { fatalError("") }
  
};

//
//  Buttons
//

class Button: SKSpriteNode {
  
  init(color: SKColor, size: CGSize) {
    super.init(texture: nil, color: color, size: size)
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
  
};

final class AddButton: Button {
  // Need to figure out based on Y value where to put new prompt at... will need a line.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.touch = (TouchTypes.added,
                 void,
                 void)
    
  }
};
