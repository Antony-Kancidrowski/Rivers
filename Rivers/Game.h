//
//  Game.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Types.h"

@interface Game : NSObject <NSCoding>
{
    
}

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL locked;

@property (nonatomic, assign) NSInteger moves;
@property (nonatomic, assign) NSInteger assistedMoves;

@property (nonatomic, assign) double time;
@property (nonatomic, assign) BOOL helpUsed;
@property (nonatomic, assign) BOOL completed;

@property (nonatomic, assign) BOOL showTimer;

@property (nonatomic, assign) GameType gameType;

@property (nonatomic, assign) NSInteger gameSelected;

@end
