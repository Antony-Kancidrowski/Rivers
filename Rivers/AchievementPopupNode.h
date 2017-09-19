//
//  AchievementPopupNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "ActorNode.h"

@interface AchievementPopupNode : ActorNode

+ (AchievementPopupNode *)popupWithAchievementDescription:(GKAchievementDescription *)description andImage:(UIImage *)image;

- (instancetype)init NS_UNAVAILABLE;

- (void)activate;
- (void)deactivate;

@end
