//
//  ActorNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "AppSpecificValues.h"

@interface ActorNode : SCNNode

- (void)activate;
- (void)deactivate;

- (void)setup:(SCNNode*)parentNode;

- (void)setIntensity:(CGFloat)intensity;

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder;
- (void)decodeRestorableStateWithCoder:(NSCoder *)coder;

@end
