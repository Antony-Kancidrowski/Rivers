//
//  GameCenterManager.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "AppSpecificValues.h"

#import "GameCenterManager.h"

#import "LeaderboardModel.h"
#import <GameKit/GameKit.h>


@interface GameCenterManager ()
{
    NSLock *writeLock;
}

@property (strong, readonly, nonatomic) NSString *storedScoresFilename;
@property (strong, readonly, nonatomic) NSMutableArray *storedScores;


// Resubmit stored scores and remove from stored scores array.
- (void)resubmitStoredScores;

// Save store on disk. 
- (void)writeStoredScore;

// Load stored scores from disk.
- (void)loadStoredScores;

// Store score for submission at a later time.
- (void)storeScore:(GKScore *) score;

// Try to submit score, store on failure.
- (void)submitScore:(GKScore *) score;


@property (strong, readonly, nonatomic) NSString *storedAchievementsFilename;
@property (strong, readonly, nonatomic) NSMutableDictionary *storedAchievements;

// Resubmit any local instances of GKAchievement that was stored on a failed submission. 
- (void)resubmitStoredAchievements;

// Write all stored achievements for future resubmission
- (void)writeStoredAchievements;

// Load stored achievements that haven't been submitted to the server 
- (void)loadStoredAchievements;

// Store an achievement for future resubmit 
- (void)storeAchievement:(GKAchievement *) achievement;

// Submit an achievement 
- (void)submitAchievement:(GKAchievement *) achievement;


@end

@implementation GameCenterManager

@synthesize earnedAchievementCache;
@synthesize achievementDescriptions;

@synthesize currentLeaderBoard;
@synthesize delegate;

@synthesize storedScores, storedScoresFilename;
@synthesize storedAchievements, storedAchievementsFilename;


+ (GameCenterManager *)sharedGameCenterManager
{	
    static GameCenterManager *sharedGameCenterManager;
    
    @synchronized(self)
    {
        if (!sharedGameCenterManager)
            sharedGameCenterManager = [GameCenterManager new];
	}
	
    return sharedGameCenterManager;
}

- (instancetype)init
{
	self = [super init];
    
	if (self != NULL)
	{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        storedScoresFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedScores_v2.plist", path, [GKLocalPlayer localPlayer].playerID];
        storedAchievementsFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedAchievements_v2.plist", path, [GKLocalPlayer localPlayer].playerID];
        
        writeLock = [NSLock new];
        
		earnedAchievementCache = NULL;
        currentLeaderBoard = kZenLeaderboardID;
        
        self.isAuthenticated = NO;
        
        self.achievementManager = [AchievementPopupManagerNode new];
	}
    
	return self;
}

+ (BOOL)isGameCenterAvailable
{
	// Check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// Check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (NSUInteger)totalAchievements
{
    return [self.achievementDescriptions count];
}

- (NSUInteger)noOfAchievementsEarned
{
    return [self.earnedAchievementCache count];
}

- (void)authenticateLocalPlayer:(UIViewController *)parentViewController
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {

        if (viewController != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [parentViewController.view addSubview:viewController.view];
                           });
//            
//            // If it's needed display the login view controller.
//            [parentViewController presentViewController:viewController animated:YES completion:nil];
            
        } else {
        
            if ([delegate respondsToSelector:@selector(processGameCenterAuth:)]) {
                
                self.isAuthenticated = YES;
                [delegate processGameCenterAuth:nil];
            }
        }

    };
}

- (void)loadLeaderBoardForCategory:(NSString *)category withScope:(GKLeaderboardTimeScope)scope
{
	GKLeaderboard *leaderBoard = [GKLeaderboard new];
    
    if (leaderBoard)
    {
        leaderBoard.identifier = category;
        leaderBoard.timeScope = scope;
        leaderBoard.range = NSMakeRange(1, 10);
	
        [leaderBoard loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error)
        {
            if (error == NULL)
            {
                NSMutableArray *tempCache = [NSMutableArray new];
                
                for (GKScore *score in scores)
                {
                    [tempCache addObject:score.player];
                }
                
                [GKPlayer loadPlayersForIdentifiers:tempCache withCompletionHandler:^(NSArray *players, NSError *error)
                {
                    NSMutableArray *leaderboardPlayers = [NSMutableArray new];
                    
                    if (error == NULL)
                    { 
                        for (int i = 0; i < [players count]; i++)
                        {
                            LeaderboardModel *model = [LeaderboardModel new];
                            
                            model.score = [scores objectAtIndex:i];
                            model.player = [players objectAtIndex:i];
                            
                            [leaderboardPlayers addObject:model];
                        }
                    }
                    
                    if ([delegate respondsToSelector:@selector(loadLeaderBoardComplete:error:)]) {
                        
                        [delegate loadLeaderBoardComplete:leaderboardPlayers error:error];
                    }
                }];
                
                if ([tempCache count] == 0)
                {
                    if ([delegate respondsToSelector:@selector(loadLeaderBoardComplete:error:)]) {
                        
                        [delegate loadLeaderBoardComplete:nil error:error];
                    }
                }
            }
            else
            {
                // Something broke loading the earned achievements.
                
            }
        }];
    }
}

