//
//  GLSLBackgroundNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 22/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "BackgroundNode.h"

@class CameraNode;

@interface GLSLBackgroundNode : BackgroundNode

+ (GLSLBackgroundNode *)backgroundNodeWithShaderName:(NSString *)shaderName andResolution:(CGSize)size;

- (instancetype)init NS_UNAVAILABLE;

- (void)animate;
- (void)setGLSLShader:(NSString *)name;

@end
