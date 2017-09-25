//
//  GameGridManagerNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 25/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "GameGridManagerNode.h"

@interface GameGridManagerNode ()
{
}

@property (nonatomic, assign) GameType gameType;

@end

@implementation GameGridManagerNode

+ (GameGridManagerNode *)gridManagerWithType:(GameType)gameType {
    
    GameGridManagerNode *newManager = [[GameGridManagerNode alloc] initWithType:gameType];
    
    return newManager;
}

- (instancetype)initWithType:(GameType)gameType {
    
    self = [super init];
    
    if (self != nil)
    {
        self.gameType = gameType;
    }
    
    return self;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    // TODO:
}

- (void)activate {
    
    [super activate];
    
    // TODO:
}

- (void)deactivate {
    
    // TODO:
    
    [super deactivate];
}

@end
