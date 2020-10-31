//
//  GameScene.swift
//  flyingshapes
//
//  Created by Dean Akira Soobratty on 8/16/20.
//  Copyright © 2020 Dean Akira Soobratty. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit
import AudioToolbox


class GameScene: SKScene, SKPhysicsContactDelegate {
    var pauseLabel: SKLabelNode!
    
    var pauseMode: Bool = false {
        didSet {
            if pauseMode {
                pauseLabel.text = "pause"
            } else {
                pauseLabel.text = "pause"
            }
        }
    }
     
    override func didMove(to view: SKView) {
        
        
        

        
        let square = SKSpriteNode (imageNamed: "redrectangle")
        square.setScale(0.10)
        square.physicsBody = SKPhysicsBody (rectangleOf: square.size)
        square.physicsBody?.friction = 0
        square.physicsBody?.restitution = 1.0
        square.physicsBody?.linearDamping = 0
        square.physicsBody?.angularDamping = 0
        square.physicsBody!.contactTestBitMask = square.physicsBody!.collisionBitMask
        square.position = CGPoint(x:12, y:100)
        square.name = "square"
        addChild(square)
        
        pauseLabel = SKLabelNode (fontNamed: "Chalkduster")
        pauseLabel.text = "Pause"
        pauseLabel.position = CGPoint(x:-230, y:610)
        pauseLabel.zPosition = 3
        pauseLabel.fontColor = UIColor.red
        addChild(pauseLabel)

        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "backgroundd")
        background.position = CGPoint(x:0, y:0)
        background.blendMode = .replace
        background.size.height = self.size.height
        background.size.width = self.size.height
        background.zPosition = -1
        background.name = "background"
        addChild(background)
        physicsBody = SKPhysicsBody (edgeLoopFrom: frame)
        
        let top = SKSpriteNode(imageNamed: "rectangle")
        top.position = CGPoint(x: 0, y: 640)
        top.blendMode = .replace
        top.size.width = self.size.width
        top.size.height = self.size.height / 15
        addChild(top)
        

        
        
     

        //MARK: Obstacles
        let obstacle1 = SKSpriteNode(imageNamed:"redrectangle")
        obstacle1.position = CGPoint(x: 0, y:0)
        obstacle1.setScale(0.20)
        obstacle1.physicsBody?.isDynamic = false
        
        
        physicsWorld.contactDelegate = self
        
    }
    let someNode = SKNode()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let objects = nodes(at: location)
      
        if objects.contains(pauseLabel) {
            pauseMode.toggle()
        } else {
            if pauseMode {
                func restartGame() {
                    // go to other scene to restart
                    let transition:SKTransition = SKTransition.fade(withDuration: 0.001)
                    let scene:SKScene = RestartScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                    
                    
                }
                restartGame()
                
            }
                let circle = SKSpriteNode (imageNamed: "circle?")
                           circle.setScale(0.02)
                     circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width / 2)
                           circle.physicsBody?.contactTestBitMask = circle.physicsBody?.collisionBitMask ?? 0
                           circle.physicsBody?.isDynamic = false
                           circle.name = "circle"
                circle.position = location
                           addChild(circle)
        }
    }
    
    func addButton() {
    let button = SKSpriteNode(imageNamed: "redrectangle")
    button.name = "button"
    button.position = CGPoint.zero
    addChild(button)
    }
    
    
    func collisionBetween(square: SKNode, object: SKNode) {
        
        if object.name == "square" {
            print("boom")
            // 1 - Perpare system sound
            let url = Bundle.main.url(forResource: "cardflip", withExtension: "wav")!
            var sound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(url as CFURL, &sound)

            // 2 - Play system sound
            AudioServicesPlaySystemSound(sound)
            
            self.removeAllChildren()
            
            
        }
            if object.name == "circle" {
                print("boom")
                
                
                
                // 1 - Perpare system sound
                let url = Bundle.main.url(forResource: "cardflip", withExtension: "wav")!
                var sound: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(url as CFURL, &sound)

                // 2 - Play system sound
                AudioServicesPlaySystemSound(sound)
                
                
                
                
                
            }
        else if object.name == "background" {
                      print("boom")
                // 1 - Perpare system sound
                let url = Bundle.main.url(forResource: "cardflip", withExtension: "wav")!
                var sound: SystemSoundID = 0
                AudioServicesCreateSystemSoundID(url as CFURL, &sound)

                // 2 - Play system sound
                AudioServicesPlaySystemSound(sound)
                    
                 
                    
                    
                 
                    
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
