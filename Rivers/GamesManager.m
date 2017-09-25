//
//  GamesManager.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "GamesManager.h"

#import "AppSpecificValues.h"
#import "Configuration.h"

#import <GameKit/GameKit.h>

//#import "RulesController.h"

#import "DebugOptions.h"


static NSString *NameKey = @"nameKey";
static NSString *ImageLeftKey = @"imageLeftKey";
static NSString *ImageRightKey = @"imageRightKey";
static NSString *TimeKey = @"timeKey";
static NSString *LockedKey = @"lockedKey";

static NSUInteger maxGameIndex = 10;

@interface GamesManager()
{
    NSLock *writeLock;
}

//@property (strong, nonatomic) RulesController *rulesController;


@property (strong, readonly, nonatomic) NSString *zenGamesFilename;

// Save zen games to disk. 
- (void)writeStoredZenGames;

// Load zen games from disk.
- (void)readStoredZenGames;

- (void)initialiseStoredZenGames;


@property (strong, readonly, nonatomic) NSString *timedGamesFilename;

// Save timed games to disk. 
- (void)writeStoredTimedGames;

// Load timed games from disk.
- (void)readStoredTimedGames;

- (void)initialiseStoredTimedGames;

@end


@implementation GamesManager

@synthesize storedZenGames, zenGamesFilename;
@synthesize storedTimedGames, timedGamesFilename;

@synthesize gamesWonThisSession;
@synthesize movesThisGame;
@synthesize nowYouSeeIt;

@synthesize gameExited;
//@synthesize rulesController;
@synthesize consumablePurchasesController;

+ (GamesManager *)sharedGamesManager
{	
    static GamesManager *sharedGamesManager;
    
    @synchronized(self)
    {
        if (!sharedGamesManager)
            sharedGamesManager = [GamesManager new];
	}
	
    return sharedGamesManager;
}

- (instancetype)init
{
	self = [super init];
    
	if (self != NULL)
	{
//        rulesController = [RulesController new];
        consumablePurchasesController = [ConsumablePurchasesController new];
        
        self.gamesWonThisSession = 0;
        
        [self setUp];
	}
    
	return self;
}

- (void)load
{
    [self readStoredZenGames];
    [self readStoredTimedGames];
}

- (void)save
{
    [self writeStoredZenGames];
    [self writeStoredTimedGames];
}

- (void)setUp
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    zenGamesFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedZenGames_v2.plist", path, [GKLocalPlayer localPlayer].playerID];
    timedGamesFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedTimedGames_v2.plist", path, [GKLocalPlayer localPlayer].playerID];
    
    writeLock = [NSLock new];
    
    [self load];
}

//- (BOOL)checkRules
//{
//    return [rulesController handleRules];
//}
//
//- (void)initialiseRules
//{
//    self.gamesWonThisSession = 0;
//    
//    [rulesController initialise];
//}

- (void)initialiseConsumablePurchases {
    
    [consumablePurchasesController initialise];
}

- (void)initialiseStoredGames
{
    [self initialiseStoredZenGames];
    [self initialiseStoredTimedGames];
}

#pragma mark Zen

- (void)writeStoredZenGames
{
    [writeLock lock];
    {
        NSData *archivedStore = [NSKeyedArchiver archivedDataWithRootObject:storedZenGames];
        NSError *error;
        
        [archivedStore writeToFile:zenGamesFilename options:NSDataWritingFileProtectionNone error:&error];
        
        if (error)
        {
            //  Error saving file, handle accordingly 
            NSLog(@"Error saving Zen Games progress.");
        }
    }
    [writeLock unlock];
}

- (void)initialiseStoredZenGames
{
    storedZenGames = [NSMutableArray new];
    
    // Setup the Zen Games Defaults
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameselection_v2" ofType:@"plist"];
    NSArray *contentList = [NSArray arrayWithContentsOfFile:path];
    
    Game *game = nil;
    
    for (int i = 0; i < maxGameIndex; i++)
    {
        NSDictionary *item = [contentList objectAtIndex:i];
        
        game = [Game new];
        
        game.name = [item valueForKey:NameKey];
        
        game.gameSelected = i;
        
        game.moves = 0;
        
        NSNumber *time = [item valueForKey:TimeKey];
        game.time = time.integerValue;
        
        game.completed = FALSE;
        game.helpUsed = FALSE;
        
        NSNumber *locked = [item valueForKey:LockedKey];
        game.locked = locked.boolValue;
        
        game.gameType = ZenGame;
        
        [storedZenGames addObject:game];
    }
}

- (void)readStoredZenGames
{
    NSArray *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:zenGamesFilename];
    
    if (unarchivedObj)
    {
        storedZenGames = [[NSMutableArray alloc] initWithArray:unarchivedObj];
    }
    else
    {
        [self initialiseStoredZenGames];
    }
}

#pragma mark Timed

- (void)writeStoredTimedGames
{
    [writeLock lock];
    {
        NSData *archivedStore = [NSKeyedArchiver archivedDataWithRootObject:storedTimedGames];
        NSError *error;
        
        [archivedStore writeToFile:timedGamesFilename options:NSDataWritingFileProtectionNone error:&error];
        
        if (error)
        {
            //  Error saving file, handle accordingly 
            NSLog(@"Error saving Timed Games progress.");
        }
    }
    [writeLock unlock];
}

- (void)initialiseStoredTimedGames
{
    storedTimedGames = [NSMutableArray new];
    
    // Setup the Timed Games Defaults
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameselection_v2" ofType:@"plist"];
    NSArray *contentList = [NSArray arrayWithContentsOfFile:path];
    
    Game *game = nil;
    
    for (int i = 0; i < maxGameIndex; i++)
    {
        NSDictionary *item = [contentList objectAtIndex:i];
        
        game = [Game new];
        
        game.name = [item valueForKey:NameKey];
        
        game.gameSelected = i;
        
        game.moves = 0;
        
        NSNumber *time = [item valueForKey:TimeKey];
        game.time = time.integerValue;
        
        game.completed = FALSE;
        game.helpUsed = FALSE;
        
        NSNumber *locked = [item valueForKey:LockedKey];
        game.locked = locked.boolValue;
        
        game.showTimer = TRUE;
        
        game.gameType = TimedGame;
        
        [storedTimedGames addObject:game];
    }
}

- (void)readStoredTimedGames
{
    NSArray *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:timedGamesFilename];
    
    if (unarchivedObj)
    {
        storedTimedGames = [[NSMutableArray alloc] initWithArray:unarchivedObj];
    }
    else
    {
        [self initialiseStoredTimedGames];
    }
}

#pragma mark Unlock

- (void)unlockNextGame:(Game *)game {
    
    if (game.gameSelected < maxGameIndex) {
        
        Game *nextGame = nil;
        
        NSUInteger nextGameSelection = game.gameSelected + 1;
        
        if (game.gameType == ZenGame) {
            
            nextGame = [[[GamesManager sharedGamesManager] storedZenGames] objectAtIndex:nextGameSelection];
            
        } else if (game.gameType == TimedGame) {
        
            nextGame = [[[GamesManager sharedGamesManager] storedTimedGames] objectAtIndex:nextGameSelection];
            
        }
        
        NSAssert(nextGame != nil, @"Invalid next game.");
        
        nextGame.locked = FALSE;
    }
}

@end
