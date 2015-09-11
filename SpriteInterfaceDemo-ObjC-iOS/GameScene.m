//
//  GameScene.m
//  SpriteInterfaceDemo-ObjC-iOS
//
//  Created by Brett Bedrin on 9/10/15.
//  Copyright (c) 2015 Brett Bedrin. All rights reserved.
//

#import "GameScene.h"
#import "SIButton.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    SIButton *button = [[SIButton alloc] init];
    [button setTitleFont:@"Chalkduster" forState:SIControlStateAll];
    [button setTitle:@"Normal" forState:SIControlStateNormal];
    [button setTitle:@"Highlighted" forState:SIControlStateHighlighted];
    [button setTitle:@"Selected" forState:SIControlStateSelected];
    [button setTitleShadowColor:[SKColor grayColor] forState:SIControlStateNormal | SIControlStateSelected];
    button.position = CGPointMake(300, 300);
    [self addChild:button];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
