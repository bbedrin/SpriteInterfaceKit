//
//  SICheckbox.m
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 9/17/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import "SICheckbox.h"

@implementation SICheckbox

- (instancetype)initWithNormalTexture:(SKTexture *)normal selectedTexture:(SKTexture *)selected withTitle:(nullable NSString *)title andFont:(NSString *)font ofColor:(nullable SKColor *)color {
    self = [super init];
    if (self) {
        [self setTexture:normal forState:SIControlStateNormal];
        [self setTexture:selected forState:SIControlStateSelected];
        if (title) {
            [self setTitle:title withFont:font andColor:color forState:SIControlStateNormal | SIControlStateSelected];
        }
    }
}

- (void)controlStateDidUpdate:(SIControlState)state {
    [super controlStateDidUpdate:state];
    _checked = self.selected
    if (self.textureImage && self.titleLabel) {
        CGFloat offset = 0.0;
        switch (self.titleAlignment) {
            case SICheckboxTitleAlignmentLeft:
                offset = -(self.titleLabel.frame.size.width + self.titleOffset.x);
                break;
            case SICheckboxTitleAlignmentRight:
                offset = self.titleOffset.x
        }
        self.titleLabel.position = CGPointMake(self.textureImage.size.width / 2 + offset, self.titleOffset.y)
    }
}

- (void)setTitle:(nullable NSString *)title forState:(SIControlState)state {
    if (!(state & SIControlStateHighlighted)) {
        [super setTitle:title forState:state];
    }
}

- (void)setTitleFont:(nullable NSString *)font forState:(SIControlState)state {
    if (!(state & SIControlStateHighlighted)) {
        [super setTitleFont:font forState:state];
    }
}

- (void)setTitleColor:(nullable SKColor *)color forState:(SIControlState)state {
    if (!(state & SIControlStateHighlighted)) {
        [super setTitleColor:color forState:state];
    }
}

- (void)setTitleShadowColor:(nullable SKColor *)color forState:(SIControlState)state {
    if (!(state & SIControlStateHighlighted)) {
        [super setTitleShadowColor:color forState:state];
    }
}

- (void)setTexture:(nullable SKTexture *)texture forState:(SIControlState)state {
    if (!(state & SIControlStateHighlighted)) {
        [super setTexture:texture forState:state];
    }
}

- (void)setBackgroundTexture:(nullable SKTexture *)texture forState:(SIControlState)state {
    if (!(state & SIControlStateHighlighted)) {
        [super setBackgroundTexture:texture forState:state];
    }
}

@end
