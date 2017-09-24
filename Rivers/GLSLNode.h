//
//  GLSLNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 22/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "ActorNode.h"

@class CameraNode;

@interface GLSLNode : ActorNode

+ (GLSLNode *)glslNodeWithShaderName:(NSString *)shaderName ;

- (instancetype)init NS_UNAVAILABLE;

@end
