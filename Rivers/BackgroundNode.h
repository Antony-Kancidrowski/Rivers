//
//  BackgroundNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "ActorNode.h"

@protocol BackgroundProtocol <NSObject>
@optional
- (void)colorizeWithColor:(id)color;
- (void)animate;
- (void)setGLSLShader:(NSString *)name;
@end

@interface BackgroundNode : ActorNode <BackgroundProtocol>

- (void)activate;
- (void)deactivate;

@end
