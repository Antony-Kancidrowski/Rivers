//
//  ImageMenuItemView.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ImageMenuItemView.h"

@implementation ImageMenuItemView

- (instancetype)initWithImage:(UIImage *)image {
    
    if (self = [super init]) {
        
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    
    CGRect frame = self.bounds;
    CGFloat inset = floorf(CGRectGetHeight(frame) * 0.1f);
    
    BOOL hasImage = self.imageView.image != nil;
    BOOL hasText = [self.titleLabel.text length] > 0;
    
    if (hasImage) {
        
        CGFloat y = 0;
        CGFloat height = CGRectGetHeight(frame);
        
        if (hasText) {
            
            y = inset / 2;
            height = floorf(CGRectGetHeight(frame) * 2/3.f);
        }
        
        self.imageView.frame = CGRectInset(CGRectMake(0, y, CGRectGetWidth(frame), height), inset, inset);
    }
    else {
        
        self.imageView.frame = CGRectZero;
    }
    
    if (hasText) {
        
        CGFloat y = 0;
        CGFloat height = CGRectGetHeight(frame);
        CGFloat left = 0;
        
        if (hasImage) {
            
            y = floorf(CGRectGetHeight(frame) * 2/3.f) - inset / 2;
            height = floorf(CGRectGetHeight(frame) / 3.f);
        }
        
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
