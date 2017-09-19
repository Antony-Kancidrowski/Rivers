//
//  AchievementPopupManagerNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "AchievementPopupManagerNode.h"
#import "AchievementPopupNode.h"

#import "DebugOptions.h"

#import "GameCenterManager.h"
@interface AchievementPopupManagerNode ()
{
    NSDate *popupOffsetReset;
    CGFloat popupOffset;
}
@end

@implementation AchievementPopupManagerNode

static dispatch_queue_t sAchievementQueue;

- (void)activate {
    
    [super activate];
    
    sAchievementQueue = dispatch_queue_create("com.cidrosoft.rivers.Achievement.Queue", DISPATCH_QUEUE_SERIAL);
    
    popupOffsetReset = [NSDate date];
    popupOffset = 0.0f;
}

- (void)deactivate {
    
    sAchievementQueue = nil;
    
    for (AchievementPopupNode *popup in self.childNodes) {
        
        [popup deactivate];
    }
    
    [super deactivate];
}

- (void)push:(NSString *)achievementId {
    
    GameCenterManager *gameCenterManager = [GameCenterManager sharedGameCenterManager];
    
    [gameCenterManager loadAchievements];
    
    GKAchievementDescription *description = [gameCenterManager.achievementDescriptions objectForKey:achievementId];
    
    if (description != NULL)
    {
        [description loadImageWithCompletionHandler:^(UIImage *image, NSError *error)
         {
             if (error == NULL)
             {
                 // Dispatch a new consumer task
                 dispatch_async(sAchievementQueue, ^{
                     
                     if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                         NSLog(@"Achievement Consumer: %@\n%@\n%@", achievementId, description.title, description.achievedDescription);
                     
                     NSDate *now = [NSDate date];
                     
                     if (NSOrderedDescending == [now compare:popupOffsetReset]) {
                         
                         popupOffsetReset = [now dateByAddingTimeInterval:5.0];
                         popupOffset = 0.0f;
                         
                     } else {
                         
                         popupOffset -= 0.29f;
                     }
                     
                     // Setup the AchievementPopupNode
                     AchievementPopupNode *popup = [AchievementPopupNode popupWithAchievementDescription:description andImage:image];
                     [popup setScale:SCNVector3Make(0.4f, 0.4f, 1.0f)];
                     [popup setPosition:SCNVector3Make(0.0f, popupOffset, 0.0f)];
                     
                     [popup setup:self];
                     
                     [popup activate];
                     
                 });
             }
             else
             {
//                 NSLog(@"Error loading achievement image.");
             }
         }];
    }
}

@end
