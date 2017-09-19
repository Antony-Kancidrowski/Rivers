//
//  LeaderboardModel.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface LeaderboardModel : NSObject
{
    GKPlayer *player;
    GKScore *score;
}

@property (strong, nonatomic) GKPlayer *player;
@property (strong, nonatomic) GKScore *score;


@end
