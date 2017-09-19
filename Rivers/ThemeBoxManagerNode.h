//
//  ThemeBoxManagerNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"
#import "Theme.h"

@interface ThemeBoxManagerNode : ActorNode

+ (ThemeBoxManagerNode *)boxWithTheme:(Theme *)theme;

- (instancetype)init NS_UNAVAILABLE;

- (void)activate;
- (void)deactivate;

- (void)setup:(SCNNode *)parentNode;

@end
