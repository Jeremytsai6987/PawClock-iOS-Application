//
//  GameControls.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/18.
//

import SpriteKit

extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodesAtLocation = nodes(at: location)

            for node in nodesAtLocation {
                handleTouchOnNode(node)
            }
        }
    }
    
    private func handleTouchOnNode(_ node: SKNode) {
        if node.name == "startButton" {
            // If the game state is .start, handle the start button press
            if gameState == .start {
                startGame()
            }
        } else if node.name == "restart" {
            // Handle game restart
            restartGame()
        } else if node.name == "circle" {
            // Handle circle animation, if applicable
            animateCircle(node: node)
        } else if node.name == "infoButton" {
            // User tapped the info button, show the instructions
            self.isPaused = true

            showHowToPlay()
        } else if node.name == "closeInstructions" {
            // User tapped the close button on the instructions overlay
            self.isPaused = false
            self.childNode(withName: "instructionsOverlay")?.removeFromParent() // Remove the overlay
        } else if node.name == "backButton"{
            onButtonTap?()
        } else if let spriteNode = node as? SKSpriteNode, spriteNode.physicsBody?.categoryBitMask == PhysicsCategory.frisbee {
            // Handle frisbee touches, increase score and remove the frisbee
            score += 1
            
            // Play sound effect
            let playSound = SKAction.playSoundFileNamed("punch.mp3", waitForCompletion: false)
            spriteNode.run(playSound) {
                spriteNode.removeFromParent()
            }
        }
    }
    
}
