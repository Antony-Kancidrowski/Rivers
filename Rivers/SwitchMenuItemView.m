//
//  SwitchMenuItemView.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "SwitchMenuItemView.h"

#import "DebugOptions.h"

@implementation SwitchMenuItemView

- (instancetype)initWithValue:(NSNumber*)value {
    
    if (self = [super init]) {
        
        _valueSwitch = [UISwitch new];
        _valueSwitch.backgroundColor = [UIColor clearColor];
        
        _valueSwitch.on = value.boolValue;
        
        [_valueSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_valueSwitch];
        
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
    
    self.valueSwitch.frame = CGRectMake(CGRectGetWidth(frame) - 50 - inset, y, 50, height);
}

- (void)changeSwitch:(id)sender {
    
    UISwitch *toggleSwitch = (UISwitch *)sender;
    
    if([toggleSwitch isOn]) {
        
        // Execute any code when the switch is ON
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Switch is ON");
    } else {
        
        // Execute any code when the switch is OFF
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Switch is OFF");
    }
    
    if (self.action != nil) {
        
        self.action();
    }
}

@end
