import SpriteKit

//
// HandleTouch.swift
//

enum TouchTypes { case began, moved, ended, added }
typealias  Touch = (TouchTypes, Any, Any)?
let void = Void()
let aTouch: Touch = (TouchTypes.began, IGE.init(title: "hi"), void)
typealias CheckCollisions = Bool

func handleTouch(riskyTouch: Touch) -> CheckCollisions {
  guard let theTouch = riskyTouch else { return false }
  if theTouch.0 == .moved { if !sys.isTouching { fatalError() } }
  if theTouch.0 == .ended { if !sys.isTouching { fatalError() } }
  defer { sys.touch = nil }
  
  switch theTouch {
    
  case (.began, let ige as IGE, _):
    sys.currentNode = ige
    sys.touches.isTouching = true
    return false
    
  case (.moved, let prompt as Prompt, let xy as CGPoint):
    prompt.position = xy
    prompt.draw()
    return false
    
  case (.moved, let choice as Choice, let xy as CGPoint):
    choice.position = xy
    choice.align()
    return false
    
  case (.ended, _, _):
    sys.touches.isTouching = false
    return true
    
  default: return false
  }
}

enum Modes { case swap }

enum sizes {
  static  let
  prompt = CGSize(width: 50, height: 25),
  choice = CGSize(width: 200, height: 10)
  
  static func stretchedSize(numChildren: Int) -> CGSize {
    return CGSize(width: prompt.width, height: choice.height * 5.6)
  }
}

// Namespace:
enum sys {
  
  static var
  scene:        SKScene = SKScene(),
  igeCounter    = 0,
  currentNode:  IGE?,                    // NP
  frames:       [String: CGRect] = [:],
  collided:     IGE?,
  
  touch: Touch,
  isTouching: Bool = false
  
  /// Use this at various times... when sorting / swapping / deleting / adding iges.
  static func render(from ige: IGE) { // NP
    // Basically just a bunch of algos that adjust iges position.
    // So it isn"t overwhelming.. just render them at the correct Choice and then work on constraints later.
  }
  
  static func swapChoices(detectedChoice: inout Choice) {
    guard sys.currentNode is Choice else { fatalError("swapChoice: sys.curnode ! choice") }
    print("swapping choices")
    
    let tempNode    = sys.currentNode!.copy() as! Choice // For use with detectedChoice.
    sys.currentNode = detectedChoice.copy()   as! Choice
    detectedChoice  = tempNode.copy()         as! Choice
    
    // FIXME: determine which one is further left
    detectedChoice.align()
    (sys.currentNode! as! Choice).align()
    
    // guard var curNode = sys.currentNode as? Choice else { fatalError("swapChoice: not a Choice selected") }
    // swap(&curNode, &detectedChoice)
  }
};

//
// IGE init:
//

class IGE: SKSpriteNode {
  
  // Don't use:
  override var parent: SKNode?           { fatalError("IGE: Don't call .parent!"  ) }
  override var children: [SKNode]        { fatalError("IGE: Don't call .children!") }
  override func addChild(_ node: SKNode) { fatalError("IGE: Don't call .addChild!") }
  
  // Touch signaler:
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.touches.tb = (self, touches.first!.location(in: scene!))
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
  
  func draw() {
    
    var y = CGFloat(0)
    for child in childs {
      child.position = position
      child.position.y += y
      child.position.x += frame.width + 10
      child.align()
      y += 30 // Set height for next one.
    }
    y = 0
  }
  
  func resize() {
    size = CGSize(width: size.width, height: CGFloat((childs.count ) * 30))
    switch (childs.count) {
    case 0:  print("resize: no childs found")
    default: print("resize: no case found")
    }
    sys.frames[name!] = frame
  }
  
  override func addChild(_ node: SKNode) {
    guard let child = node as? Choice else { print("addChild: not a choice"); return }
    addKid()
    
  }
}

// Super:
final class Super: IGE_CanDraw {
}

// Prompts:
final class Prompt: IGE_CanDraw {
  
