//
//  GamesManager.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConsumablePurchasesController.h"
#import "Game.h"

@interface GamesManager : NSObject

@property (strong, nonatomic) ConsumablePurchasesController *consumablePurchasesController;

@property (strong, readonly, nonatomic) NSMutableArray *storedZenGames;
@property (strong, readonly, nonatomic) NSMutableArray *storedReverseGames;
@property (strong, readonly, nonatomic) NSMutableArray *storedTimedGames;

@property (assign) int gamesWonThisSession;
@property (assign) int movesThisGame;
@property (assign) BOOL nowYouSeeIt;
@property (assign) BOOL gameExited;

+ (GamesManager *)sharedGamesManager;

- (void)load;
- (void)save;

- (void)setUp;

//- (BOOL)checkRules;
//- (void)initialiseRules;

- (void)initialiseConsumablePurchases;

- (void)initialiseStoredGames;

- (void)unlockNextGame:(Game *)game;


@end
