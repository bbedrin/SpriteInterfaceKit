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

@property (nonatomic, strong) NSMutableDictionary *targetActionDictionary;
@property (nonatomic, strong) NSMutableSet *targetSet;
@property (nonatomic) SIControlEvent controlEventActions;

@end

@implementation SIControl

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = SIControlStateNormal;
        _uniqueId = arc4random();
    }
    
    NSLog(@"[%@ init]", self);
    
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    NSLog(@"[%@ setEnabled: %d]", self, enabled);
    
    if (_enabled != enabled) {
        _enabled = enabled;
        self.userInteractionEnabled = enabled;
        self.state = enabled ? self.previousState : SIControlStateDisabled;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    NSLog(@"[%@ setHighlighted: %d]", self, highlighted);
    
    if (_highlighted != highlighted) {
        if (!(self.state & SIControlStateHighlighted)) {
            self.previousState = self.state;
        }
        _highlighted = highlighted;
        self.state = highlighted ? SIControlStateHighlighted : self.previousState;
    }
}

- (void)setSelected:(BOOL)selected {
    NSLog(@"[%@ setSelected: %d]", self, selected);
    
    if (_selected != selected) {
        _selected = selected;
        self.state = selected ? SIControlStateSelected : SIControlStateNormal;
    }
}

- (void)setState:(SIControlState)state {
    NSLog(@"[%@ setState: %@]", self, stringForSIControlState(state));
    
    if (_state != state) {
        _state = state;
        [self controlStateDidUpdate:state];
    }
}

- (void)controlStateDidUpdate:(SIControlState)state {
    NSLog(@"[%@ controlStateDidUpdate: %@]", self, stringForSIControlState(state));
    // Overriden by subclass
}

- (void)addTarget:(id)target action:(SEL)action forSIControlEvents:(SIControlEvent)controlEvents {
    NSLog(@"[%@ addTarget: %@ action: %@ forSIControlEvents: %@]", self, target, NSStringFromSelector(action), stringForSIControlEvent(controlEvents));
    
    if (!self.targetActionDictionary) {
        self.targetActionDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if (!self.targetSet) {
        self.targetSet = [[NSMutableSet alloc] init];
    }
    
    for (NSUInteger index = 0; index < 8; index++) {
        SIControlEvent event = 1 << index;
        if (event & controlEvents) {
            if ([[self.targetActionDictionary allKeys] count]) {
                NSMutableArray *array = self.targetActionDictionary[stringForSIControlEvent(event)];
                [array addObject:@[target, NSStringFromSelector(action)]];
            } else {
                self.targetActionDictionary[stringForSIControlEvent(event)] = @[@[target, NSStringFromSelector(action)]];
            }
            if (![self.targetSet containsObject:target]) {
                [self.targetSet addObject:target];
            }
            self.controlEventActions = (self.controlEventActions ^ event);
        }
    }
    
    NSLog(@"%@", self.targetActionDictionary);
}

- (void)removeTarget:(id)target action:(SEL)action forSIControlEvents:(SIControlEvent)controlEvents {
    NSLog(@"[%@ removeTarget: %@ action: %@ forSIControlEvents: %@]", self, target, NSStringFromSelector(action), stringForSIControlEvent(controlEvents));
    
    if ([[self.targetActionDictionary allKeys] count]) {
        for (NSUInteger index = 0; index < 8; index++) {
            SIControlEvent event = 1 << index;
            if (event & controlEvents) {
                NSMutableArray *array = self.targetActionDictionary[stringForSIControlEvent(event)];
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
    NSLog(@"[%@ sendAction: %@ to: %@ forSIControlEvent: %@]", self, NSStringFromSelector(action), target, stringForSIControlEvent(controlEvent));
    
    if (target && [target respondsToSelector:action]) {
#if TARGET_OS_IPHONE
        [[UIApplication sharedApplication] sendAction:action to:target from:self forEvent:nil];
#elif TARGET_OS_MAC
        [[NSApplication sharedApplication] sendAction:action to:target from:self];
#endif
    } else {
        NSLog(@"Cannot send action: %@ to target: %@ for event: %@! Target does nit contain method named: %@", NSStringFromSelector(action), target, stringForSIControlEvent(controlEvent), NSStringFromSelector(action));
    }
}

- (void)sendActionsForSIControlEvents:(SIControlEvent)controlEvents {
    NSLog(@"[%@ sendActionsForSIControlEvents: %@]", self, stringForSIControlEvent(controlEvents));
    
    for (NSUInteger index = 0; index < 8; index++) {
        SIControlEvent event = 1 << index;
        if (event & controlEvents) {
            NSMutableArray *array = self.targetActionDictionary[stringForSIControlEvent(controlEvents)];
            for (NSArray *subArray in array) {
                id currentTarget = subArray[0];
                SEL selectorString = NSSelectorFromString(subArray[1]);
                [self sendAction:selectorString to:currentTarget forSIControlEvent:event];
            }
        }
    }
}

#if TARGET_OS_IPHONE
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
    if (self.allowSelectedState && self.touchInside && !self.allowManualControlOfSelectedState) {
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

#elif TARGET_OS_MAC
- (void)mouseDown:(NSEvent *)theEvent {
    if ([self hasMouseWithinControl:theEvent]) {
        if (self.allowHighlightedState) {
            self.highlighted = true;
        }
        self.touchInside = true;
        [self sendActionsForSIControlEvents:SIControlEventTouchDown];
    }}

- (void)mouseDragged:(NSEvent *)theEvent {
    if (![self hasMouseWithinControl:theEvent]) {
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
    }}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.allowHighlightedState) {
        self.highlighted = false;
    }
    if (self.allowSelectedState && self.touchInside && !self.allowManualControlOfSelectedState) {
        self.selected = !self.selected;
        [self sendActionsForSIControlEvents:SIControlEventValueChanged];
    }
    if (self.touchInside) {
        [self sendActionsForSIControlEvents:SIControlEventTouchUpInside];
    } else {
        [self sendActionsForSIControlEvents:SIControlEventTouchUpOutside];
    }
}

- (BOOL)hasMouseWithinControl:(NSEvent *)theEvent {
    CGPoint point = [theEvent locationInNode:self.scene];
    SKNode *node = [self.scene nodeAtPoint:point];
    return node == self || [node inParentHierarchy:self];
}

#endif

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (id: %lu)", self.class, self.uniqueId];
}

@end