- (void)reportScore:(int64_t)value forCategory:(NSString *)category 
{    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:category];
    
    if (score)
    {
        score.value = value;
    
        [self submitScore:score];
    }
}

- (void)loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *achievements, NSError *error) {
        
        if (error != nil) {
             
            NSLog(@"Faile to load achievement because of error: %@", error);
        }
         
        if (achievements != nil) {

            NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity: [achievements count]];

            for (GKAchievement *achievement in achievements) {
                
                GKAchievement *cached = [self.earnedAchievementCache objectForKey:achievement.identifier];

                if (cached == NULL) {

                    [tempCache setObject: achievement forKey: achievement.identifier];
                }
            }

            if (self.earnedAchievementCache == NULL) {
                
                self.earnedAchievementCache = tempCache;
            } else {
                
                [self.earnedAchievementCache addEntriesFromDictionary:tempCache];
            }   
        }
        
        if ([delegate respondsToSelector:@selector(loadAchievementsEarnedComplete:error:)]) {
            
            [delegate loadAchievementsEarnedComplete:achievements error:error];
        }
        
        // Get all the achievements
        [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler: ^(NSArray *descriptions, NSError *error) {
            
            if (error != nil) {
                
                NSLog(@"Faile to load achievement descriptions because of error: %@", error);
            }
            
            if (descriptions != nil) {
                
                // use the achievement descriptions.
                NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity: [descriptions count]];
                
                for (GKAchievementDescription *description in descriptions) {
                    
                    [tempCache setObject: description forKey: description.identifier];
                }
                
                self.achievementDescriptions = tempCache;
            }
            
            if ([delegate respondsToSelector:@selector(loadAchievementsComplete:error:)]) {
                
                [delegate loadAchievementsComplete:achievements error:error];
            }
        }];
    }];
}

- (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete
{
    // Search the list for the ID we're using...
    GKAchievement* achievement = [self.earnedAchievementCache objectForKey:identifier];
    
    if (achievement != NULL)
    {
        if ((achievement.percentComplete >= 100.0) || 
            (achievement.percentComplete >= percentComplete))
        {
            // Achievement has already been earned so we're done.
            achievement = NULL;
        }
        
        achievement.percentComplete = percentComplete;
    }
    else
    {
        achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
        achievement.percentComplete = percentComplete;
        
        // Add achievement to achievement cache...
        [self.earnedAchievementCache setObject:achievement forKey:achievement.identifier];
    }
    
    if (achievement != NULL)
    {
        [self submitAchievement:achievement];
    }
}

- (void)mapPlayerIDtoPlayer:(NSString*)playerID
{
	[GKPlayer loadPlayersForIdentifiers: [NSArray arrayWithObject: playerID] withCompletionHandler:^(NSArray* playerArray, NSError* error)
	{
		GKPlayer *player = NULL;
        
		for (GKPlayer* tempPlayer in playerArray)
		{
			if ([tempPlayer.playerID isEqualToString: playerID])
			{
				player = tempPlayer;
				break;
			}
		}

        if ([delegate respondsToSelector:@selector(mappedPlayerIDToPlayer:error:)]) {
            
            [delegate mappedPlayerIDToPlayer:player error:error];
        }
	}];
	
}


#pragma mark - 
#pragma mark Scores

// Attempt to resubmit the scores.
- (void)resubmitStoredScores
{
    if (storedScores)
    {
        // Keeping an index prevents new entries to be added when the network is down 
        int index = (int)[storedScores count] - 1;
        
        while( index >= 0 )
        {
            GKScore *score = [storedScores objectAtIndex:index];
            
            [self submitScore:score];
            [storedScores removeObjectAtIndex:index];
            index--;
        }
        
        [self writeStoredScore];
    }
}

// Load stored scores from disk.
- (void)loadStoredScores
{
    NSArray *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:storedScoresFilename];
    
    if (unarchivedObj)
    {
        storedScores = [[NSMutableArray alloc] initWithArray:unarchivedObj];
        [self resubmitStoredScores];
    }
    else
    {
        storedScores = [NSMutableArray new];
    }
}


