//
//  GameElements.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/18.
//

import SpriteKit

extension GameScene {
    // Create a label with a background
    func createLabelBackground(imageNamed imageName: String, size: CGSize, position: CGPoint, zPosition: CGFloat) -> SKSpriteNode {
        let backgroundSprite = SKSpriteNode(imageNamed: imageName)
        backgroundSprite.size = size
        backgroundSprite.position = position
        backgroundSprite.zPosition = zPosition
        addChild(backgroundSprite)
        return backgroundSprite
    }
    // Set up the score label
    func setupScoreLabel() {
        let backgroundSize = CGSize(width: 300, height: 60)
        let backgroundPosition = CGPoint(x: frame.midX, y: frame.height - backgroundSize.height * 2)
        let scoreBackground = createLabelBackground(imageNamed: "board.png", size: backgroundSize, position: backgroundPosition, zPosition: 10)
        
        if scoreLabel == nil {
            scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
            scoreLabel!.fontSize = 24
            scoreLabel!.fontColor = SKColor.black
            scoreLabel!.horizontalAlignmentMode = .center
            scoreLabel!.verticalAlignmentMode = .center
            scoreLabel!.position = CGPoint.zero // Centered in the background
            scoreLabel!.zPosition = 11
            scoreBackground.addChild(scoreLabel!)
        }
        scoreLabel!.text = "Score: \(score)"
        
        if scoreLabel!.parent == nil {
            scoreBackground.addChild(scoreLabel!)
        }
    }
    // Add the label background
    func addLabelBackground(label: SKLabelNode, backgroundColor: SKColor, padding: CGFloat = 10) {
        // Calculate background size based on label size and padding
        let backgroundSize = CGSize(width: label.frame.size.width + padding * 2, height: label.frame.size.height + padding * 2)
        let background = SKShapeNode(rectOf: backgroundSize, cornerRadius: 10)
        background.fillColor = backgroundColor.withAlphaComponent(0.9)
        background.strokeColor = SKColor.clear
        
        // Adjust background position
        background.position = CGPoint(x: label.position.x, y: label.position.y - label.frame.size.height / 2 + backgroundSize.height / 2)
        background.zPosition = label.zPosition - 1
        addChild(background)
        
        // Ensure label is in front of its background
        label.removeFromParent()
        
        // Add the label as a child of the background for relative positioning
        background.addChild(label)
        
        // Center label in the background
        label.position = CGPoint(x: 0, y: -label.frame.size.height / 2 + padding)
    }
    
    // Set up the start button
    func setupStartButton() {
        startButtonBackground = SKSpriteNode(imageNamed: "board.png")
        startButtonBackground.size = CGSize(width: 600, height: 120)
        startButtonBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startButtonBackground.zPosition = 0
        addChild(startButtonBackground)
        
        // Initialize the startButton
        startButton = SKLabelNode(fontNamed: "Chalkduster")
        startButton!.text = "Start Game"
        startButton!.fontSize = 40
        startButton!.fontColor = SKColor.black
        startButton!.position = CGPoint(x: 0, y: -20)
        startButton!.zPosition = 1
        startButton.name = "startButton"
        startButtonBackground.addChild(startButton!)
        
    }
    
    // Set up the number of columns that the frisbees will be thrown from
    func setupColumns() {
        let numberOfColumns = 5
        let columnWidth = size.width / CGFloat(numberOfColumns)
        
        for column in 0..<numberOfColumns {
            let columnCenter = (CGFloat(column) * columnWidth) + (columnWidth / 2)
            columnPositions.append(columnCenter)
        }
    }
    
    
    // Set up the countdown label
    func setupCountdownLabel() {
        let backgroundSize = CGSize(width: 500, height: 80)
        let backgroundPosition = CGPoint(x: frame.midX, y: frame.height - backgroundSize.height * 3)
        countdownBackground = createLabelBackground(imageNamed: "board.png", size: backgroundSize, position: backgroundPosition, zPosition: 10)
        
        if countdownLabel == nil {
            countdownLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
            countdownLabel?.fontSize = 24
            countdownLabel?.fontColor = SKColor.black
            countdownLabel?.horizontalAlignmentMode = .center
            countdownLabel?.verticalAlignmentMode = .center
            countdownLabel?.position = CGPoint.zero // Centered in the background
            countdownLabel?.zPosition = 11
            countdownBackground.addChild(countdownLabel!)
        }
        countdownLabel?.text = "Time: \(countdown) Level: \(currentLevel)"
        
        if countdownLabel?.parent == nil {
            countdownBackground.addChild(countdownLabel!)
        }
        
    }
    
