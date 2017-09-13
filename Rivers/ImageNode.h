//
//  ImageNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "ActorNode.h"

@interface ImageNode : ActorNode

+ (ImageNode *)imageWithImage:(UIImage *)image;
+ (ImageNode *)imageWithTextureNamed:(NSString *)textureName;
+ (ImageNode *)imageWithTextureNamed:(NSString *)textureName andSize:(CGSize)size;

- (instancetype)init NS_UNAVAILABLE;

- (void)colorizeWithColor:(id)color;
- (void)setTexture:(NSString *)textureName;

@end