// Save stored scores to file. 
- (void)writeStoredScore
{
    [writeLock lock];
    {
        NSData *archivedScore = [NSKeyedArchiver archivedDataWithRootObject:storedScores];
        NSError *error;
        
        [archivedScore writeToFile:storedScoresFilename options:NSDataWritingFileProtectionNone error:&error];
        
        if (error)
        {
            //  Error saving file, handle accordingly 
        }
    }
    [writeLock unlock];
}

// Store score for submission at a later time.
- (void)storeScore:(GKScore *)score 
{
    [storedScores addObject:score];
    [self writeStoredScore];
}

// Attempt to submit a score. On an error store it for a later time.
- (void)submitScore:(GKScore *)score 
{    
    if (score)
    {
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            
            if (!error || (![error code] && ![error domain]))
            {
                NSLog(@"Score %lld submitted for %@", score.value, score.leaderboardIdentifier);

                // Score submitted correctly. Resubmit others
                [self resubmitStoredScores];
            }
            else
            {
                // Store score for next authentication.
                [self storeScore:score];
            }

            if ([delegate respondsToSelector:@selector(scoreReported:)]) {
                
                [delegate scoreReported:nil];
            }
        }];
    } 
}


#pragma mark - 
#pragma mark Achievements


// Try to submit all stored achievements to update any achievements that were not successful. 
- (void)resubmitStoredAchievements
{
    if (storedAchievements)
    {
        for (NSString *key in storedAchievements)
        {
            GKAchievement *achievement = [storedAchievements objectForKey:key];
            
            [storedAchievements removeObjectForKey:key];
            [self submitAchievement:achievement];
        } 
        
		[self writeStoredAchievements];
    }
}

// Load stored achievements and attempt to submit them
- (void)loadStoredAchievements
{
    if (!storedAchievements)
    {
        NSDictionary *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:storedAchievementsFilename];;
        
        if (unarchivedObj)
        {
            storedAchievements = [[NSMutableDictionary alloc] initWithDictionary:unarchivedObj];
            [self resubmitStoredAchievements];
            
        }
        else
        {
            storedAchievements = [NSMutableDictionary new];
        }
    }    
}

// Store achievements to disk to submit at a later time.
- (void)writeStoredAchievements
{
    [writeLock lock];
    {
        NSData *archivedAchievements = [NSKeyedArchiver archivedDataWithRootObject:storedAchievements];
        NSError *error;
        
        [archivedAchievements writeToFile:storedAchievementsFilename options:NSDataWritingFileProtectionNone error:&error];
        
        if (error)
        {
            //  Error saving file, handle accordingly
        }
    }
    [writeLock unlock];
}

// Submit an achievement to the server and store if submission fails
- (void)submitAchievement:(GKAchievement *)achievement 
{
    if (achievement)
    {
        // Submit the achievement.
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            
            BOOL showPopup = TRUE;
            
            if (error)
            {
                // Store achievement to be submitted at a later time.
                [self storeAchievement:achievement];
                
            }
            else
            {
                if ([storedAchievements objectForKey:achievement.identifier])
                {
                    // Achievement is reported, remove from store.
                    [storedAchievements removeObjectForKey:achievement.identifier];
                    
                    showPopup = FALSE;
                }
                
                [self resubmitStoredAchievements];
            }
            
            if (showPopup)
            {
                if ([delegate respondsToSelector:@selector(achievementSubmitted:error:)]) {
                    
                    [delegate achievementSubmitted:achievement error:error];
                }
            }
        }];
    }
}

// Create an entry for an achievement that hasn't been submitted to the server 
- (void)storeAchievement:(GKAchievement *)achievement 
{
    GKAchievement *currentStorage = [storedAchievements objectForKey:achievement.identifier];
    
    if (!currentStorage || (currentStorage && currentStorage.percentComplete < achievement.percentComplete)) {
        
        [storedAchievements setObject:achievement forKey:achievement.identifier];
        [self writeStoredAchievements];
    }
}

// Reset all the achievements for local player 
- (void)resetAchievements
{
    self.earnedAchievementCache = NULL;
    
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) 
    {
        if (!error)
        {
            storedAchievements = [NSMutableDictionary new];
             
            // overwrite any previously stored file
            [self writeStoredAchievements];
             
        }
        else
        {
             // Error clearing achievements. 
        }

        if ([delegate respondsToSelector:@selector(achievementResetResult:)]) {
            
            [delegate achievementResetResult:nil];
        }
    }];
}

@end
