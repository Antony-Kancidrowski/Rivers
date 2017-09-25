//
//  FlyingTilesManagerNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 25/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "ActorNode.h"
#import "Types.h"

@interface FlyingTilesManagerNode : ActorNode

- (instancetype)init;

- (void)activate;
- (void)deactivate;

- (void)setup:(SCNNode*)parentNode;

@end
