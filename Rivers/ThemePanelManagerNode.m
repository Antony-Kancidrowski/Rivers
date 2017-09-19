//
//  ThemePanelManagerNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ThemePanelManagerNode.h"

#import "ThemePanelNode.h"

#import "AppSpecificValues.h"

#import "SoundManager.h"

#import "ThemeManager.h"
#import "Theme.h"

#import "ImageButtonNode.h"

static const CGFloat offset = 0.65f;

@interface ThemePanelManagerNode ()
{
    NSMutableArray *panels;
    
    ImageButtonNode *arrowLeft;
    ImageButtonNode *arrowRight;
    
    NSUInteger selectedThemeId;
    NSUInteger lastId;
    
    SCNAction *buttonLure;
}
@end

@implementation ThemePanelManagerNode

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil)
    {
        lastId = 0;
        
        panels = [NSMutableArray new];
        
        selectedThemeId = [[ThemeManager sharedThemeManager] getCurrentThemeId];
    }
    
    return self;
}

- (Theme *)themeAtIndex:(NSUInteger)index {
    
    Theme *theme = [[[ThemeManager sharedThemeManager] storedThemes] objectAtIndex:index];
    
    return theme;
}

- (void)addPanelForTheme:(NSUInteger)themeId {
    
    Theme *theme = [self themeAtIndex:themeId];
    
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    ThemePanelNode *panel = [ThemePanelNode panelWithTheme:theme];
    
    [panel setScale:SCNVector3Make(0.15f, 0.15f, 0.15f)];
    [panel setOpacity:0.0f];
    
    x = (themeId < selectedThemeId) ? -offset:offset;
    y = offset;
    
    [panel setPosition:SCNVector3Make(x, y, 0.01f)];
    
    [panel setup:self];
    
    [panels addObject:panel];
    
    lastId++;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    // Add the panels here
    for (int i = 0; i < [[[ThemeManager sharedThemeManager] storedThemes] count]; ++i) {
        
        [self addPanelForTheme:i];
    }
    
    static const CGFloat scale = 0.08f;
    
    arrowLeft = [ImageButtonNode imageButtonWithName:nil andButtonColor:nil andTagName:@"selectionArrowLeft" andTagAlignment:TagHorizontalAlignmentCenter];
    
    [arrowLeft setScale:SCNVector3Make(1.5f * scale, 1.5f * scale, 1.0f)];
    [arrowLeft setPosition:SCNVector3Make(-0.5f, self.position.y, self.position.z + 1.0f)];
    [arrowLeft setEulerAngles:SCNVector3Zero];
    
//    [arrowLeft setOpacity:0.35f];
    
    [arrowLeft addTarget:self action:@selector(moveLeft) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [arrowLeft setup:parentNode];
    
    arrowRight = [ImageButtonNode imageButtonWithName:nil andButtonColor:nil andTagName:@"selectionArrowRight" andTagAlignment:TagHorizontalAlignmentCenter];
    
    [arrowRight setScale:SCNVector3Make(1.5f * scale, 1.5f * scale, 1.0f)];
    [arrowRight setPosition:SCNVector3Make(0.5f, self.position.y, self.position.z + 1.0f)];
    [arrowRight setEulerAngles:SCNVector3Zero];
    
//    [arrowRight setOpacity:0.35f];
    
    [arrowRight addTarget:self action:@selector(moveRight) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [arrowRight setup:parentNode];
    
    [self updateArrows];
    
    buttonLure = [SCNAction sequence:@[
                                       [SCNAction waitForDuration:2.5],
                                       [SCNAction scaleBy:1.05f duration:0.5],
                                       [SCNAction scaleBy:(1.0f / 1.05f) duration:0.5],
                                       [SCNAction waitForDuration:2.5]
                                       ]
                  ];
}

- (void)activate {
    
    [super activate];

    for (ThemePanelNode *panel in panels) {
        
        [panel activate];
    }
    
    [arrowLeft activate];
    [arrowLeft runAction:[SCNAction repeatActionForever:buttonLure]];
    
    [arrowRight activate];
    [arrowRight runAction:[SCNAction repeatActionForever:buttonLure]];
    
    [self showFirst];
}

- (void)showFirst {
    
    const NSTimeInterval duration = 0.5;
    
    ThemePanelNode *currentPanel = [panels objectAtIndex:selectedThemeId];
    
    __block SCNVector3 previousStart = [currentPanel position];
    
    SCNAction *customSwooshIn = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
        
        CGFloat x = offset * sinf(M_PI_2 * -elapsedtime / 0.5f);
        CGFloat y = -offset * elapsedtime / 0.5f;
        CGFloat z = 0.0f;
        
        [node setPosition:SCNVector3Make(previousStart.x + x, previousStart.y + y, previousStart.z + z)];
    }];
    
    [currentPanel runAction:[SCNAction group:@[
                                               [SCNAction waitForDuration:0.75],
                                               customSwooshIn,
                                               [SCNAction scaleTo:1.3f duration:duration],
                                               [SCNAction fadeInWithDuration:duration]
                                               ]] forKey:@"SwooshIn"];
}

