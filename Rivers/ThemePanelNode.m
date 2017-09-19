//
//  ThemePanelNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ThemePanelNode.h"

#import "SoundManager.h"

#import "Configuration.h"
#import "AppSpecificValues.h"

#import "ThemeBoxManagerNode.h"

#import "LabelNode.h"

@interface ThemePanelNode ()
{
    ThemeBoxManagerNode *themeBoxManager;
    
    Theme* theTheme;
    
    LabelNode *title;
}
@end

@implementation ThemePanelNode

+ (ThemePanelNode *)panelWithTheme:(Theme *)theme {
    
    ThemePanelNode *newPanel = [[ThemePanelNode alloc] initWithTheme:theme];
    
    return newPanel;
}

- (instancetype)initWithTheme:(Theme *)theme {
    
    self = [super init];
    
    if (self != nil)
    {
        theTheme = theme;
    }
    
    return self;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    const CGFloat scale = 0.1f;

    themeBoxManager = [ThemeBoxManagerNode boxWithTheme:theTheme];
    [themeBoxManager setPosition:SCNVector3Make(0.0f, 0.15f, 1.75f)];
    [themeBoxManager setScale:SCNVector3Make(1.5f * scale, 1.5f * scale, 1.5f * scale)];
    [themeBoxManager setEulerAngles:SCNVector3Make(M_PI_2 - 0.75f, 0.0f, 0.0f)];
    [themeBoxManager setup:self];
    
    const CGFloat width = 320.0f;
    const CGFloat height = 80.0f;
    
    NSShadow *myShadow = [NSShadow new];
    [myShadow setShadowColor:[UIColor blackColor]];
    [myShadow setShadowBlurRadius:5.0];
    [myShadow setShadowOffset:CGSizeMake(2, 2)];
    
    NSString *name = [theTheme.theme valueForKey:@"nameKey"];
    
    title = [LabelNode setLabelWithText:NSLocalizedString(name, nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [title setShadow:myShadow];
    
    [title setFixedWidth:width];
    [title setFixedHeight:height];
    
    [title setScale:SCNVector3Make(8.0f * scale, 1.86f * scale, 1.0f)];
    [title setPosition:SCNVector3Make(0.0f, -0.55f, 0.02f)];
    [title setEulerAngles:SCNVector3Zero];
    
    [title setup:self];
}

- (void)activate {
    
    [super activate];
    
    [themeBoxManager activate];
    
    [title activate];
}

- (void)deactivate {
    
    [themeBoxManager deactivate];
    
    [title deactivate];
    
    [super deactivate];
}

@end
