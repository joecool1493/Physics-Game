//
//  GameScene.swift
//  physics-game
//
//  Created by Joey Newfield on 1/21/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None:    UInt32 = 0
    static let Ball:    UInt32 = 0b1 // 1
    static let Block:   UInt32 = 0b10 // 2
    static let Switch:  UInt32 = 0b100 // 4
    static let Edge:    UInt32 = 0b1000 // 8
    static let Ramp:    UInt32 = 0b10000 // 16
    static let Triangle:UInt32 = 0b100000 // 32
}

class GameScene: SKScene {
    
    var currentLevel: Int = 1
    
    override func didMove(to view: SKView) {
        
        goToCurrentLevel()
        
    }
    
    func goToCurrentLevel() {
        
        if currentLevel == 1 {
            
            let scene = Level1(size: CGSize(width: 1334, height: 750))
            scene.scaleMode = .aspectFill
            let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
            
            view?.presentScene(scene, transition: reveal)
            
        } else if currentLevel == 2 {
            
            let scene = Level2(size: CGSize(width: 1334, height: 750))
            scene.scaleMode = .aspectFill
            let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
            
            view?.presentScene(scene, transition: reveal)
            
        } else if currentLevel == 3 {
            
            let scene = Level3(size:CGSize(width: 1334, height: 750))
            scene.scaleMode = .aspectFill
            let reveal = SKTransition.flipHorizontal(withDuration: 0.2)
            
            view?.presentScene(scene, transition: reveal)
        }
        
    }
    
}




