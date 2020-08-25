import UIKit
import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "backgroundd")
        background.position = CGPoint(x:0, y:0)
        background.blendMode = .replace
        background.size.height = self.size.height
        background.zPosition = -1
        background.name = "background"
        addChild(background)
        physicsBody = SKPhysicsBody (edgeLoopFrom: frame)
        
        
        physicsWorld.contactDelegate = self
    }
    let someNode = SKNode()
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let square = SKSpriteNode (imageNamed: "redrectangle")
        square.setScale(0.10)
        square.physicsBody = SKPhysicsBody (rectangleOf: square.size)
        square.physicsBody?.friction = 0
        square.physicsBody?.restitution = 1.0
        square.physicsBody?.linearDamping = 0
        square.physicsBody?.angularDamping = 0
        square.physicsBody!.contactTestBitMask = square.physicsBody!.collisionBitMask
        square.position = location
        square.name = "square"
        addChild(square)
        
        
        let rectangle = SKSpriteNode (imageNamed: "redrectangle")
        rectangle.setScale(0.20)
        rectangle.physicsBody = SKPhysicsBody(rectangleOf: rectangle.size)
        rectangle.physicsBody?.contactTestBitMask = rectangle.physicsBody?.collisionBitMask ?? 0
        rectangle.physicsBody?.isDynamic = false
        rectangle.name = "rectangle"
        addChild(rectangle)
        
        
    }
    
    func collisionBetween(square: SKNode, object: SKNode) {
        
        if object.name == "rectangle" {
            print("boom")
        }
        else if object.name == "background" {
            print("boom")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "square" {
            collisionBetween(square: nodeA, object: nodeB)
        } else if nodeB.name == "square" {
            collisionBetween(square: nodeB, object: nodeA)
        }
    }
    
}



