//
//  StepperMenuItemView.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "MenuItemView.h"

@interface StepperMenuItemView : MenuItemView

@property (nonatomic, strong) UIStepper *valueStepper;

- (instancetype)initWithValue:(NSNumber*)value andMin:(CGFloat)min andMax:(CGFloat)max;

@end
