//
//  SIButton.h
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 9/8/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import "SIControl.h"

typedef NS_ENUM(NSInteger, SIButtonLayer) {
    SIButtonLayerBackgroundTexture = 0,
    SIButtonLayerTexture,
    SIButtonLayerTitleShadow,
    SIButtonLayerTitle
};

@interface SIButton : SIControl

@property (nonatomic, readonly, copy) NSString *currentTitle;
@property (nonatomic, readonly, copy) NSString *currentTitleFont;
@property (nonatomic, readonly, strong) SKColor *currentTitleColor;
@property (nonatomic, readonly, strong) SKColor *currentShadowColor;
@property (nonatomic, readonly, strong) SKTexture *currentTexture;
@property (nonatomic, readonly, strong) SKTexture *currentBackgroundTexture;

@property (nonatomic, readonly, strong) SKLabelNode *titleLabel;
@property (nonatomic, readonly, strong) SKSpriteNode *textureImage;
@property (nonatomic, readonly, strong) SKSpriteNode *backgroundTextureImage;

@property (nonatomic) CGPoint titleShadowOffset;
@property (nonatomic) CGPoint titleLabelOffset;

- (void)setTitle:(NSString *)title forState:(SIControlState)state;
- (void)setTitleFont:(NSString *)font forState:(SIControlState)state;
- (void)setTitleColor:(SKColor *)color forState:(SIControlState)state;
- (void)setTitleShadowColor:(SKColor *)color forState:(SIControlState)state;
- (void)setTexture:(SKTexture *)texture forState:(SIControlState)state;
- (void)setBackgroundTexture:(SKTexture *)texture forState:(SIControlState)state;

- (NSString *)titleForState:(SIControlState)state;
- (NSString *)titleFontForState:(SIControlState)state;
- (SKColor *)titleColorForState:(SIControlState)state;
- (SKColor *)titleShadowColorForState:(SIControlState)state;
- (SKTexture *)textureForState:(SIControlState)state;
- (SKTexture *)backgroundTextureForState:(SIControlState)state;

@end
