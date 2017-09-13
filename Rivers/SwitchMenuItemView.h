//
//  SwitchMenuItemView.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "MenuItemView.h"

@interface SwitchMenuItemView : MenuItemView

@property (nonatomic, strong) UISwitch *valueSwitch;

- (instancetype)initWithValue:(NSNumber*)value;

@end
