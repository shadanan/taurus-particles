//
//  GameScene.swift
//  TaurusParticles
//
//  Created by Shad Sharma on 10/4/15.
//  Copyright (c) 2015 Shad Sharma. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var nodes = SKNode()
    var world = SKShapeNode(rect: CGRectMake(0, 0, 1024, 768))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.addChild(world)
        world.addChild(nodes)
        
        world.strokeColor = SKColor.blackColor()
        world.fillColor = SKColor.whiteColor()
        world.zPosition = 0
        
        nodes.zPosition = 10
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.speed = 1.0
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        let node = SKShapeNode(circleOfRadius: 10)

        node.position = theEvent.locationInNode(nodes)
        node.strokeColor = SKColor.blackColor()
        node.fillColor = SKColor.redColor()
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody.mass = 1
        physicsBody.dynamic = true
        physicsBody.friction = 0
        physicsBody.restitution = 0
        physicsBody.allowsRotation = false
        physicsBody.collisionBitMask = 1
        node.physicsBody = physicsBody
        
        nodes.addChild(node)
    }
    
    override func update(currentTime: CFTimeInterval) {
        let kp = Float(10000)
        
        /* compute forces on me */
        for me in nodes.children {
            me.position.x = (me.position.x + 1024) % 1024
            me.position.y = (me.position.y + 768) % 768
            
            let x1 = Float(me.position.x)
            let y1 = Float(me.position.y)
            
            var fx = Float(0)
            var fy = Float(0)
            
            /* compute forces on me due to them */
            for them in nodes.children {
                // No forces on yourself
                if me == them {
                    continue
                }
                
                let x2 = Float(them.position.x)
                let y2 = Float(them.position.y)
                
                let dx = abs(x2 - x1)
                let dy = abs(y2 - y1)
                
                let r = sqrtf(powf(dx, 2) + powf(dy, 2))
                let r2 = sqrtf(powf(1024 - dx, 2) + powf(768 - dy, 2))
                let theta = atan2f(y2 - y1, x2 - x1)
                
                let f = (kp / powf(r2, 2)) - (kp / powf(r, 2))

                fx += f * cosf(theta)
                fy += f * sinf(theta)
            }
            
            if let physicsBody = me.physicsBody {
                physicsBody.applyImpulse(CGVectorMake(CGFloat(fx), CGFloat(fy)))
            }
        }
    }
}
