//
//  SIControlGroup.h
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 10/1/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import "SIControl.h"

@interface SIControlGroup : SIControl

@property (nonatomic, strong, readonly) NSArray *controls;

- (void)addControl:(SIControl *)control;
- (void)addControlWithArray:(NSArray<SIControl *> *)controls;
- (void)removeControl:(SIControl *)control;
- (void)removeControlWithArray:(NSArray<SIControl *> *)controls;

@end
