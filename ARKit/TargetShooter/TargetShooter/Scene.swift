//
//  Scene.swift
//  TargetShooter
//
//  Created by Nic Ollis on 12/29/17.
//  Copyright © 2017 Ollis. All rights reserved.
//

import SpriteKit
import ARKit
import GameplayKit

class Scene: SKScene {
    
    // Mark: Scene Properties
    
    let remainingLabel = SKLabelNode()
    var timer: Timer?
    var targetsCreated = 0
    var targetCount = 0 {
        didSet {
            remainingLabel.text = "Remaining: \(targetCount) | Score: \(playerScore)"
        }
    }
    let startTime = Date()
    let targetDistanceRandomizer = GKRandomDistribution(lowestValue: -5, highestValue: -1)
    var targetExpireTimers = [UUID: Timer?]()
    var lastTargetHitTime = Date()
    
    var playerScore: Int = 0
    
    // Mark: Instance Methods
    
    func createTarget() {
        if targetsCreated == 20 {
            timer?.invalidate()
            timer = nil
            return
        }
        
        targetsCreated += 1
        targetCount += 1
        
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        let random = GKRandomSource.sharedRandom()
        
        // create a random X rotation
        let xRotation = simd_float4x4(SCNMatrix4MakeRotation(Float.pi * 2 * random.nextUniform(), 1, 0, 0))
        
        // create a random Y rotation
        let yRotation = simd_float4x4(SCNMatrix4MakeRotation(Float.pi * 2 * random.nextUniform(), 0, 1, 0))
        
        let rotation = simd_mul(xRotation, yRotation)
        
        // move the anchor 1.5m out
        var translation = matrix_identity_float4x4
        translation.columns.3.z = targetDistanceRandomizer.nextUniform()
        
        let transform = simd_mul(rotation, translation)
        
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
        
        targetExpireTimers[anchor.identifier] = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] (timer) in
            if let node = sceneView.node(for: anchor) {
                node.removeFromParent()
                self?.targetCount -= 1
                self?.playerScore -= 100
                if self?.targetCount == 0 && self?.targetsCreated == 20 { self?.gameOver() }
            } else {
                print("node does not exist")
            }
        }
    }
    
    func gameOver() {
        remainingLabel.removeFromParent()
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        addChild(gameOver)
        
        let timeTaken = Date().timeIntervalSince(startTime)
        let timeLabel = SKLabelNode(text: "Time taken: \(Int(timeTaken)) seconds | Total Score: \(playerScore)")
        timeLabel.fontSize = 36
        timeLabel.fontName = "AmericanTypewriter"
        timeLabel.color = .white
        timeLabel.position = CGPoint(x: 0, y: -view!.frame.midY + 50)
        
        addChild(timeLabel)
        
    }
    
    // Mark: SKScene Methods
    
    override func didMove(to view: SKView) {
        // Setup your scene here
        remainingLabel.fontName = "AmericanTypewriter"
        remainingLabel.fontSize = 36
        remainingLabel.color = .white
        remainingLabel.position = CGPoint(x: 0, y: view.frame.midY - 50)
        addChild(remainingLabel)
        targetCount = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [unowned self] (timer) in
            self.createTarget()
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let sceneView = self.view as? ARSKView else { return }
        
        let location = touch.location(in: self)
        let hit = nodes(at: location)
        
        if let sprite = hit.first {
            if let anchorId = sceneView.anchor(for: sprite)?.identifier, let targetTimer = targetExpireTimers[anchorId] {
                targetTimer?.invalidate()
                targetExpireTimers[anchorId] = nil
            }
            
            
            let scaleOut = SKAction.scale(to: 2, duration: 0.2)
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let group = SKAction.group([scaleOut, fadeOut])
            let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
            sprite.run(sequence)
            
            targetCount -= 1
            print("Time: \(Double(Date().timeIntervalSince(lastTargetHitTime)))")
            playerScore += Double(Date().timeIntervalSince(lastTargetHitTime)) < 0.6 ? 300 : 200
            lastTargetHitTime = Date()
            
            if targetsCreated == 20 && targetCount == 0 {
                gameOver()
            }
        }
    }
}
