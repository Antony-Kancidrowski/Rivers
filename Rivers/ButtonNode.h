//
//  ButtonNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"

typedef NS_OPTIONS(int, ButtonNodeControlEvent) {
    
    ButtonNodeControlEventTouchDown = 1,
    ButtonNodeControlEventTouchUp,
    ButtonNodeControlEventTouchUpInside,
    ButtonNodeControlEventAllEvents
};

typedef NS_ENUM(NSInteger, TagHorizontalAlignment) {
    
    TagHorizontalAlignmentCenter    = 0,
    TagHorizontalAlignmentLeft      = 1,
    TagHorizontalAlignmentRight     = 2,
};

@interface ButtonNode : ActorNode

- (void)addTarget:(id)target action:(SEL)selector withObject:(id)object forControlEvent:(ButtonNodeControlEvent)controlEvent;
- (void)addTarget:(id)target action:(SEL)selector forControlEvent:(ButtonNodeControlEvent)controlEvent;

- (void)addPressSoundAction:(SCNAction *)action;

- (void)pressButton;
- (void)releaseButton;

- (void)cancelButton;

- (void)EnableButton:(BOOL)buttonEnabled;
- (BOOL)isButtonEnabled;

@end
