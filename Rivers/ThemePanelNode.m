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

#import "ThemeTileManagerNode.h"

#import "LabelNode.h"

@interface ThemePanelNode ()
{
}

@property (nonatomic, strong) ThemeTileManagerNode *themeTileManager;

@property (nonatomic, strong) Theme* theTheme;

@property (nonatomic, strong) LabelNode *title;

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
        self.theTheme = theme;
    }
    
    return self;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    const CGFloat scale = 0.1f;

    _themeTileManager = [ThemeTileManagerNode tileWithTheme:_theTheme];
    [_themeTileManager setPosition:SCNVector3Make(0.0f, 0.15f, 1.75f)];
    [_themeTileManager setScale:SCNVector3Make(1.5f * scale, 1.5f * scale, 1.5f * scale)];
    [_themeTileManager setEulerAngles:SCNVector3Make(M_PI_2 - 0.75f, 0.0f, 0.0f)];
    [_themeTileManager setup:self];
    
    const CGFloat width = 320.0f;
    const CGFloat height = 80.0f;
    
    NSShadow *myShadow = [NSShadow new];
    [myShadow setShadowColor:[UIColor blackColor]];
    [myShadow setShadowBlurRadius:5.0];
    [myShadow setShadowOffset:CGSizeMake(2, 2)];
    
    NSString *name = [_theTheme.theme valueForKey:@"nameKey"];
    
    _title = [LabelNode setLabelWithText:NSLocalizedString(name, nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [_title setShadow:myShadow];
    
    [_title setFixedWidth:width];
    [_title setFixedHeight:height];
    
    [_title setScale:SCNVector3Make(8.0f * scale, 1.86f * scale, 1.0f)];
    [_title setPosition:SCNVector3Make(0.0f, -0.55f, 0.02f)];
    [_title setEulerAngles:SCNVector3Zero];
    
    [_title setup:self];
}

- (void)activate {
    
    [super activate];
    
    [_themeTileManager activate];
    
    [_title activate];
}

- (void)deactivate {
    
    [_themeTileManager deactivate];
    
    [_title deactivate];
    
    [super deactivate];
}

@end
