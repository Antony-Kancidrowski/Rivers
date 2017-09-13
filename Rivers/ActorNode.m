//
//  ActorNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"

@interface ActorNode ()
{
    SCNNode *actorParentNode;
    BOOL activeNode;
}

@end

@implementation ActorNode

- (instancetype)initWithTextureNamed:(NSString *)textureName andSize:(CGSize)size {
    
    self = [super init];
    
    if (self != nil)
    {
        activeNode = NO;
    }
    
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    
    SCNMaterial *material = self.geometry.firstMaterial;
    
    material.diffuse.intensity = intensity;
    material.specular.intensity = intensity;
}

#pragma mark ActorActivation

- (void)activate {
    
    if (!activeNode) {
    
        [actorParentNode addChildNode:self];
        activeNode = YES;
    }
}

- (void)deactivate {
    
    if (activeNode) {
    
        [self removeFromParentNode];
        activeNode = NO;
    }
}

- (void)setup:(SCNNode*)parentNode {
    
    actorParentNode = parentNode;
}

#pragma mark ActorRestorableState

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    
}

@end
