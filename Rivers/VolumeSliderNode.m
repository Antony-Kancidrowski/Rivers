//
//  VolumeSliderNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "VolumeSliderNode.h"

#import "SliderNode.h"
#import "ImageNode.h"

@interface VolumeSliderNode ()
{
    ImageNode *speakerQuite;
    ImageNode *speakerLoud;
    
    SliderNode *slider;
    
    id _target;
    SEL _selector;
}
@end

@implementation VolumeSliderNode

- (void)addTarget:(id)target action:(SEL)selector {
    
    _target = target;
    _selector = selector;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    const CGFloat maxVolume = 4.75f;
    const CGFloat minVolume = -3.5f;
    
    speakerQuite = [ImageNode imageWithTextureNamed:@"speaker_low.png"];
    
    [speakerQuite setPosition:SCNVector3Make(minVolume, 0.0f, 0.05f)];
    [speakerQuite setEulerAngles:SCNVector3Zero];
    
    [speakerQuite setup:self];
    
    
    speakerLoud = [ImageNode imageWithTextureNamed:@"speaker_high.png"];
    
    [speakerLoud setPosition:SCNVector3Make(maxVolume, 0.0f, 0.05f)];
    [speakerLoud setEulerAngles:SCNVector3Zero];
    
    [speakerLoud setup:self];
    
    const CGFloat barOffset = 1.75f;
    
    CGFloat sliderWidth = ((maxVolume - barOffset) - (minVolume + barOffset));
    
    slider = [SliderNode sliderWithWidth:sliderWidth];
    
    [slider setScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [slider setPosition:SCNVector3Make(barOffset / 4.0f, 0.0f, 0.05f)];
    [slider setEulerAngles:SCNVector3Zero];
    
    [slider addTarget:_target action:_selector];
    [slider setup:self];
}

- (void)activate {
    
    [super activate];

    [speakerQuite activate];
    [speakerLoud activate];
    
    [slider activate];
}

- (void)deactivate {
    
    [speakerQuite deactivate];
    [speakerLoud deactivate];
    
    [slider deactivate];
    
    [super deactivate];
}

-(void)updateVolume:(CGFloat)newVolume {
    
    NSAssert(((newVolume >= 0.0f) && (newVolume <= 1.0f)), @"Invalid volume: range 0.0 to 1.0");

    [slider updatePosition:(newVolume - 0.5f)];
}

@end
