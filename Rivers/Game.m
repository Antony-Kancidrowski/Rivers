//
//  Game.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "Game.h"

#define SCHEMA_VERSION 4

static NSString *GameSchemaVersion = @"SchemaVersion";

static NSString *GameName = @"GameName";

static NSString *GameMoves = @"GameMoves";
static NSString *GameAssistedMoves = @"GameAssistedMoves";

static NSString *GameTime = @"GameTime";
static NSString *GameCompleted = @"GameCompleted";
static NSString *GameHelpUsed = @"GameHelpUsed";
static NSString *GameLocked = @"GameLocked";

static NSString *GameShowTimer = @"GameShowTimer";

static NSString *GameGameType = @"GameGameType";

static NSString *GameGameSelected = @"GameGameSelected";

@implementation Game

@synthesize name;

@synthesize moves;
@synthesize assistedMoves;

@synthesize time;
@synthesize completed;
@synthesize helpUsed;

@synthesize locked;

@synthesize gameType;

@synthesize showTimer;

@synthesize gameSelected;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:SCHEMA_VERSION forKey:GameSchemaVersion];
    
    [aCoder encodeObject:self.name forKey:GameName];
    
    [aCoder encodeInteger:self.moves forKey:GameMoves];
    [aCoder encodeInteger:self.assistedMoves forKey:GameAssistedMoves];
    
    [aCoder encodeDouble:self.time forKey:GameTime];
    [aCoder encodeBool:self.completed forKey:GameCompleted];
    [aCoder encodeBool:self.helpUsed forKey:GameHelpUsed];
    
    [aCoder encodeBool:self.locked forKey:GameLocked];
    
    [aCoder encodeBool:self.showTimer forKey:GameShowTimer];
    
    [aCoder encodeInteger:gameType forKey:GameGameType];
    
    [aCoder encodeInteger:gameSelected forKey:GameGameSelected];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        int version = [aDecoder decodeIntForKey:GameSchemaVersion];
        
        if (1 <= version)
        {
            self.name = [aDecoder decodeObjectForKey:GameName];
            
            if (3 < version) {
            
                self.moves = [aDecoder decodeIntForKey:GameMoves];
            }
            
            self.time = [aDecoder decodeDoubleForKey:GameTime];
            self.completed = [aDecoder decodeBoolForKey:GameCompleted];
        }
        
        if (2 <= version)
        {
            self.helpUsed = [aDecoder decodeBoolForKey:GameHelpUsed];
        }
        
        if (3 <= version)
        {
            self.moves = [aDecoder decodeIntegerForKey:GameMoves];
            self.assistedMoves = [aDecoder decodeIntegerForKey:GameAssistedMoves];
        }
        
        if (4 <= version)
        {
            self.locked = [aDecoder decodeBoolForKey:GameLocked];
            
            self.showTimer = [aDecoder decodeBoolForKey:GameShowTimer];
            
            self.gameType = [aDecoder decodeIntegerForKey:GameGameType];
            
            self.gameSelected = [aDecoder decodeIntegerForKey:GameGameSelected];
        }
    }
    
    return self;
}


@end