  var mother: Choice
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    sys.touches.tm = (self, touches.first!.location(in: scene!))
    
  }
  
  override func addChild(_ node: SKNode) {
    guard let child = node as? Choice else { print("addChild: not a choice"); return }
    child.mother = self
    
    scene!.addChild(child)
    childs.append(child)
    sys.currentNode = child
    
    draw()
    resize()
  }
  
  init(title: String, mother: Choice) {
    self.mother = mother
    super.init(title: title)
  }
  required init?(coder aDecoder: NSCoder) { fatalError("") }
};

// Choice:
final class Choice: IGE {
  
  var mother: IGE_CanDraw
  weak var child: IGE?
  
  func align() {
    guard let theChild = child else { print("align: no child"); return }
    theChild.position = position
    theChild.position.x += frame.width + 10
    (theChild as! Prompt).draw()
  }
  
  override func addChild(_ node: SKNode) {
    if child != nil { print("addChild: already has prompt"); return }
    guard let prompt = node as? Prompt else { print("not a prompt"); return }
    addKid()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      sys.touches.tm = (self, touches.first!.location(in: scene!))
  }
  
  init(title: String, mother: IGE_CanDraw) {
    self.mother = mother
    super.init(title: title)
  }
  required init?(coder aDecoder: NSCoder) { fatalError("") }
  
};

//
//  Buttons.swift
//

// Buttons:
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
    
    guard let curNode = sys.currentNode else { print("tb: no node selected"); return }
    print("<<", curNode.name as Any, ">> is selected")
    
    if let      cn = curNode as? Prompt {
      cn.addChild(Choice(title: "added prompt", mother: cn))
      cn.draw()
    }
    else if let cn = curNode as? Super {
      cn.addChild(Choice(title: "added super", mother: cn))
      cn.draw()
    }
    else if let cn = curNode as? Choice {
      cn.addChild(Prompt(title: "added choice", mother: cn))
      // FIXME: improve this:
      if sys.igeCounter > 1 { cn.color = SKColor.green }
    }
    
  }
};

//
//  GameScene.swift
//

class GameScene: SKScene {
  
  private func initialize() {
    // Laundry list:
    sys.scene = self
    let addButton = AddButton(color: .green, size: CGSize(width: 200, height: 200))
    addButton.position.x = frame.minX
    addButton.position.y -= 300
    addChild(addButton)
    
    let bkg = SKSpriteNode(color: .gray, size: size)
    bkg.isUserInteractionEnabled = true
    bkg.zPosition -= 1
    bkg.name = "bkg"
    addChild(bkg)
  }
  
  private func test() {
    let zip = Super(title: "new prompt"); ZIPSTUFF: do {
      addChild(zip)
      zip.position.x = frame.minX
      zip.resize()
      sys.currentNode = zip
    }
  }
  
  override func didMove(to view: SKView) {
    initialize()
    test()
  }
  
  private func doCollision(for child: IGE) {
    // Should probably use multi-switch here...
    // FIXME: Will need to determine which one is closest for multi-hits
    if let prompt = child as? Prompt { // Determine if hit node is a prompt or choice:
    } else if var choice = child as? Choice {
      if sys.currentNode is Choice {
        sys.swapChoices(detectedChoice: &choice)
      }
    }
    sys.collided = nil // FIXME: not sure if this works
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let collided = sys.collided { doCollision(for: collided) }
  }
  
  //
  // Stuff:
  //
  
  func doCollisionsIfNeededThenReturnIfNeedCheckAddButtons() -> Bool {
    let checkCollisions = handleTouch(riskyTouch: sys.touch)
    
    if checkCollisions {
      for child in children {
        if child.name == "bkg" { continue }
        if child.name == sys.currentNode!.name { continue }
        
        if sys.currentNode!.frame.intersects(child.frame) {
          // Do collision:
          print("hit detected")
          return false
        }
      }
    }
    // Base case:
    return true
  }
  
  override func update(_ currentTime: TimeInterval) {
    
  }
};
