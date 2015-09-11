//
//  SIButton.h
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 9/8/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import "SIControl.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SIButtonLayer) {
    SIButtonLayerBackgroundTexture = 0,
    SIButtonLayerTexture,
    SIButtonLayerTitleShadow,
    SIButtonLayerTitle
};

@interface SIButton : SIControl

@property (nullable, nonatomic, readonly, copy) NSString *currentTitle;
@property (nonatomic, readonly, copy) NSString *currentTitleFont;
@property (nonatomic, readonly, strong) SKColor *currentTitleColor;
@property (nullable, nonatomic, readonly, strong) SKColor *currentTitleShadowColor;
@property (nullable, nonatomic, readonly, strong) SKTexture *currentTexture;
@property (nullable, nonatomic, readonly, strong) SKTexture *currentBackgroundTexture;

@property (nullable, nonatomic, readonly, strong) SKLabelNode *titleLabel;
@property (nullable, nonatomic, readonly, strong) SKSpriteNode *textureImage;
@property (nullable, nonatomic, readonly, strong) SKSpriteNode *backgroundTextureImage;

@property (nonatomic) CGPoint titleShadowOffset;
@property (nonatomic) CGPoint titleLabelOffset;

- (void)setTitle:(nullable NSString *)title forState:(SIControlState)state;
- (void)setTitleFont:(nullable NSString *)font forState:(SIControlState)state;
- (void)setTitleColor:(nullable SKColor *)color forState:(SIControlState)state;
- (void)setTitleShadowColor:(nullable SKColor *)color forState:(SIControlState)state;
- (void)setTexture:(nullable SKTexture *)texture forState:(SIControlState)state;
- (void)setBackgroundTexture:(nullable SKTexture *)texture forState:(SIControlState)state;

- (void)setTitle:(nullable NSString *)title withFont:(NSString *)font forState:(SIControlState)state;
- (void)setTitle:(nullable NSString *)title withFont:(NSString *)font andColor:(nullable SKColor *)color forState:(SIControlState)state;
- (void)setTitle:(nullable NSString *)title withColor:(nullable SKColor *)color forState:(SIControlState)state;
- (void)setTitle:(nullable NSString *)title withFont:(NSString *)font andBackgroundTexture:(nullable SKTexture *)texture forState:(SIControlState)state;
- (void)setTexture:(nullable SKTexture *)texture withBackgroundTexture:(nullable SKTexture *)background forState:(SIControlState)state;

- (nullable NSString *)titleForState:(SIControlState)state;
- (nullable NSString *)titleFontForState:(SIControlState)state;
- (nullable SKColor *)titleColorForState:(SIControlState)state;
- (nullable SKColor *)titleShadowColorForState:(SIControlState)state;
- (nullable SKTexture *)textureForState:(SIControlState)state;
- (nullable SKTexture *)backgroundTextureForState:(SIControlState)state;

@end

NS_ASSUME_NONNULL_END