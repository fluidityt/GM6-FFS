import SpriteKit

//
// Random setup stuff:
//

let void = Void()

enum TouchTypes { case began, moved, ended, added };

enum Modes { case swap };

enum sizes {
  
  static  let
  prompt = CGSize(width:  50, height: 25),
  choice = CGSize(width: 200, height: 10)
  
  static func stretchedSize(numChildren: Int) -> CGSize {
    return CGSize(width: prompt.width, height: choice.height * 5.6)
  }
};

enum sys {
  
  static var
  scene:        SKScene = SKScene(),
  igeCounter    = 0,
  currentNode:  IGE?,                    // NP
  frames:       [String: CGRect] = [:],
  collided:     IGE?,
  
  touch: Touch,                          // NP
  isTouching: Bool = false
  
  /// Use this at various times... when sorting / swapping / deleting / adding iges.
  static func render(from ige: IGE) { // NP
    // Basically just a bunch of algos that adjust iges position.
    // So it isn"t overwhelming.. just render them at the correct Choice and then work on constraints later.
  }
};

typealias CheckCollisions = Bool
typealias Touch = (TouchTypes, Any, Any)?

//
//  GameScene:
//

// Setup:
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
  
}

// Touch and collision:
extension GameScene {
  
  private func doCollision(for child: IGE) {
    // Should probably use multi-switch here...
    // FIXME: Will need to determine which one is closest for multi-hits
    if let prompt = child as? Prompt { // Determine if hit node is a prompt or choice:
    } else if var choice = child as? Choice {
      if sys.currentNode is Choice {
        swapChoices(detectedChoice: &choice)
      }
    }
    sys.collided = nil // FIXME: not sure if this works
  }
  
  func doCollisions() -> Bool {
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
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let collided = sys.collided { doCollision(for: collided) }
  }
  
}

// Game loop:
extension GameScene {
  
  override func update(_ currentTime: TimeInterval) {
    if handleTouch(riskyTouch: sys.touch) {
      doCollisions()
    }
  }
};
