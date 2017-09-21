//
//  MainMenuNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "MainMenuNode.h"

#import "GameCenterManager.h"
#import "SoundManager.h"

#import "ImageButtonNode.h"

@interface MainMenuNode ()
{
    ImageButtonNode *blockButton;
    ImageButtonNode *tutorialButton;
    ImageButtonNode *starButton;
    ImageButtonNode *trophyButton;
    
    ImageButtonNode *settingsButton;
    
    SCNAction *menuOn;
    SCNAction *menuOff;
}

@end

@implementation MainMenuNode

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    const CGFloat menuWidth = 320.0f;
    const CGFloat menuHeight = 80.0f;
    
    const CGFloat scale = 0.35f;
    
    blockButton = [ImageButtonNode imageButtonWithName:@"redbutton" andButtonColor:nil andTagName:@"block" andTagAlignment:TagHorizontalAlignmentLeft];
    [blockButton setLabelWithText:NSLocalizedString(@"Play Game", nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [blockButton setLabelFixedWidth:menuWidth];
    [blockButton setLabelFixedHeight:menuHeight];
    [blockButton setLabelPosition:SCNVector3Make(0.0f, -0.1f, 0.05f)];
    
    [blockButton setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [blockButton setPosition:SCNVector3Make(0, 1.0, 0.0f)];
    
    [blockButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [blockButton addTarget:self action:@selector(playGame) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [blockButton setup:self];
    
    tutorialButton = [ImageButtonNode imageButtonWithName:@"yellowbutton" andButtonColor:nil andTagName:@"tutorial" andTagAlignment:TagHorizontalAlignmentRight];
    [tutorialButton setLabelWithText:NSLocalizedString(@"Tutorial", nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [tutorialButton setLabelFixedWidth:menuWidth];
    [tutorialButton setLabelFixedHeight:menuHeight];
    [tutorialButton setLabelPosition:SCNVector3Make(0.0f, -0.1f, 0.05f)];
    
    [tutorialButton setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [tutorialButton setPosition:SCNVector3Make(0, 0.50f, 0.0f)];
    
    [tutorialButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [tutorialButton addTarget:self action:@selector(tutorial) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [tutorialButton setup:self];
    
    trophyButton = [ImageButtonNode imageButtonWithName:@"greenbutton" andButtonColor:nil andTagName:@"trophy" andTagAlignment:TagHorizontalAlignmentLeft];
    [trophyButton setLabelWithText:NSLocalizedString(@"Leaderboards", nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [trophyButton setLabelFixedWidth:menuWidth];
    [trophyButton setLabelFixedHeight:menuHeight];
    [trophyButton setLabelPosition:SCNVector3Make(0.0f, -0.1f, 0.05f)];
    
    [trophyButton setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [trophyButton setPosition:SCNVector3Make(0, 0.0f, 0.0f)];
    [trophyButton EnableButton:NO];
    
    [trophyButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [trophyButton addTarget:self action:@selector(leaderBoard) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [trophyButton setup:self];
    
    starButton = [ImageButtonNode imageButtonWithName:@"bluebutton" andButtonColor:nil andTagName:@"star" andTagAlignment:TagHorizontalAlignmentRight];
    [starButton setLabelWithText:NSLocalizedString(@"Achievements", nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [starButton setLabelFixedWidth:menuWidth];
    [starButton setLabelFixedHeight:menuHeight];
    [starButton setLabelPosition:SCNVector3Make(0.0f, -0.1f, 0.05f)];
    
    [starButton setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [starButton setPosition:SCNVector3Make(0, -0.50f, 0.0f)];
    [starButton EnableButton:NO];
    
    [starButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [starButton addTarget:self action:@selector(achievements) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [starButton setup:self];
    
    settingsButton = [ImageButtonNode imageButtonWithName:@"orangebutton" andButtonColor:nil andTagName:@"cogs" andTagAlignment:TagHorizontalAlignmentLeft];
    [settingsButton setLabelWithText:NSLocalizedString(@"Settings", nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [settingsButton setLabelFixedWidth:menuWidth];
    [settingsButton setLabelFixedHeight:menuHeight];
    [settingsButton setLabelPosition:SCNVector3Make(0.0f, -0.1f, 0.05f)];
    
    [settingsButton setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [settingsButton setPosition:SCNVector3Make(0, -1.0f, 0.0f)];
    
    [settingsButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [settingsButton addTarget:self action:@selector(settings) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [settingsButton setup:self];
    
    menuOn = [SCNAction rotateByX:0.0f y:M_PI_2 z:0.0f duration:0.25];
    menuOff = [SCNAction rotateByX:0.0f y:-M_PI_2 z:0.0f duration:0.25];
}

- (void)activate {
    
    [super activate];
    
    [blockButton activate];
    [tutorialButton activate];
    [starButton activate];
    [trophyButton activate];
    
    [settingsButton activate];
    
    [trophyButton EnableButton:[[GameCenterManager sharedGameCenterManager] isAuthenticated]];
    [starButton EnableButton:[[GameCenterManager sharedGameCenterManager] isAuthenticated]];
}

- (void)deactivate {
    
    [blockButton deactivate];
    [tutorialButton deactivate];
    [starButton deactivate];
    [trophyButton deactivate];
    
    [settingsButton deactivate];
    
    [super deactivate];
}

#pragma mark Update

- (void)authenticateGKPlayer:(BOOL)authenticated {

    [trophyButton EnableButton:authenticated];
    [starButton EnableButton:authenticated];
}

#pragma mark Navigation

- (void)playGame {
    
    id<MainMenuDelegate> delegate = self.delegate;
    
    if ([delegate respondsToSelector:@selector(playGame)]) {
        
        [delegate playGame];
    }
}

- (void)tutorial {
    
    id<MainMenuDelegate> delegate = self.delegate;
    
    if ([delegate respondsToSelector:@selector(tutorial)]) {
        
        [delegate tutorial];
    }
}

- (void)leaderBoard {
    
    id<MainMenuDelegate> delegate = self.delegate;
    
    if ([delegate respondsToSelector:@selector(leaderBoard)]) {
        
        [delegate leaderBoard];
    }
}

- (void)achievements {
    
    id<MainMenuDelegate> delegate = self.delegate;
    
    if ([delegate respondsToSelector:@selector(achievements)]) {
        
        [delegate achievements];
    }
}

- (void)settings {
    
    id<MainMenuDelegate> delegate = self.delegate;
    
    if ([delegate respondsToSelector:@selector(settings)]) {
        
        [delegate settings];
    }
}

@end
