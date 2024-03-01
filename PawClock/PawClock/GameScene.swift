//
//  GameScene.swift
//
//
//  Created by Ya Wei Tsai on 2024/2/14.
//
import SpriteKit
import AVFoundation



class GameScene: SKScene, SKPhysicsContactDelegate {
    var safeAreaInsets: UIEdgeInsets = .zero
    var countdown: Int = 10
    var currentLevel: Int = 1
    var countdownTimer: Timer?
    var columnPositions: [CGFloat] = []
    var scoreLabel: SKLabelNode?
    var startButton: SKLabelNode!
    var startButtonBackground: SKSpriteNode!
    var onButtonTap: (() -> Void)?
    var confirmationOverlay: SKNode?
    var countdownLabel: SKLabelNode?
    var countdownBackground: SKSpriteNode!
    var scoreUpdated: ((Int) -> Void)?
    var gameState: GameState = .start
    private var spawnRate: TimeInterval = 2.0 // Starting spawn rate
    
    var score: Int = 0 {
        didSet {
            scoreUpdated?(score)
            adjustSpawnRate()
        }
    }
    override func willMove(from view: SKView) {
        print("GameScene will move from view. Stopping background music.")
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }

    
    var backgroundMusicPlayer: AVAudioPlayer?

    override func didMove(to view: SKView) {
        gameState = .start
        setupInfoButton()
        setupStartButton()

        let background = SKSpriteNode(imageNamed: "grass_texture")
        self.view?.isMultipleTouchEnabled = true
        background.position = CGPoint(x: frame.midX, y: frame.midY)

        background.size = self.frame.size
        background.zPosition = -1
        addChild(background)
        
        
        setupbackhomebutton()

        scoreUpdated = { [weak self] newScore in
            self?.scoreLabel?.text = "Score: \(newScore)"
        }
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        self.physicsWorld.contactDelegate = self
        
        if backgroundMusicPlayer == nil {
            setupBackgroundMusic()
        }
        
        setupColumns()
        setupBottomArea()
        setupHitZone()
        setupCircles()
    }
    

    // Check the score and proceed to the next level or game over
    func checkScoreAndProceed() {
        countdownTimer?.invalidate()

        if score < 15 {
            gameState = .gameOver
            showGameOver(withMessage: "Game Over! Score: \(score)")
        } else if score >= 15 * currentLevel {
            currentLevel += 1
            showLevelTransition()
        } else {
            showGameOver(withMessage: "So close! Score: \(score)")
        }
    }

    // Function to spawen the frisbee
   @objc func spawnFrisbee() {
        let frisbeesToSpawn = Int.random(in: 1...2)
        
        for _ in 0..<frisbeesToSpawn {
            let randomColumnIndex = Int.random(in: 0..<columnPositions.count)
            let frisbeeXPosition = columnPositions[randomColumnIndex]
            
            let frisbee = SKSpriteNode(imageNamed: "frisbee")
            frisbee.size = CGSize(width: 60, height: 60)
            frisbee.position = CGPoint(x: frisbeeXPosition, y: size.height + frisbee.size.height / 2)
            frisbee.physicsBody = SKPhysicsBody(circleOfRadius: frisbee.size.width / 2)
            frisbee.physicsBody?.isDynamic = true
            frisbee.physicsBody?.categoryBitMask = PhysicsCategory.frisbee
            frisbee.physicsBody?.contactTestBitMask = PhysicsCategory.hitZone
            frisbee.physicsBody?.collisionBitMask = PhysicsCategory.none
            frisbee.zPosition = 20
            
            addChild(frisbee)
        }
    }
    // Adjust the spawn rate of the frisbee
   func adjustSpawnRate() {
        spawnRate = max(0.3, 0.5 - Double(score) / 50 * 0.1)
        startSpawningFrisbees()
    }
    
    // Start spawning the frisbee
    func startSpawningFrisbees() {
        removeAction(forKey: "spawningFrisbees")
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnFrisbee()
        }
        let waitAction = SKAction.wait(forDuration: spawnRate)
        run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])), withKey: "spawningFrisbees")
    }

    


}


