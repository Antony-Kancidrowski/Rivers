//
//  MenuItemView.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Types.h"

@interface MenuItemView : UIView

@property (nonatomic, copy) dispatch_block_float_t floatAction;
@property (nonatomic, copy) dispatch_block_t action;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger itemIndex;

@property (nonatomic, readonly) NSNumber *value;

@property (nonatomic, readonly) NSNumber *min;
@property (nonatomic, readonly) NSNumber *max;

@end
