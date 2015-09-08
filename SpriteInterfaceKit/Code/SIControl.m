//
//  SIControl.m
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 9/7/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import "SIControl.h"

@interface SIControl()

@property (nonatomic, readwrite, getter=isTouchInside) BOOL touchInside;

@property (nonatomic, readwrite) SIControlState state;
@property (nonatomic) SIControlState previousState;

@property (nonatomic, strong) NSMutableArray *targetActionArray;
@property (nonatomic, strong) NSMutableSet *targetSet;
@property (nonatomic) SIControlEvent controlEventActions;

@end

@implementation SIControl

- (void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        _enabled = enabled;
        self.userInteractionEnabled = enabled;
        self.state = enabled ? self.previousState : SIControlStateDisabled;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (_highlighted != highlighted) {
        if (!(self.state & SIControlStateHighlighted)) {
            self.previousState = self.state;
        }
        _highlighted = highlighted;
        self.state = highlighted ? SIControlStateHighlighted : self.previousState;
    }
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        self.state = selected ? SIControlStateSelected : SIControlStateNormal;
    }
}

- (void)setState:(SIControlState)state {
    if (_state != state) {
        _state = state;
        [self controlStateDidUpdate:state];
    }
}

- (void)controlStateDidUpdate:(SIControlState)state {
    // Overriden by subclass
}

- (void)addTarget:(id)target action:(SEL)action forSIControlEvents:(SIControlEvent)controlEvents {
    if (!self.targetActionArray) {
        self.targetActionArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.targetSet) {
        self.targetSet = [[NSMutableSet alloc] init];
    }
    
    for (NSUInteger index = 0; index < 4; index++) {
        SIControlState event = 1 << index;
        if (event & controlEvents) {
            if ([self.targetActionArray count]) {
                NSMutableArray *array = self.targetActionArray[index];
                [array addObject:@[target, NSStringFromSelector(action)]];
            } else {
                self.targetActionArray[index] = @[@[target, NSStringFromSelector(action)]];
            }
            if (![self.targetSet containsObject:target]) {
                [self.targetSet addObject:target];
            }
            self.controlEventActions = (self.controlEventActions ^ event);
        }
    }
}

- (void)removeTarget:(id)target action:(SEL)action forSIControlEvents:(SIControlEvent)controlEvents {
    
    if ([self.targetActionArray count]) {
        for (NSUInteger index = 0; index < 4; index++) {
            SIControlEvent event = 1 << index;
            if (event & controlEvents) {
                NSMutableArray *array = self.targetActionArray[index];
                for (NSArray *subArray in array) {
                    id currentTarget = subArray[0];
                    SEL selectorString = NSSelectorFromString(subArray[1]);
                    if (!action) {
                        if (currentTarget == target) {
                            [array removeObject:subArray];
                        }
                    } else {
                        if (currentTarget == target & selectorString == action) {
                            [array removeObject:subArray];
                        }
                    }
                }
            }
        }
    }
}

- (NSSet *)allTargets {
    return [self.targetSet copy];
}

- (SIControlEvent)allControlEvents {
    return self.controlEventActions;
}

- (nullable NSArray<NSString *> *)actionsForTarget:(id)target forSIControlEvent:(SIControlEvent)controlEvent {
    // To be implemented
    return nil;
}

- (void)sendAction:(SEL)action to:(id)target forSIControlEvent:(SIControlEvent)controlEvent {
    if (target && [target respondsToSelector:action]) {
        [[UIApplication sharedApplication] sendAction:action to:target from:self forEvent:nil];
    } else {
        NSLog(@"Cannot send action: %@ to target: %@ for event: %lu! Target does nit contain method named: %@", NSStringFromSelector(action), target, (unsigned long)controlEvent, NSStringFromSelector(action));
    }
}

- (void)sendActionsForSIControlEvents:(SIControlEvent)controlEvents {
    for (NSUInteger index = 0; index < 4; index++) {
        SIControlEvent event = 1 << index;
        if (event & controlEvents) {
            NSMutableArray *array = self.targetActionArray[index];
            for (NSArray *subArray in array) {
                id currentTarget = subArray[0];
                SEL selectorString = NSSelectorFromString(subArray[1]);
                [self sendAction:selectorString to:currentTarget forSIControlEvent:event];
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self hasTouchWithinControl:touches]) {
        if (self.allowHighlightedState) {
            self.highlighted = true;
        }
        self.touchInside = true;
        [self sendActionsForSIControlEvents:SIControlEventTouchDown];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self hasTouchWithinControl:touches]) {
        if (self.touchInside) {
            [self sendActionsForSIControlEvents:SIControlEventTouchDragExit];
        }
        self.touchInside = false;
        [self sendActionsForSIControlEvents:SIControlEventTouchDragOutside];
    } else {
        if (self.touchInside) {
            [self sendActionsForSIControlEvents:SIControlEventTouchDragEnter];
        }
        self.touchInside = true;
        [self sendActionsForSIControlEvents:SIControlEventTouchDragInside];
    }
    if (self.allowHighlightedState && self.highlighted != self.touchInside) {
        self.highlighted = self.touchInside;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.allowHighlightedState) {
        self.highlighted = false;
    }
    if (self.allowSelectedState && self.touchInside) {
        self.selected = !self.selected;
        [self sendActionsForSIControlEvents:SIControlEventValueChanged];
    }
    if (self.touchInside) {
        [self sendActionsForSIControlEvents:SIControlEventTouchUpInside];
    } else {
        [self sendActionsForSIControlEvents:SIControlEventTouchUpOutside];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.allowHighlightedState) {
        self.highlighted = false;
    }
    [self sendActionsForSIControlEvents:SIControlEventTouchCancel];
}

- (BOOL)hasTouchWithinControl:(NSSet<UITouch *> *)touches {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self.scene];
    SKNode *node = [self.scene nodeAtPoint:point];
    
    return node == self || [node inParentHierarchy:self];
}


@end

