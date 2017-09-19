//
//  AchievementPopupManagerNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"

@interface AchievementPopupManagerNode : ActorNode

-(void)push:(NSString *)achievementId;

- (void)activate;
- (void)deactivate;

@end
