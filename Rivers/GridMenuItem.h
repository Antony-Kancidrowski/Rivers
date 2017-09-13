//
//  GridMenuItem.h
//  Rivers
//
//  Created by Antony Kancidrowski on 30/03/2014.
//  Copyright (c) 2016 Antony Kancidrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"

@class GridMenuViewController;

//-------------------------------------------------------------

typedef NS_ENUM(gsUDWORD, MenuItemType) {
    
    MENU_ITEM_EMPTY = 0,
    MENU_ITEM_TEXT,
    MENU_ITEM_IMAGE,
    MENU_ITEM_SWITCH,
    MENU_ITEM_STEPPER,
    MENU_ITEM_SLIDER
};

//-------------------------------------------------------------

@interface GridMenuItem : NSObject

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) MenuItemType type;

@property (nonatomic) gsUDWORD itemId;

@property (nonatomic) BOOL dismisses;

@property (nonatomic, copy) dispatch_block_float_t floatAction;
@property (nonatomic, copy) dispatch_block_t action;

@property (nonatomic) NSNumber *value;

@property (nonatomic) CGFloat min;
@property (nonatomic) CGFloat max;

@property (nonatomic, strong) UIColor *highlightColor;

+ (instancetype)emptyItem;

- (instancetype)initWithType:(MenuItemType)type withImage:(UIImage *)image withValue:(NSNumber*)value title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action;

- (instancetype)initWithType:(MenuItemType)type withValue:(NSNumber*)value title:(NSString *)title dismisses:(BOOL)dismisses floatAction:(dispatch_block_float_t)floatAction;

- (instancetype)initWithType:(MenuItemType)type withValue:(NSNumber*)value andMin:(CGFloat)min andMax:(CGFloat)max title:(NSString *)title dismisses:(BOOL)dismisses floatAction:(dispatch_block_float_t)floatAction;

- (instancetype)initWithType:(MenuItemType)type withImage:(UIImage *)image title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action;
- (instancetype)initWithType:(MenuItemType)type withValue:(NSNumber*)value title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action;
- (instancetype)initWithType:(MenuItemType)type title:(NSString *)title dismisses:(BOOL)dismisses action:(dispatch_block_t)action;
- (instancetype)initWithType:(MenuItemType)type withImage:(UIImage *)image title:(NSString *)title dismisses:(BOOL)dismisses;
- (instancetype)initWithType:(MenuItemType)type title:(NSString *)title dismisses:(BOOL)dismisses;

- (BOOL)isEmpty;

@end
