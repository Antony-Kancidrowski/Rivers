//
//  CameraNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "CameraNode.h"

@interface CameraNode ()
{
    
}

@end

@implementation CameraNode

@synthesize mainCameraNode;
@synthesize orientationNode;

#pragma mark - Camera

- (void)activate:(SCNNode *)parentNode {
    
    // |_   self
    //   |_   cameraOrientation
    //     |_   cameraNode
    
    // Create a main camera
    mainCameraNode = [SCNNode node];
    mainCameraNode.position = SCNVector3Make(0.0f, 0.0f, 7.25f);
    
    orientationNode = [SCNNode node];
    
    [orientationNode setEulerAngles:SCNVector3Make(M_PI_2, 0.0f, 0.0f)];
    
    [parentNode addChildNode:self];
    [self addChildNode:orientationNode];
    [orientationNode addChildNode:mainCameraNode];
    
    mainCameraNode.camera = [SCNCamera camera];
    
    mainCameraNode.camera.zFar = 100;
    
    mainCameraNode.camera.yFov = 46;
    
    // create and add a light to the scene
//    SCNNode *lightNode = [SCNNode node];
//    lightNode.light = [SCNLight light];
//    lightNode.light.type = SCNLightTypeOmni;
//    lightNode.position = SCNVector3Make(0.0f, 0.0f, 0.0f);
//    
//    [mainCameraNode addChildNode:lightNode];
}

- (void)zoomOut {
    
    [mainCameraNode runAction:[SCNAction moveByX:0.0f y:0.0f z:5.0f duration:0.5]];
}

- (void)zoomIn {
    
    [mainCameraNode runAction:[SCNAction moveByX:0.0f y:0.0f z:-5.0f duration:0.5]];
}

- (void)setXFov:(double)value {
    
    mainCameraNode.camera.xFov = 25 + value;
}

- (void)setYFov:(double)value {
    
    mainCameraNode.camera.yFov = 25 + value;
}

- (void)changeXFov:(double)change {
    
    mainCameraNode.camera.xFov += change;
}

- (void)changeYFov:(double)change {
    
    mainCameraNode.camera.yFov += change;
}

- (void)pan:(CGFloat)change direction:(NodeDirection)direction {
    
    CGFloat x = 0.0f;
    CGFloat z = 0.0f;
    
    if ((direction == MOVES_UP) || (direction == MOVES_DOWN)) {
        
        z = (direction == MOVES_DOWN) ? change : -change;
    }
    
    if ((direction == MOVES_LEFT) || (direction == MOVES_RIGHT)) {
        
        x = (direction == MOVES_RIGHT) ? change : -change;
    }
    
    [self runAction:[SCNAction moveByX:x y:0.0f z:z duration:0.5]];
}

@end
