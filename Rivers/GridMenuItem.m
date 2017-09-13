//
//  GridMenuItem.m
//  Rivers
//
//  Created by Antony Kancidrowski on 30/03/2014.
//  Copyright (c) 2016 Antony Kancidrowski. All rights reserved.
//

#import "GridMenuItem.h"

#pragma mark - GridMenuItem

@implementation GridMenuItem

+ (instancetype)emptyItem {
    
    static GridMenuItem *emptyItem = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emptyItem = [[GridMenuItem alloc] initWithType:MENU_ITEM_EMPTY withValue:nil title:nil dismisses:YES action:nil];
    });
    
    return emptyItem;
}

- (instancetype)initWithType:(MenuItemType)type withValue:(NSNumber*)value title:(NSString *)title dismisses:(BOOL)dismisses floatAction:(dispatch_block_float_t)floatAction {
    
    if ((self = [super init])) {
        _title = [title copy];
        _floatAction = [floatAction copy];
        _dismisses = dismisses;
        _type = type;
        _value = value;
    }
    
    return self;
}

- (instancetype)initWithType:(MenuItemType)type withValue:(NSNumber*)value andMin:(CGFloat)min andMax:(CGFloat)max title:(NSString *)title dismisses:(BOOL)dismisses floatAction:(dispatch_block_float_t)floatAction {
    
    if ((self = [super init])) {
        _title = [title copy];
        _floatAction = [floatAction copy];
        _dismisses = dismisses;
        _type = type;
        _value = value;
        _min = min;
        _max = max;
    }
    
    return self;
}

- (instancetype)initWithType:(MenuItemType)type withImage:(UIImage *)image withValue:(NSNumber*)value title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action {
    
    if ((self = [super init])) {
        _image = image;
        _title = [title copy];
        _action = [action copy];
        _dismisses = dismisses;
        _type = type;
        _value = value;
    }
    
    return self;
}

- (instancetype)initWithType:(MenuItemType)type withImage:(UIImage *)image title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action {
    
    return [self initWithType:type withImage:image withValue:nil title:title dismisses:dismisses action:action];
}

- (instancetype)initWithType:(MenuItemType)type withValue:(NSNumber*)value andOffset:(CGFloat)offset title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action {
    
    return [self initWithType:type withValue:value andOffset:offset title:title dismisses:dismisses action:action];
}

- (instancetype)initWithType:(MenuItemType)type withValue:(NSNumber*)value title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action {
    
    return [self initWithType:type withImage:nil withValue:value title:title dismisses:dismisses action:action];
}

- (instancetype)initWithType:(MenuItemType)type title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action {
    
    return [self initWithType:type withImage:nil withValue:nil title:title dismisses:dismisses action:action];
}

- (instancetype)initWithType:(MenuItemType)type withImage:(UIImage *)image title:(NSString *)title dismisses:(BOOL)dismisses {
    
    return [self initWithType:type withImage:image withValue:nil title:title dismisses:dismisses action:nil];
}

- (instancetype)initWithType:(MenuItemType)type title:(NSString *)title dismisses:(BOOL)dismisses {
    
    return [self initWithType:type withImage:nil withValue:nil title:title dismisses:dismisses action:nil];
}

- (BOOL)isEqual:(id)object {
    
    if (![object isKindOfClass:[GridMenuItem class]]) {
        
        return NO;
    }
    
    GridMenuItem* item = (GridMenuItem*)object;
    
    return ((self.title == [item title] || [self.title isEqualToString:[item title]]) &&
            (self.image == [item image]));
}

- (NSUInteger)hash {
    
    return self.title.hash;
}

- (BOOL)isEmpty {
    
    return [self isEqual:[[self class] emptyItem]];
}

@end

