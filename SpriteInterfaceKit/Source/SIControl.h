//
//  SIControl.h
//  SpriteInterfaceKit
//
//  Created by Brett Bedrin on 9/7/15.
//  Copyright © 2015 Brett Bedrin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Events triggered when interacting with the control */
typedef NS_OPTIONS(NSUInteger, SIControlEvent) {
    /** An event for when the control is pressed down. */
    SIControlEventTouchDown             = 1 << 0,
    /** Currently not implemented */
    SIControlEventTouchDownRepeat       = 1 << 1,
    /** An event for when the touch or mouse is dragged while inside the control. */
    SIControlEventTouchDragInside       = 1 << 2,
    /** An event for when the touch or mouse is dragged while outside the control. */
    SIControlEventTouchDragOutside      = 1 << 3,
    /** An event at the point when the touch or mouse is dragged back inside the control. Only triggered when the event was previously dragged outside the control during the same touch or mouse event. */
    SIControlEventTouchDragEnter        = 1 << 4,
    /** An event at the point the touch or mouse event is dragged outside the control. */
    SIControlEventTouchDragExit         = 1 << 5,
    /** An event for when the control is released inside the control. */
    SIControlEventTouchUpInside         = 1 << 6,
    /** An event for when the control is release outside the control. */
    SIControlEventTouchUpOutside        = 1 << 7,
    /** An event for when the control touch or mouse event is interrupted. */
    SIControlEventTouchCancel           = 1 << 8,
    
    /** An event triggered any time the selected state changes. */
    SIControlEventValueChanged          = 1 << 12,

    /** All touch events */
    SIControlEventAllTouchEvents        = 0x00000FFF
};

static inline NSString* __nonnull stringForSIControlEvent(SIControlEvent event) {
    switch (event) {
        case SIControlEventTouchDown:
            return @"TouchDown";
        case SIControlEventTouchDownRepeat:
            return @"TouchDownRepeat";
        case SIControlEventTouchDragInside:
            return @"TouchDragInside";
        case SIControlEventTouchDragOutside:
            return @"TouchDragOutside";
        case SIControlEventTouchDragEnter:
            return @"TouchDragEnter";
        case SIControlEventTouchDragExit:
            return @"TouchDragExit";
        case SIControlEventTouchUpInside:
            return @"TouchUpInside";
        case SIControlEventTouchUpOutside:
            return @"TouchUpOutside";
        case SIControlEventTouchCancel:
            return @"TouchCancel";
        case SIControlEventValueChanged:
            return @"ValueChanged";
        case SIControlEventAllTouchEvents:
            return @"AllTouchEvents";
        default:
            return [NSString stringWithFormat:@"Unknown control event: %d", (int)event];
    }
}

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
        case SIControlStateAll:
            return @"All";
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
@property (nonatomic) BOOL allowManualControlOfSelectedState;

@property (nonatomic, strong) id controlGroup;

@property (nonatomic, readonly) NSUInteger uniqueId;
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
