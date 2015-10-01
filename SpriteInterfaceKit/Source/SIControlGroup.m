//
//  SIControlGroup.m
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 10/1/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import "SIControlGroup.h"

@implementation SIControlGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        _controls = [NSArray new];
    }
    
    return self;
}

- (void)groupedControlWasSelected:(SIControl *)control {
    NSLog(@"[%@ groupedControlWasSelected: %@]", self, control);
    
    for (SIControl *item in self.controls) {
        if (item.uniqueId == control.uniqueId && !control.selected) {
            control.selected = true;
            [control sendActionsForSIControlEvents:SIControlEventValueChanged];
        } else {
            item.selected = false;
        }
    }
}

- (void)addControl:(SIControl *)control {
    NSLog(@"[%@ addControl: %@]", self, control);
    
    NSMutableArray *array = [self.controls mutableCopy];
    [control addTarget:self action:@selector(groupedControlWasSelected:) forSIControlEvents:SIControlEventTouchUpInside];
    control.allowManualControlOfSelectedState = true;
    control.controlGroup = self;
    [array addObject:control];
    _controls = array.copy;
}

- (void)addControlWithArray:(NSArray<SIControl *> *)controls {
    NSLog(@"[%@ addControlWithArray: %@]", self, controls);
    
    for (SIControl *control in controls) {
        [self addControl:control];
    }
}

- (void)removeControl:(SIControl *)control {
    NSLog(@"[%@ removeControl: %@]", self, control);
    
    NSMutableArray *array = [self.controls mutableCopy];
    [control removeTarget:self action:@selector(groupedControlWasSelected:) forSIControlEvents:SIControlEventTouchUpInside];
    control.allowManualControlOfSelectedState = true;
    control.controlGroup = self;
    [array addObject:control];
    _controls = array.copy;
}

- (void)removeControlWithArray:(NSArray<SIControl *> *)controls {
    NSLog(@"[%@ removeControlWithArray: %@]", self, controls);
    
    for (SIControl *control in controls) {
        [self removeControl:control];
    }
}
@end
