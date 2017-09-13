//
//  SliderMenuItemView.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "SliderMenuItemView.h"

#import "DebugOptions.h"

@implementation SliderMenuItemView

- (instancetype)initWithValue:(NSNumber*)value andMin:(CGFloat)min andMax:(CGFloat)max {
    
    if (self = [super init]) {
        
        _valueSlider = [UISlider new];
        _valueSlider.backgroundColor = [UIColor clearColor];
        
        _valueSlider.maximumValue = max;
        _valueSlider.minimumValue = min;
        
        _valueSlider.value = value.floatValue;
        
        [_valueSlider addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_valueSlider];
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    CGFloat inset = floorf(CGRectGetHeight(frame) * 0.1f);
    
    BOOL hasText = [self.titleLabel.text length] > 0;
    

    CGFloat y = 0;
    CGFloat height = CGRectGetHeight(frame);
    
    if (hasText) {
        
        y = inset / 2;
        height = floorf(CGRectGetHeight(frame) * 2/3.f);
    }
    
    self.valueSlider.frame = CGRectMake(CGRectGetWidth(frame) / 2 + inset, y, (CGRectGetWidth(frame) / 2) - inset * 2, height);
}

- (void)changeSlider:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Value: %f", [slider value]);
    
    if (self.floatAction != nil) {
        
        self.floatAction([slider value]);
    }
}

@end
