//
//  SIButton.m
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 9/8/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import "SIButton.h"

@interface SIButton()

@property (nonatomic, strong) NSMutableDictionary *buttonDisplayInfoDictionary;

@property (nonatomic, readwrite, copy) NSString *currentTitle;
@property (nonatomic, readwrite, copy) NSString *currentTitleFont;
@property (nonatomic, readwrite, strong) SKColor *currentTitleColor;
@property (nonatomic, readwrite, strong) SKColor *currentTitleShadowColor;
@property (nonatomic, readwrite, strong) SKTexture *currentTexture;
@property (nonatomic, readwrite, strong) SKTexture *currentBackgroundTexture;

@property (nonatomic, readwrite, strong) SKLabelNode *titleLabel;
@property (nonatomic, strong) SKLabelNode *shadowLabel;
@property (nonatomic, readwrite, strong) SKSpriteNode *textureImage;
@property (nonatomic, readwrite, strong) SKSpriteNode *backgroundTextureImage;

- (void)updateFlagsForState:(SIControlState)state;
- (void)updateButtonDisplayDictionary:(NSString *)dictionary withObject:(id)object forState:(SIControlState)state;

@end

@implementation SIButton

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)setCurrentTitle:(NSString *)currentTitle {
    if (_currentTitle != currentTitle) {
        _currentTitle = currentTitle;
        if (_titleLabel) {
            _titleLabel.text = currentTitle;
            _titleLabel.hidden = false;
        } else {
            if (_currentTitleFont) {
                _titleLabel = [[SKLabelNode alloc] initWithFontNamed:_currentTitleFont];
                _titleLabel.zPosition = SIButtonLayerTitle;
                _titleLabel.text = currentTitle;
                _titleLabel.position = CGPointMake(_titleLabelOffset.x, _titleLabelOffset.y);
                [self addChild:_titleLabel];
            } else {
                NSLog(@"Cannot set title without font! Please use setTitleFontForState: for at least one state");
            }
        }
        if (_shadowLabel) {
            _shadowLabel.text = currentTitle;
            _shadowLabel.hidden = false;
        }
    }
}

- (void)setCurrentTitleFont:(NSString *)currentTitleFont {
    if (_currentTitleFont != currentTitleFont) {
        _currentTitleFont = currentTitleFont;
        if (_titleLabel) {
            _titleLabel.fontName = currentTitleFont;
        }
        if (_shadowLabel) {
            _shadowLabel.fontName = currentTitleFont;
        }
    }
}

- (void)setCurrentTitleColor:(UIColor *)currentTitleColor {
    if (_currentTitleColor != currentTitleColor) {
        _currentTitleColor = currentTitleColor;
        if (_titleLabel) {
            _titleLabel.fontColor = currentTitleColor;
        }
    }
}

- (void)setCurrentTitleShadowColor:(UIColor *)currentTitleShadowColor {
    if (_currentTitleShadowColor != currentTitleShadowColor) {
        _currentTitleShadowColor = currentTitleShadowColor;
        if (_titleLabel) {
            if (_shadowLabel) {
                _shadowLabel.hidden = false;
                _shadowLabel.fontColor = currentTitleShadowColor;
            } else {
                _shadowLabel = [[SKLabelNode alloc] initWithFontNamed:_currentTitleFont];
                _shadowLabel.fontColor = currentTitleShadowColor;
                _shadowLabel.zPosition = SIButtonLayerTitleShadow;
                _shadowLabel.text = _titleLabel.text;
                _shadowLabel.position = CGPointMake(_titleLabel.position.x + _titleShadowOffset.x, _titleLabel.position.y + _titleShadowOffset.y);
                [self addChild:_shadowLabel];
            }
        } else {
            NSLog(@"Cannot set title shadow without title! Please use setTitleForState: for at least one state");
        }
    }
}

- (void)setCurrentTexture:(SKTexture *)currentTexture {
    if (_currentTexture != currentTexture) {
        _currentTexture = currentTexture;
        if (_textureImage) {
            _textureImage.texture = currentTexture;
            _textureImage.hidden = false;
        } else {
            _textureImage = [[SKSpriteNode alloc] initWithTexture:currentTexture];
            _textureImage.zPosition = SIButtonLayerTexture;
            [self addChild:_textureImage];
        }
    }
}

