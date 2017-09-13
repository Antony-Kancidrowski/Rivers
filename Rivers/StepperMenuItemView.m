//
//  StepperMenuItemView.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "StepperMenuItemView.h"

#import "DebugOptions.h"

@implementation StepperMenuItemView

- (instancetype)initWithValue:(NSNumber*)value andMin:(CGFloat)min andMax:(CGFloat)max {
    
    if (self = [super init]) {
        
        _valueStepper = [UIStepper new];
        _valueStepper.backgroundColor = [UIColor clearColor];
        
        _valueStepper.maximumValue = max;
        _valueStepper.minimumValue = min;
        
        _valueStepper.value = value.doubleValue;
        
        [_valueStepper addTarget:self action:@selector(changeStepper:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_valueStepper];
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    CGFloat inset = floorf(CGRectGetHeight(frame) * 0.1f);
    
    BOOL hasText = [self.titleLabel.text length] > 0;
    
    if (hasText) {
        
        CGFloat y = 0;
        CGFloat height = CGRectGetHeight(frame);
        CGFloat left = 0;
        
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            
            left = 10;
        }
        
        self.titleLabel.frame = CGRectMake(left, y, CGRectGetWidth(frame), height);
    }
    else {
        
        self.titleLabel.frame = CGRectZero;
    }
    
    CGFloat y = inset;
    CGFloat height = floorf(CGRectGetHeight(frame) * 2/3.f);
    
    self.valueStepper.frame = CGRectMake(CGRectGetWidth(frame) - 90 - inset, y, 90, height);
}

- (void)changeStepper:(id)sender {
    
    UIStepper *stepper = (UIStepper *)sender;
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Value: %f", [stepper value]);
    
    if (self.floatAction != nil) {
        
        self.floatAction([stepper value]);
    }
}

@end
