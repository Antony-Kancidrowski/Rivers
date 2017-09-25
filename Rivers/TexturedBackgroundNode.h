//
//  TexturedBackgroundNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "BackgroundNode.h"

@interface TexturedBackgroundNode : BackgroundNode

+ (TexturedBackgroundNode *)backgroundWithTextureNamed:(NSString *)textureName;

- (instancetype)init NS_UNAVAILABLE;

- (void)activate;
- (void)deactivate;

- (void)colorizeWithColor:(id)color;

- (void)animate;

@end
