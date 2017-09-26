//
//  TileNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 25/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "ActorNode.h"
#import "Types.h"

@interface TileNode : ActorNode

@property (nonatomic, strong) NSString *tagName;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTagName:(NSString *)name andSize:(SCNVector3)size andScale:(SCNVector3)scale;

- (void)activate;
- (void)deactivate;

@end
