//
//  SICheckbox.h
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 9/17/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import "SIButton.h"

typedef NS_ENUM(NSInteger, SICheckboxTitleAlignment) {
    SICheckboxTitleAlignmentRight = 0,
    SICheckboxTitleAlignmentLeft
};

@interface SICheckbox : SIButton

@property (nonatomic) SICheckboxTitleAlignment titleAlignment;
@property (nonatomic) CGPoint titleOffset;
@property (nonatomic) BOOL checked;

- (instancetype)initWithNormalTexture:(SKTexture *)normal selectedTexture:(SKTexture *)selected withTitle:(nullable NSString *)title andFont:(NSString *)font ofColor:(nullable SKColor *)color;

@end
