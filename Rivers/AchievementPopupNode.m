//
//  AchievementPopupNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "AchievementPopupNode.h"

#import "SoundManager.h"

#import "ImageNode.h"
#import "LabelNode.h"


@interface AchievementPopupNode ()
{
    GKAchievementDescription *achievementDescription;
    UIImage *achievementImage;
    
    LabelNode *descriptionNode;
    
    ImageNode *tagNode;
    ImageNode *backgroundNode;
}
@end

@implementation AchievementPopupNode

+ (AchievementPopupNode *)popupWithAchievementDescription:(GKAchievementDescription *)description andImage:(UIImage *)image {
    
    AchievementPopupNode *newPopup = [[AchievementPopupNode alloc] initWithAchievementDescription:description andImage:image];
    
    return newPopup;
}

- (instancetype)initWithAchievementDescription:(GKAchievementDescription *)description andImage:(UIImage *)image {
    
    self = [super init];
    
    if (self != nil)
    {
        achievementDescription = description;
        achievementImage = image;
    }
    
    return self;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    backgroundNode = [ImageNode imageWithTextureNamed:@"achievements.png"];
    
    [backgroundNode setScale:SCNVector3Make(2.24f, 0.48f, 1.0f)];
    [backgroundNode setPosition:SCNVector3Zero];
    [backgroundNode setIntensity:0.5f];
    
    [backgroundNode setup:self];
    
    NSShadow *myShadow = [NSShadow new];
    [myShadow setShadowColor:[UIColor blackColor]];
    [myShadow setShadowBlurRadius:5.0];
    [myShadow setShadowOffset:CGSizeMake(2, 2)];
    
    NSString *text = [NSString stringWithFormat:@"%@", achievementDescription.title];
//    NSString *text = [NSString stringWithFormat:@"%@\n%@", achievementDescription.title, achievementDescription.achievedDescription];
    descriptionNode = [LabelNode setLabelWithText:text withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    
    [descriptionNode setShadow:myShadow];
    [descriptionNode setLineSpacing:0.5f];
    [descriptionNode setFixedWidth:512.0f];
    
    [descriptionNode setScale:SCNVector3Make(1.4f, 0.20f, 1.0f)];
    [descriptionNode setPosition:SCNVector3Make(0.0f, 0.0f, 0.01f)];
    
    [descriptionNode setup:self];
    
    SCNVector3 requiredPosition = self.position;
    
    [self setPosition:SCNVector3Make(requiredPosition.x, 5.0f, requiredPosition.z)];

    [self runAction:[SCNAction sequence:@[
                                          [SCNAction moveTo:requiredPosition duration:0.75],
                                          [SoundManager achievementSoundActionWithWaitForCompletion:NO],
                                          [SCNAction waitForDuration:3.5],
                                          [SCNAction fadeOutWithDuration:0.35],
                                          [SCNAction removeFromParentNode]
                                          ]
                     ]
     ];
    
    tagNode = [ImageNode imageWithImage:achievementImage];
    
    [tagNode setScale:SCNVector3Make(0.75f, 0.75f, 1.0f)];
    [tagNode setPosition:SCNVector3Make(-2.25f, 0.0f, 0.05f)];
    [tagNode setIntensity:0.5f];
    
    [tagNode setup:self];
}

- (void)activate {
    
    [super activate];
    
    [backgroundNode activate];
    
    [descriptionNode activate];
    
    [tagNode activate];
}

- (void)deactivate {
    
    [backgroundNode deactivate];
    
    [descriptionNode deactivate];
    
    [tagNode deactivate];
    
    [super deactivate];
}

@end