- (void)setCurrentBackgroundTexture:(SKTexture *)currentBackgroundTexture {
    if (_currentBackgroundTexture != currentBackgroundTexture) {
        _currentBackgroundTexture = currentBackgroundTexture;
        if (_backgroundTextureImage) {
            _backgroundTextureImage.texture = currentBackgroundTexture;
            _backgroundTextureImage.hidden = false;
        } else {
            _backgroundTextureImage = [[SKSpriteNode alloc] initWithTexture:currentBackgroundTexture];
            _backgroundTextureImage.zPosition = SIButtonLayerBackgroundTexture;
            [self addChild:_backgroundTextureImage];
        }
    }
}

- (void)updateFlagsForState:(SIControlState)state {
    self.allowHighlightedState = (state & SIControlStateHighlighted) ? true : false;
    self.allowSelectedState = (state & SIControlStateSelected) ? true : false;
}

- (void)updateButtonDisplayDictionary:(NSString *)dictionary withObject:(id)object forState:(SIControlState)state {
    if (!_buttonDisplayInfoDictionary) {
        _buttonDisplayInfoDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSUInteger index = 0; index < 4; index++) {
        SIControlEvent event = 1 << index;
        if (event & state) {
            [dict setObject:[NSString stringWithFormat:@"%lu", (unsigned long)event] forKey:object];
        }
    }
    _buttonDisplayInfoDictionary[dictionary] = dict;
}

- (void)controlStateDidUpdate:(SIControlState)state {
    _currentTitleFont = [self titleFontForState:state];
    _currentTitle = [self titleForState:state];
    _currentTitleColor = [self titleColorForState:state];
    _currentShadowColor = [self titleShadowColorForState:state];
    _currentTexture = [self textureForState:state];
    _currentBackgroundTexture = [self backgroundTextureForState:state];
    
}

#pragma mark - state dictionary setters

- (void)setTitle:(NSString *)title forState:(SIControlState)state {
    [self updateFlagsForState:state];
    [self updateButtonDisplayDictionary:@"title" withObject:title forState:state];
}

- (void)setTitleFont:(NSString *)font forState:(SIControlState)state {
    [self updateButtonDisplayDictionary:@"font" withObject:font forState:state];
}

- (void)setTitleColor:(SKColor *)color forState:(SIControlState)state {
    [self updateButtonDisplayDictionary:@"color" withObject:color forState:state];
}

- (void)setTitleShadowColor:(SKColor *)color forState:(SIControlState)state {
    [self updateButtonDisplayDictionary:@"shadow" withObject:color forState:state];
}

- (void)setTexture:(SKTexture *)texture forState:(SIControlState)state {
    [self updateFlagsForState:state];
    [self updateButtonDisplayDictionary:@"texture" withObject:texture forState:state];
}

- (void)setBackgroundTexture:(SKTexture *)texture forState:(SIControlState)state {
    [self updateFlagsForState:state];
    [self updateButtonDisplayDictionary:@"background" withObject:texture forState:state];
}

#pragma mark - state dictionary getters

- (NSString *)titleForState:(SIControlState)state {
    return (NSString *)[[_buttonDisplayInfoDictionary objectForKey:@"title"] objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)state]];
}

- (NSString *)titleFontForState:(SIControlState)state {
    return (NSString *)[[_buttonDisplayInfoDictionary objectForKey:@"font"] objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)state]];
}

- (SKColor *)titleColorForState:(SIControlState)state {
    return (SKColor *)[[_buttonDisplayInfoDictionary objectForKey:@"color"] objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)state]];
}

- (SKColor *)titleShadowColorForState:(SIControlState)state {
    return (SKColor *)[[_buttonDisplayInfoDictionary objectForKey:@"shadow"] objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)state]];
}

- (SKTexture *)textureForState:(SIControlState)state {
    return (SKTexture *)[[_buttonDisplayInfoDictionary objectForKey:@"texture"] objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)state]];
}

- (SKTexture *)backgroundTextureForState:(SIControlState)state {
    return (SKTexture *)[[_buttonDisplayInfoDictionary objectForKey:@"background"] objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)state]];
}


@end
