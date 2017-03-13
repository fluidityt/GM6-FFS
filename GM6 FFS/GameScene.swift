import SpriteKit

// Random setup stuff:
let void = Void()
typealias CheckCollisions = Bool
typealias  Touch = (TouchTypes, Any, Any)?

// Enums:
enum TouchTypes { case began, moved, ended, added }

enum Modes { case swap }

// Constants:
enum sizes {
  static  let
  prompt = CGSize(width: 50, height: 25),
  choice = CGSize(width: 200, height: 10)
  
  static func stretchedSize(numChildren: Int) -> CGSize {
    return CGSize(width: prompt.width, height: choice.height * 5.6)
  }
}

// Globals:
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
      zip.position.y = frame.midY
      draw(zip)
      resize(zip)
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
    for child in children {
      if child.name == "bkg" { continue }
      if child.name == sys.currentNode!.name { continue }
      
      if sys.currentNode!.frame.intersects(child.frame) {
        // Do collision:
        print("hit detected")
        return false
      }
    }
    // Base case:
    return true
  }
  
  override func update(_ currentTime: TimeInterval) {
    if handleTouch(riskyTouch: sys.touch) {
      doCollisionsIfNeededThenReturnIfNeedCheckAddButtons()
    }
  }
};
