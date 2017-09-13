//
//  CameraNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "Types.h"

@interface CameraNode : SCNNode

@property (strong, nonatomic) SCNNode *mainCameraNode;
@property (strong, nonatomic) SCNNode *orientationNode;

- (void)activate:(SCNNode *)parentNode;

- (void)zoomOut;
- (void)zoomIn;

- (void)setXFov:(double)value;
- (void)setYFov:(double)value;

- (void)changeXFov:(double)change;
- (void)changeYFov:(double)change;

- (void)pan:(CGFloat)change direction:(NodeDirection)direction;

@end
