//
//  MenuItemView.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "MenuItemView.h"

@implementation MenuItemView

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
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
}

@end
