//
//  ImageMenuItemView.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "MenuItemView.h"

@interface ImageMenuItemView : MenuItemView

@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithImage:(UIImage *)image;

@end
