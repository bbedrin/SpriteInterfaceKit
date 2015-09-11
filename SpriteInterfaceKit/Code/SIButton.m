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
        self.userInteractionEnabled = true;
        _currentTitleColor = [SKColor whiteColor];
        _titleLabelOffset = CGPointZero;
        _titleShadowOffset = CGPointMake(2, -2);
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


- (void)setCurrentTitleColor:(SKColor *)currentTitleColor {
    if (_currentTitleColor != currentTitleColor) {
        _currentTitleColor = currentTitleColor;
        if (_titleLabel) {
            _titleLabel.fontColor = currentTitleColor ? currentTitleColor : [SKColor clearColor];           
        }
    }
}

- (void)setCurrentTitleShadowColor:(SKColor *)currentTitleShadowColor {
    if (_currentTitleShadowColor != currentTitleShadowColor) {
        _currentTitleShadowColor = currentTitleShadowColor;
        if (_titleLabel) {
            if (_shadowLabel) {
                _shadowLabel.hidden = false;
                _shadowLabel.fontColor = currentTitleShadowColor ? currentTitleShadowColor : [SKColor clearColor];
            } else {
                _shadowLabel = [[SKLabelNode alloc] initWithFontNamed:_currentTitleFont];
                _shadowLabel.fontColor = currentTitleShadowColor ? currentTitleShadowColor : [SKColor clearColor];
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
    if (state & SIControlStateHighlighted) {
        self.allowHighlightedState = true;
    }
    if (state & SIControlStateSelected) {
        self.allowSelectedState = true;
    }
}

- (void)updateButtonDisplayDictionary:(NSString *)dictionary withObject:(id)object forState:(SIControlState)state {
    if (!_buttonDisplayInfoDictionary) {
        _buttonDisplayInfoDictionary = [[NSMutableDictionary alloc] init];
    }

    NSMutableDictionary *dict = _buttonDisplayInfoDictionary[dictionary];
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    for (NSUInteger index = 0; index < 4; index++) {
        SIControlState event = 1 << index;
        if (event & state) {
            [dict setObject:object forKey:stringForSIControlState(event)];
        }
    }
    _buttonDisplayInfoDictionary[dictionary] = dict;
}

- (void)controlStateDidUpdate:(SIControlState)state {
    self.currentTitleFont = [self titleFontForState:self.state];
    self.currentTitle = [self titleForState:self.state];
    self.currentTitleColor = [self titleColorForState:self.state];
    self.currentTitleShadowColor = [self titleShadowColorForState:self.state];
    self.currentTexture = [self textureForState:self.state];
    self.currentBackgroundTexture = [self backgroundTextureForState:self.state];
    
}

#pragma mark - state dictionary setters

- (void)setTitle:(nullable NSString *)title forState:(SIControlState)state {
    [self updateFlagsForState:state];
    [self updateButtonDisplayDictionary:@"title" withObject:title forState:state];
    [self controlStateDidUpdate:state];
}

- (void)setTitleFont:(nullable NSString *)font forState:(SIControlState)state {
    [self updateButtonDisplayDictionary:@"font" withObject:font forState:state];
    [self controlStateDidUpdate:state];
}

- (void)setTitleColor:(nullable SKColor *)color forState:(SIControlState)state {
    [self updateButtonDisplayDictionary:@"color" withObject:color forState:state];
    [self controlStateDidUpdate:state];
}

- (void)setTitleShadowColor:(nullable SKColor *)color forState:(SIControlState)state {
    [self updateButtonDisplayDictionary:@"shadow" withObject:color forState:state];
    [self controlStateDidUpdate:state];
}

- (void)setTexture:(nullable SKTexture *)texture forState:(SIControlState)state {
    [self updateFlagsForState:state];
    [self updateButtonDisplayDictionary:@"texture" withObject:texture forState:state];
    [self controlStateDidUpdate:state];
}

- (void)setBackgroundTexture:(nullable SKTexture *)texture forState:(SIControlState)state {
    [self updateFlagsForState:state];
    [self updateButtonDisplayDictionary:@"background" withObject:texture forState:state];
    [self controlStateDidUpdate:state];
}

#pragma mark - state helper dictionary setters

- (void)setTitle:(nullable NSString *)title withFont:(NSString *)font forState:(SIControlState)state {
    [self setTitleFont:font forState:state];
    [self setTitle:title forState:state];
}

- (void)setTitle:(nullable NSString *)title withFont:(NSString *)font andColor:(nullable SKColor *)color forState:(SIControlState)state {
    [self setTitleFont:font forState:state];
    [self setTitle:title forState:state];
    [self setTitleColor:color forState:state];
}

- (void)setTitle:(nullable NSString *)title withColor:(nullable SKColor *)color forState:(SIControlState)state {
    [self setTitle:(NSString *)title forState:state];
    [self setTitleColor:color forState:state];
}

- (void)setTitle:(nullable NSString *)title withFont:(NSString *)font andBackgroundTexture:(nullable SKTexture *)texture forState:(SIControlState)state {
    [self setTitleFont:font forState:state];
    [self setTitle:title forState:state];
    [self setBackgroundTexture:texture forState:state];
}

- (void)setTexture:(nullable SKTexture *)texture withBackgroundTexture:(nullable SKTexture *)background forState:(SIControlState)state {
    [self setTexture:texture forState:state];
    [self setBackgroundTexture:background forState:state];
}

#pragma mark - state dictionary getters

- (nullable NSString *)titleForState:(SIControlState)state {
    return (NSString *)[[_buttonDisplayInfoDictionary objectForKey:@"title"] objectForKey:stringForSIControlState(state)];
}

- (nullable NSString *)titleFontForState:(SIControlState)state {
    return (NSString *)[[_buttonDisplayInfoDictionary objectForKey:@"font"] objectForKey:stringForSIControlState(state)];
}

- (nullable SKColor *)titleColorForState:(SIControlState)state {
    return (SKColor *)[[_buttonDisplayInfoDictionary objectForKey:@"color"] objectForKey:stringForSIControlState(state)];
}

- (nullable SKColor *)titleShadowColorForState:(SIControlState)state {
    return (SKColor *)[[_buttonDisplayInfoDictionary objectForKey:@"shadow"] objectForKey:stringForSIControlState(state)];
}

- (nullable SKTexture *)textureForState:(SIControlState)state {
    return (SKTexture *)[[_buttonDisplayInfoDictionary objectForKey:@"texture"] objectForKey:stringForSIControlState(state)];
}

- (nullable SKTexture *)backgroundTextureForState:(SIControlState)state {
    return (SKTexture *)[[_buttonDisplayInfoDictionary objectForKey:@"background"] objectForKey:stringForSIControlState(state)];
}


@end
