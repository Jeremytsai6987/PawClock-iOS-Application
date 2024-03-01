//
//  GameManagement.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/18.
//

import SpriteKit

extension GameScene {
    // Start the game
    func startGame() {
        if gameState == .start{
            gameState = .playing
            startCountdownTimer()
            startSpawningFrisbees()
            setupScoreLabel()
            setupCountdownLabel()
            setupInfoButton()

            setupColumns()
            setupBottomArea()
            setupHitZone()
            setupCircles()
            startButton?.removeFromParent()
            startButtonBackground.removeFromParent() // Now accessible
            setupbackhomebutton()




            let background = SKSpriteNode(imageNamed: "grass_texture")
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            background.size = self.frame.size // Make the background cover the full screen
            background.zPosition = -1 // Ensure the background is behind all other nodes
            addChild(background)

            
        }
    }
    
    // Restart the game
    
    func restartGame() {
        isPaused = false
        removeAllChildren() // Clears the scene
        removeAllActions()
        score = 0 // Reset score
        currentLevel = 1
        countdown = 30 // Reset countdown
        gameState = .start
        startGame()
    }

    // Game over

    func gameOver() {
        print(score)
        DataManager.shared.saveScore(score)
        gameState = .gameOver
        countdownTimer?.invalidate()
        countdownTimer = nil
        countdownLabel?.removeFromParent()
        print("Game over called")
        if countdownBackground?.parent != nil {
            print("Removing countdownBackground from parent")
            countdownBackground?.removeFromParent()
        } else {
            print("countdownBackground was nil or had no parent")
        }

    
        removeAction(forKey: "spawningFrisbees")
        
        self.children.forEach { node in
            if let physicsBody = node.physicsBody, physicsBody.categoryBitMask == PhysicsCategory.frisbee {
                node.removeFromParent()
            }
        }

    }
    

    // Setup for the next level
    func setupForNextLevel() {
        removeAllChildren()
        removeAllActions()
        gameState = .start
        setupColumns()
        setupBottomArea()
        setupHitZone()
        setupCircles()
        setupInfoButton()
    }

    // Show level transition

    func showLevelTransition() {
        // Ensure game is paused during transition
        self.isPaused = true

        let levelBackground = SKSpriteNode(imageNamed: "level.png")
        let levelLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        let countdownLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        // Configuration for levelBackground, levelLabel, and countdownLabel goes here...
        levelBackground.position = CGPoint(x: frame.midX, y: frame.midY-60)
        levelBackground.zPosition = 100
        // Set the size of the level background
        levelBackground.size = CGSize(width: 350, height: 475) // Adjust width and height as needed
        addChild(levelBackground)
        
        levelLabel.fontSize = 30
        levelLabel.fontColor = SKColor.black
        levelLabel.text = "Level \(currentLevel)"
        levelLabel.position = CGPoint(x: frame.midX - 100, y: frame.midY - 70)
        levelLabel.zPosition = 101
        addChild(levelLabel)
        
        countdownLabel.fontSize = 20
        countdownLabel.fontColor = SKColor.black
        countdownLabel.position = CGPoint(x: frame.midX - 100, y: frame.midY - 20)
        countdownLabel.zPosition = 101
        addChild(countdownLabel)
        
        self.children.forEach { node in
            if let physicsBody = node.physicsBody, physicsBody.categoryBitMask == PhysicsCategory.frisbee {
                node.removeFromParent()
            }
        }

        var countdown = 5
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdown -= 1
            countdownLabel.text = "Starting in \(countdown)"
            
            if countdown <= 0 {
                timer.invalidate()
                DispatchQueue.main.async {
                    levelBackground.removeFromParent()
                    levelLabel.removeFromParent()
                    countdownLabel.removeFromParent()
                    
                    // Now resume the game setup for the next level
                    self.setupForNextLevel()
                    self.isPaused = false // Unpause the game after setup is complete
                    // Optionally start the game or level here if more setup is needed
                    self.startGame() // Make sure this method configures the game for the new level without resetting everything unnecessarily
                }
            }
        }
    }
    
    // Show the Game Over screen
    
    func showGameOver(withMessage message: String) {
        gameOver()
        isPaused = true

        // Background setup for gameOverLabel and highScoresLabel
        let background = SKSpriteNode(imageNamed: "verticalboard.png")
        background.size = CGSize(width: 400, height: 600) // Adjust size as needed
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = 0
        addChild(background)

        // Game Over label setup
        let gameOverLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        gameOverLabel.text = message
        gameOverLabel.fontSize = 25
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: 0, y: 175)
        gameOverLabel.zPosition = 1
        background.addChild(gameOverLabel)

        // Call function to display high scores directly under the gameOverLabel
        displayHighScores(on: background, under: gameOverLabel)

        // Setup Restart button below the background
        setupRestartButton(below: background)
    }

    // display high scores (Top 10 scores) on the Game Over screen
    func displayHighScores(on background: SKSpriteNode, under gameOverLabel: SKLabelNode) {
        let scores = DataManager.shared.getScores() // Fetch the scores
        let highScoresLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        highScoresLabel.fontSize = 25
        highScoresLabel.fontColor = SKColor.black
        // Position highScoresLabel directly under the gameOverLabel
        let yPositionUnderGameOverLabel = gameOverLabel.position.y - 345 // Adjust based on your layout
        highScoresLabel.position = CGPoint(x: 0, y: yPositionUnderGameOverLabel)
        highScoresLabel.zPosition = 1
        highScoresLabel.numberOfLines = 0 // Enable multiline text

        // Prepare the high scores text
        let scoresText = scores.enumerated().map { index, score in
            "\(index + 1). \(score)"
        }.joined(separator: "\n")

        highScoresLabel.text = "Top Scores:\n\(scoresText)"

        background.addChild(highScoresLabel)
    }


}