- (void)moveToCurrentTheme {
    
    NSUInteger themeId = [[ThemeManager sharedThemeManager] getCurrentThemeId];
    
    if (selectedThemeId != themeId) {
        
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        
        for (int i = 0; i < [panels count]; ++i) {
            
            ThemePanelNode *panel = [panels objectAtIndex:i];
        
            [panel setScale:SCNVector3Make(0.15f, 0.15f, 0.15f)];
            [panel setOpacity:0.0f];
            
            x = (i < themeId) ? -offset:offset;
            y = offset;
            
            [panel setPosition:SCNVector3Make(x, y, 0.01f)];
        }
        
        ThemePanelNode *panel = [panels objectAtIndex:themeId];
        
        [panel setScale:SCNVector3Make(1.3f, 1.3f, 1.3f)];
        [panel setOpacity:1.0f];
        
        [panel setPosition:SCNVector3Make(0.0f, 0.0f, 0.01f)];
        
        selectedThemeId = themeId;
    }
    
    [self updateArrows];
}

- (void)deactivate {
    
    for (ThemePanelNode *panel in panels) {
        
        [panel deactivate];
    }
    
    [arrowLeft deactivate];
    [arrowRight deactivate];
    
    [super deactivate];
}

- (void)updateArrows {
    
    if ([panels count] > 0) {
        
        [arrowLeft setHidden:(selectedThemeId > 0) ? NO : YES];
        [arrowRight setHidden:(selectedThemeId < (lastId - 1)) ? NO : YES];
    } else {
        
        [arrowLeft setHidden:YES];
        [arrowRight setHidden:YES];
    }
}

- (void)moveRight {
    
    if (selectedThemeId < (lastId - 1)) {
        
        const NSTimeInterval duration = 0.5;
        
        ThemePanelNode *currentPanel = [panels objectAtIndex:selectedThemeId];
        
        if (([currentPanel actionForKey:@"SwooshIn"] != nil) || ([currentPanel actionForKey:@"SwooshOut"] != nil)) {
            
            return;
        }
        
        __block SCNVector3 currentStart = [currentPanel position]; //[[currentPanel presentationNode] position];
        
        SCNAction *customSwooshOut = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * -elapsedtime / 0.5f);
            CGFloat y = offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(currentStart.x + x, currentStart.y + y, currentStart.z + z)];
        }];
        
        [currentPanel runAction:[SCNAction group:@[
                                                   customSwooshOut,
                                                   [SCNAction scaleTo:0.15f duration:duration],
                                                   [SCNAction fadeOutWithDuration:duration],
                                                   [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
                                                   ]] forKey:@"SwooshOut"];
        
        selectedThemeId++;
        
        ThemePanelNode *nextPanel = [panels objectAtIndex:selectedThemeId];
        
        __block SCNVector3 nextStart = [nextPanel position]; //[[nextPanel presentationNode] position];
        
        SCNAction *customSwooshIn = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * -elapsedtime / 0.5f);
            CGFloat y = -offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(nextStart.x + x, nextStart.y + y, nextStart.z + z)];
        }];
        
        [nextPanel runAction:[SCNAction group:@[
                                                customSwooshIn,
                                                [SCNAction scaleTo:1.3f duration:duration],
                                                [SCNAction fadeInWithDuration:duration],
                                                [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
                                                ]] forKey:@"SwooshIn"];
        
        [[ThemeManager sharedThemeManager] setThemeByIdentifier:selectedThemeId];
    }
    
    [self updateArrows];
}

- (void)moveLeft {
    
    if (selectedThemeId > 0) {
        
        const NSTimeInterval duration = 0.5;
        
        ThemePanelNode *currentPanel = [panels objectAtIndex:selectedThemeId];
        
        if (([currentPanel actionForKey:@"SwooshIn"] != nil) || ([currentPanel actionForKey:@"SwooshOut"] != nil)) {
            
            return;
        }
        
        __block SCNVector3 currentStart = [currentPanel position];
        
        SCNAction *customSwooshOut = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * elapsedtime / 0.5f);
            CGFloat y = offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(currentStart.x + x, currentStart.y + y, currentStart.z + z)];
        }];
        
        [currentPanel runAction:[SCNAction group:@[
                                                   customSwooshOut,
                                                   [SCNAction scaleTo:0.15f duration:duration],
                                                   [SCNAction fadeOutWithDuration:duration],
                                                   [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
                                                   ]] forKey:@"SwooshOut"];
        
        selectedThemeId--;
        
        ThemePanelNode *previousPanel = [panels objectAtIndex:selectedThemeId];
        
        __block SCNVector3 previousStart = [previousPanel position];
        
        SCNAction *customSwooshIn = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * elapsedtime / 0.5f);
            CGFloat y = -offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(previousStart.x + x, previousStart.y + y, previousStart.z + z)];
        }];
        
        [previousPanel runAction:[SCNAction group:@[
                                                    customSwooshIn,
                                                    [SCNAction scaleTo:1.3f duration:duration],
                                                    [SCNAction fadeInWithDuration:duration],
                                                    [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
                                                    ]] forKey:@"SwooshIn"];
        
        [[ThemeManager sharedThemeManager] setThemeByIdentifier:selectedThemeId];
    }
    
    [self updateArrows];
}

@end
