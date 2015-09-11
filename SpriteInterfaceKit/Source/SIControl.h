//
//  SIControl.h
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 9/7/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, SIControlEvent) {
    SIControlEventTouchDown             = 1 << 0,
    SIControlEventTouchDownRepeat       = 1 << 1,
    SIControlEventTouchDragInside       = 1 << 2,
    SIControlEventTouchDragOutside      = 1 << 3,
    SIControlEventTouchDragEnter        = 1 << 4,
    SIControlEventTouchDragExit         = 1 << 5,
    SIControlEventTouchUpInside         = 1 << 6,
    SIControlEventTouchUpOutside        = 1 << 7,
    SIControlEventTouchCancel           = 1 << 8,
    
    SIControlEventValueChanged          = 1 << 12,

    SIControlEventAllTouchEvents        = 0x00000FFF
};

typedef NS_OPTIONS(NSUInteger, SIControlState) {
    SIControlStateNormal            = 1 << 0,
    SIControlStateHighlighted       = 1 << 1,
    SIControlStateSelected          = 1 << 2,
    SIControlStateDisabled          = 1 << 3,
    SIControlStateAll               = (SIControlStateNormal | SIControlStateHighlighted | SIControlStateSelected | SIControlStateDisabled)
};

static inline NSString* __nonnull stringForSIControlState(SIControlState state) {
    switch (state) {
        case SIControlStateNormal:
            return @"Normal";
        case SIControlStateHighlighted:
            return @"Highlighted";
        case SIControlStateSelected:
            return @"Selected";
        case SIControlStateDisabled:
            return @"Disabled";
        default:
            return [NSString stringWithFormat:@"Unknown control state: %d", (int)state];
    }
}

@interface SIControl : SKNode

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic) BOOL allowSelectedState;
@property (nonatomic) BOOL allowHighlightedState;

@property (nonatomic, readonly, getter=isTouchInside) BOOL touchInside;
@property (nonatomic, readonly) SIControlState state;

- (void)controlStateDidUpdate:(SIControlState)state;

- (void)addTarget:(id)target action:(nonnull SEL)action forSIControlEvents:(SIControlEvent)controlEvents;
- (void)removeTarget:(id)target action:(nullable SEL)action forSIControlEvents:(SIControlEvent)controlEvents;

- (NSSet *)allTargets;
- (SIControlEvent)allControlEvents;
- (nullable NSArray<NSString *> *)actionsForTarget:(nullable id)target forSIControlEvent:(SIControlEvent)controlEvent;

- (void)sendAction:(SEL)action to:(nullable id)target forSIControlEvent:(SIControlEvent)controlEvent;
- (void)sendActionsForSIControlEvents:(SIControlEvent)controlEvents;

@end

NS_ASSUME_NONNULL_END
