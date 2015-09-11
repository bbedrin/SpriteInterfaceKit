//
//  GameScene.swift
//  SpriteInterfaceDemo-Swift-iOS
//
//  Created by Brett Bedrin on 9/10/15.
//  Copyright (c) 2015 Brett Bedrin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {

        let button = SIButton()
        button.setTitleFont("Chalkduster", forState: SIControlState.All)
        button.setTitle("Normal", forState: SIControlState.Normal)
        button.setTitle("Highlighted", forState: SIControlState.Highlighted)
        button.setTitle("Selected", forState: SIControlState.Selected)
        button.setTitleShadowColor(SKColor.grayColor(), forState: [SIControlState.Normal, SIControlState.Selected])
        button.position = CGPointMake(300, 300)
        addChild(button)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
