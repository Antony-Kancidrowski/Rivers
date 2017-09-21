//
//  MainMenuNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"

@protocol MainMenuDelegate <NSObject>
@required
- (void)playGame;
- (void)tutorial;
- (void)leaderBoard;
- (void)achievements;
- (void)settings;
@end

@interface MainMenuNode : ActorNode

@property (nonatomic, weak) id<MainMenuDelegate> delegate;

- (void)authenticateGKPlayer:(BOOL)authenticated;

- (void)activate;
- (void)deactivate;

@end
