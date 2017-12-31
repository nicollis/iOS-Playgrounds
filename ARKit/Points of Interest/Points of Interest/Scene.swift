//
//  Scene.swift
//  Points of Interest
//
//  Created by Nic Ollis on 12/29/17.
//  Copyright © 2017 Ollis. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let hit = nodes(at: touch.location(in: self))

        guard let label = hit.first as? SKShapeNode ?? hit.first?.parent as? SKShapeNode else { return }
    
        let scaleOut = SKAction.scale(to: 0.5, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleOut, fadeOut])
        let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
        label.run(sequence)
    }
}
