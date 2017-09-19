//
//  SliderNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "SliderNode.h"

#import "ImageNode.h"

@interface SliderNode ()
{
    ImageNode *slideBar;
    ImageNode *sliderSelection;
    
    CGFloat sliderPosition;
    CGFloat sliderWidth;
    
    id _target;
    SEL _selector;
}
@end

@implementation SliderNode

+ (SliderNode *)sliderWithWidth:(CGFloat)width {
    
    SliderNode *newSlider = [[SliderNode alloc] initWithWidth:width];
    
    return newSlider;
}

- (instancetype)initWithWidth:(CGFloat)width {
    
    self = [super init];
    
    if (self != nil)
    {
        sliderWidth = width;
        
        sliderPosition = -0.5f;
    }
    
    return self;
}

- (void)addTarget:(id)target action:(SEL)selector {
    
    _target = target;
    _selector = selector;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];

    sliderSelection = [ImageNode imageWithTextureNamed:@"slider_selection.png"];
    
    [sliderSelection setPosition:SCNVector3Make(sliderPosition, 0.0f, 0.02f)];
    [sliderSelection setEulerAngles:SCNVector3Zero];
    
    [sliderSelection setName:@"SliderSelection"];
    [sliderSelection setup:self];
    
    
    CGFloat fullBarWidth = (sliderWidth - 1.0f);
    
    slideBar = [ImageNode imageWithTextureNamed:@"slider_bar.png"];
    
    [slideBar setScale:SCNVector3Make(fullBarWidth, 1.0f, 1.0f)];
    [slideBar setPosition:SCNVector3Make(0.0f, 0.0f, 0.01f)];
    [slideBar setEulerAngles:SCNVector3Zero];
    
    [slideBar setName:@"SliderBar"];
    [slideBar setup:self];
}

- (void)activate {
    
    [super activate];
    
    [slideBar activate];
    [sliderSelection activate];
}

- (void)deactivate {
    
    [slideBar deactivate];
    [sliderSelection deactivate];
    
    [super deactivate];
}

-(void)updatePosition:(CGFloat)value {

    sliderPosition = sliderWidth * value;
    
    [sliderSelection setPosition:SCNVector3Make(sliderPosition, 0.0f, 0.02f)];
    
    IMP imp = [_target methodForSelector:_selector];
    
    NSNumber *number = [NSNumber numberWithFloat:(value + 0.5f)];
    
    void (*func)(id, SEL, id) = (void*)imp;
    func (_target, _selector, number);
}

@end
