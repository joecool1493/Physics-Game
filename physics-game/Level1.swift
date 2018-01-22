//
//  Level1.swift
//  physics-game
//
//  Created by Joey Newfield on 1/21/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation


class Level1: SKScene, SKPhysicsContactDelegate {
    
    var gameIsPlaying = true
    
    var backgroundMusicPlayer = AVAudioPlayer()
    var timer = Timer()
    var timeRemaining = 10
    let timerLabel = SKLabelNode(fontNamed: "Menlo")
    
    let bowlingBall = SKSpriteNode(imageNamed: "bowlingBall")
    let redButton = SKSpriteNode(imageNamed: "redButton")
    let horizontalBlock = SKSpriteNode(imageNamed: "horizontalBlock")
    let verticalBlock1 = SKSpriteNode(imageNamed: "verticalBlock")
    let verticalBlock2 = SKSpriteNode(imageNamed: "verticalBlock")
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.red
        
        playBackgroundMusic()
        setUpTimerLabel()
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        
        let playableRectangle = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin * 2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRectangle)
        physicsWorld.contactDelegate = self
        physicsBody?.categoryBitMask = PhysicsCategory.Edge
        
        setupBackground()
        setupNodes()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if !gameIsPlaying {
            return
        }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Ball | PhysicsCategory.Block {
            
            print("Ball Hit Block")
        }
        
        if collision == PhysicsCategory.Ball | PhysicsCategory.Edge {
            
            print("Ball Hit Edge")
            lose()
        }
        
        if collision == PhysicsCategory.Ball | PhysicsCategory.Switch {
            
            print("Ball Hit Switch")
            win()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            if touchedNode.name == "ball" {
                
                bowlingBall.physicsBody?.affectedByGravity = true
                
            }
            
            if touchedNode.name == "block" {
                
                run(SKAction.playSoundFileNamed("popSound.mp3", waitForCompletion: false))
                
                let scaleDown = SKAction.scale(to: 0.0, duration: 0.15)
                let remove = SKAction.removeFromParent()
                
                let sequence = SKAction.sequence([scaleDown, remove])
                
                touchedNode.run(sequence)
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateTimerLabel()
    }
    
    func setupBackground() {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.setScale(0.7)
        background.zPosition = -10
        addChild(background)
    }
    
    func setupNodes() {
        
        bowlingBall.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.85)
        bowlingBall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bowlingBall.setScale(0.5)
        bowlingBall.zPosition = 1
        bowlingBall.name = "ball"
        bowlingBall.physicsBody = SKPhysicsBody(circleOfRadius: bowlingBall.size.width / 2)
        bowlingBall.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        bowlingBall.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Block
        bowlingBall.physicsBody?.contactTestBitMask = PhysicsCategory.Edge | PhysicsCategory.Switch | PhysicsCategory.Block
        bowlingBall.physicsBody?.affectedByGravity = false
        addChild(bowlingBall)
        
        redButton.position = CGPoint(x: self.size.width / 2, y: 20)
        redButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        redButton.setScale(0.6)
        redButton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        redButton.physicsBody?.affectedByGravity = false
        redButton.physicsBody?.isDynamic = false
        redButton.physicsBody?.categoryBitMask = PhysicsCategory.Switch
        addChild(redButton)
        
        verticalBlock1.position = CGPoint(x: self.size.width / 2 - redButton.size.width / 2 - verticalBlock1.size.width / 2 + 25, y: verticalBlock1.size.height / 2)
        verticalBlock1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        verticalBlock1.setScale(1.0)
        verticalBlock1.name = "block"
        verticalBlock1.physicsBody = SKPhysicsBody(rectangleOf: verticalBlock1.frame.size)
        verticalBlock1.physicsBody?.categoryBitMask = PhysicsCategory.Block
        addChild(verticalBlock1)
        
        verticalBlock2.position = CGPoint(x: self.size.width / 2 + redButton.size.width / 2 + verticalBlock2.size.width / 2 - 25, y: verticalBlock2.size.height / 2)
        verticalBlock2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        verticalBlock2.setScale(1.0)
        verticalBlock2.name = "block"
        verticalBlock2.physicsBody = SKPhysicsBody(rectangleOf: verticalBlock2.frame.size)
        verticalBlock2.physicsBody?.categoryBitMask = PhysicsCategory.Block
        addChild(verticalBlock2)
        
        horizontalBlock.position = CGPoint(x: self.size.width / 2, y: verticalBlock1.size.height + horizontalBlock.size.height / 2)
        horizontalBlock.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        horizontalBlock.setScale(1.0)
        horizontalBlock.name = "block"
        horizontalBlock.physicsBody = SKPhysicsBody(rectangleOf: horizontalBlock.frame.size)
        horizontalBlock.physicsBody?.categoryBitMask = PhysicsCategory.Block
        addChild(horizontalBlock)
        
    }
    
    func win() {
        
        gameIsPlaying = false
        timer.invalidate()
        
        backgroundMusicPlayer.stop()
        run(SKAction.playSoundFileNamed("youWinSound.mp3", waitForCompletion: false))
        
        
        let winLabel = SKLabelNode(fontNamed: "Menlo")
        
        winLabel.position = CGPoint(x: self.size.width / 2, y: -300)
        winLabel.zPosition = 10
        winLabel.fontColor = SKColor.white
        winLabel.fontSize = 125
        winLabel.horizontalAlignmentMode = .center
        winLabel.verticalAlignmentMode = .center
        winLabel.text = "You Win!"
        addChild(winLabel)
        
        let labelAnimation = SKAction.moveTo(y: self.size.height / 2, duration: 1.0)
        let wait = SKAction.wait(forDuration: 2.5)
        let remove = SKAction.removeFromParent()
        
        let transition = SKAction.run {
            
            let scene = Level2(size: CGSize(width: 1334, height: 750))
            scene.scaleMode = .aspectFill
            let reveal = SKTransition.flipHorizontal(withDuration: 1.0)
            
            self.view?.presentScene(scene, transition: reveal)
            
        }
        
        let labelSequence = SKAction.sequence([labelAnimation, wait, remove, transition])
        
        winLabel.run(labelSequence)
        
    }
    
    func lose() {
        
        gameIsPlaying = false
        timer.invalidate()
        
        backgroundMusicPlayer.stop()
        run(SKAction.playSoundFileNamed("youLoseSound.mp3", waitForCompletion: false))
        
        let loseLabel = SKLabelNode(fontNamed: "Menlo")
        
        loseLabel.position = CGPoint(x: self.size.width / 2, y: -300)
        loseLabel.zPosition = 10
        loseLabel.fontColor = SKColor.white
        loseLabel.fontSize = 125
        loseLabel.horizontalAlignmentMode = .center
        loseLabel.verticalAlignmentMode = .center
        loseLabel.text = "You Lose!!!"
        addChild(loseLabel)
        
        let labelAnimation = SKAction.moveTo(y: self.size.height / 2, duration: 1.0)
        let wait = SKAction.wait(forDuration: 2.5)
        let remove = SKAction.removeFromParent()
        
        let transition = SKAction.run {
            
            let scene = Level1(size: CGSize(width: 1334, height: 750))
            scene.scaleMode = .aspectFill
            let reveal = SKTransition.flipHorizontal(withDuration: 1.0)
            
            self.view?.presentScene(scene, transition: reveal)
            
        }
        
        let labelSequence = SKAction.sequence([labelAnimation, wait, remove, transition])
        
        loseLabel.run(labelSequence)
    }
    
    func playBackgroundMusic() {
        
        do {
            let path = Bundle.main.path(forResource: "physicsGameBackgroundMusic", ofType: "mp3")
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            backgroundMusicPlayer.volume = 1.0
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch {
            print("error loading audio")
        }
    }
    
    func setUpTimerLabel(){
        
        timerLabel.position = CGPoint(x: self.size.width * 0.10, y: self.size.height * 0.85)
        timerLabel.zPosition = 10
        timerLabel.fontColor = SKColor.white
        timerLabel.fontSize = 125
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.verticalAlignmentMode = .center
        timerLabel.text = "\(timeRemaining)"
        addChild(timerLabel)
        
    }
    
    func updateTimerLabel(){
        
        timerLabel.text = "\(timeRemaining)"
    }
    
    @objc func updateTimer() {
        
        timeRemaining = timeRemaining - 1
        
        if timeRemaining < 0 {
            
            timerLabel.removeFromParent()
            self.lose()
            
        }
    }
    
}

