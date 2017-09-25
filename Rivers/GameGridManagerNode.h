//
//  GameGridManagerNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 25/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"
#import "Types.h"

@interface GameGridManagerNode : ActorNode

+ (GameGridManagerNode *)gridManagerWithType:(GameType)gameType;

- (instancetype)init NS_UNAVAILABLE;

@end