    // Set up the bottom area where the frisbees will be caught
    func setupBottomArea() {
        let bottomArea = SKNode()
        bottomArea.position = CGPoint(x: frame.midX, y: 10) // Positioned at the bottom
        bottomArea.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 20))
        bottomArea.physicsBody?.isDynamic = false
        bottomArea.physicsBody?.categoryBitMask = PhysicsCategory.hitZone
        bottomArea.physicsBody?.contactTestBitMask = PhysicsCategory.frisbee
        bottomArea.physicsBody?.collisionBitMask = PhysicsCategory.none
        addChild(bottomArea)
    }
    
    // Launch the countdown timer
    func startCountdownTimer() {
        countdown = 30 // Reset the countdown for each level
        countdownTimer?.invalidate() // Invalidate any existing timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    // Update the time
    @objc func updateCountdown() {
        countdown -= 1
        countdownLabel?.text = "Time: \(countdown) Level: \(currentLevel)"
        
        if countdown <= 0 {
            countdownTimer?.invalidate()
            checkScoreAndProceed()
        }
    }
    
    // Set up the restart button
    func setupRestartButton(below background: SKSpriteNode) {
        // Position the restart button below the background
        let positionY = background.position.y - background.size.height / 2 + 30 // Adjust as needed

        let restartButtonBackground = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10) // Adjust size as needed
        restartButtonBackground.fillColor = SKColor.black

        restartButtonBackground.position = CGPoint(x: frame.midX, y: positionY)
        restartButtonBackground.zPosition = 0
        restartButtonBackground.name = "restart"
        addChild(restartButtonBackground)

        let restartLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        restartLabel.text = "Tap to Restart"
        restartLabel.fontSize = 25 // Adjust font size as needed
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: 0, y: -10) // Centered within restartButtonBackground
        restartLabel.zPosition = 1
        restartButtonBackground.addChild(restartLabel)
    }

    // Set up the hit zone
    func setupHitZone() {
        let hitZoneSize = CGSize(width: frame.width, height: 100) // Adjust the height as needed
        let hitZonePosition = CGPoint(x: frame.midX, y: 10 + hitZoneSize.height / 2) // Positioned at the bottom

        let hitZoneTexture = SKTexture(imageNamed: "hitzone")
        let visualHitZoneSize = CGSize(width: hitZoneSize.width * 2.5, height: hitZoneSize.height * 4) // Example: 20% larger

        let hitZoneArea = SKSpriteNode(texture: hitZoneTexture, size: visualHitZoneSize)

        hitZoneArea.position = hitZonePosition
        hitZoneArea.physicsBody = SKPhysicsBody(rectangleOf: hitZoneSize)
        hitZoneArea.physicsBody?.isDynamic = false
        hitZoneArea.physicsBody?.categoryBitMask = PhysicsCategory.hitZone
        hitZoneArea.physicsBody?.contactTestBitMask = PhysicsCategory.frisbee
        hitZoneArea.physicsBody?.collisionBitMask = PhysicsCategory.none

        addChild(hitZoneArea)
    }

    // Set up the button to catch frisbees
    func setupCircles() {
        let circleRadius: CGFloat = 30
        for xPos in columnPositions {
            // Create a sprite node with the claw image
            let clawNode = SKSpriteNode(imageNamed: "claw")
            clawNode.size = CGSize(width: 65, height: 65)
            clawNode.position = CGPoint(x: xPos, y: circleRadius * 2)
            clawNode.name = "circle"
            addChild(clawNode)
        }
    }
    // Animate the circle when tapped
    func animateCircle(node: SKNode) {
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.1) // Zoom in
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1) // Zoom out
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        node.run(sequence)
    }
    
    // Set up the info button
    func setupInfoButton() {
        // Assuming you have an info button image named "info_icon.png"
        let infoButton = SKSpriteNode(imageNamed: "info_icon")

        infoButton.name = "infoButton"
        // Position the info button at the top right corner
        infoButton.size = CGSize(width: 40, height: 40)

        infoButton.position = CGPoint(x: self.size.width - infoButton.size.width / 2 - 20, y: self.size.height - infoButton.size.height / 2 - 65)
        infoButton.size = CGSize(width: 50, height: 50)

        infoButton.zPosition = 50 // Make sure it's above other nodes
        self.addChild(infoButton)
    }

    // Show the info how to play
    func showHowToPlay() {
        // Create a semi-transparent overlay
        let instructionsOverlay = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.8), size: self.size)
        instructionsOverlay.name = "instructionsOverlay"
        instructionsOverlay.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        instructionsOverlay.zPosition = 100

        // Add instructions text
        let instructionsText = SKLabelNode(fontNamed: "Chalkduster")
        instructionsText.text = "In this thrilling game, your goal is to catch frisbees with your dog's paws by tapping accurately as the frisbee reaches the hitzone. You have 30 seconds per level to score points, with the progression threshold set at the current level multiplied by 15. Perfect your timing and reflexes to advance through levels in this fast-paced, frisbee-catching adventure."
        instructionsText.fontSize = 22
        instructionsText.fontColor = SKColor.white
        instructionsText.position = CGPoint(x: 0, y: -10)
        instructionsText.zPosition = 101
        instructionsText.numberOfLines = 0
        instructionsText.preferredMaxLayoutWidth = 300
        instructionsText.horizontalAlignmentMode = .center
        instructionsText.verticalAlignmentMode = .center

        instructionsOverlay.addChild(instructionsText)

        // Add a close button
        let texture = SKTexture(imageNamed: "close_icon")

        let closeButton = SKSpriteNode(texture: texture)
        closeButton.size = CGSize(width: 50, height: 50)

        closeButton.name = "closeInstructions"
        closeButton.position = CGPoint(x: 0, y: -instructionsOverlay.size.height / 2 + closeButton.size.height + 20)

        instructionsOverlay.addChild(closeButton)

        self.addChild(instructionsOverlay)
    }
    
    // Back to home page button
    func setupbackhomebutton(){
        
        let xOffset: CGFloat = 225
        let yOffset: CGFloat = 365
        let newPosition = CGPoint(x: -self.size.width / 2 + xOffset, y: self.size.height / 2 + yOffset)
        let button = SKLabelNode(text: "Back Home")
        button.name = "backButton"
        button.fontName = "Chalkduster"
        button.fontColor = .black
        button.fontSize = 17
        button.position = newPosition
        button.horizontalAlignmentMode = .left
        button.verticalAlignmentMode = .top

        addChild(button)
    }

}
