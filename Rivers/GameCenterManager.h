//
//  GameCenterManager.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Gamekit/Gamekit.h>

#import "AchievementPopupManagerNode.h"

@class GKLeaderboard, GKAchievement, GKPlayer;



@protocol GameCenterManagerDelegate <NSObject>
@optional

- (void)processGameCenterAuth:(NSError *)error;
- (void)scoreReported:(NSError *)error;
- (void)loadLeaderBoardComplete:(NSArray *)scores error:(NSError *)error;
- (void)loadAchievementsComplete:(NSArray *)achievements error: (NSError *)error;
- (void)loadAchievementsEarnedComplete:(NSArray *)achievements error:(NSError *)error;
- (void)achievementSubmitted:(GKAchievement *)achievement error:(NSError *)error;
- (void)achievementResetResult:(NSError *)error;
- (void)mappedPlayerIDToPlayer:(GKPlayer *)player error:(NSError *)error;

@end

@interface GameCenterManager : NSObject

// This property must be attomic to ensure that the cache is always in a viable state...
@property (strong) NSMutableDictionary *earnedAchievementCache;
@property (strong) NSMutableDictionary *achievementDescriptions;

@property (nonatomic, strong) NSString *currentLeaderBoard;

@property (nonatomic, weak) id <GameCenterManagerDelegate> delegate;

@property (nonatomic, strong) AchievementPopupManagerNode *achievementManager;

@property (assign, nonatomic) BOOL isAuthenticated;

+ (BOOL)isGameCenterAvailable;
+ (GameCenterManager *)sharedGameCenterManager;

- (NSUInteger)totalAchievements;
- (NSUInteger)noOfAchievementsEarned;

- (void)authenticateLocalPlayer:(UIViewController *)parentViewController;

- (void)reportScore:(int64_t)value forCategory:(NSString *)category;
- (void)loadLeaderBoardForCategory:(NSString *)category withScope:(GKLeaderboardTimeScope)scope;

- (void)loadAchievements;

- (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete;
- (void)resetAchievements;

- (void)mapPlayerIDtoPlayer:(NSString *)playerID;


@end
