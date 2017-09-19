//
//  SliderNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"

@interface SliderNode : ActorNode

+ (SliderNode *)sliderWithWidth:(CGFloat)width;

- (instancetype)init NS_UNAVAILABLE;

- (void)addTarget:(id)target action:(SEL)selector;

- (void)activate;
- (void)deactivate;

- (void)updatePosition:(CGFloat)value;

@end
