//
//  ThemeTileManagerNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ThemeTileManagerNode.h"

#import "AppSpecificValues.h"

#import "ThemeManager.h"

#import "TileNode.h"

@interface ThemeTileManagerNode ()
{
}

@property (nonatomic, strong) Theme *theTheme;

@property (nonatomic, strong) TileNode *one;
@property (nonatomic, strong) TileNode *two;

@end

@implementation ThemeTileManagerNode

+ (ThemeTileManagerNode *)tileWithTheme:(Theme *)theme {
    
    ThemeTileManagerNode *newTileManager = [[ThemeTileManagerNode alloc] initWithTheme:(Theme *)theme];
    
    return newTileManager;
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
    
    _one = [[TileNode alloc] initWithTheme:self.theTheme andTagName:@"rivers" andSize:SCNVector3Make(0.5, 1.0, 0.125) andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [_one setPosition:SCNVector3Make(0.375f, 0.5f, 0.5f)];

    [_one setRespondToThemeNotification:NO];
    [_one setEulerAngles:SCNVector3Make(-0.7f, 0.0f, -0.25f)];
    
    [_one setIntensity:0.5f];
    [_one setup:self];
    
    _two = [[TileNode alloc] initWithTheme:self.theTheme andTagName:@"blank" andSize:SCNVector3Make(0.5, 1.0, 0.125) andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [_two setPosition:SCNVector3Make(0.0f, 0.1f, -0.5f)];
    
    [_two setRespondToThemeNotification:NO];
    [_two setEulerAngles:SCNVector3Make(-0.7f, 0.0f, -0.1f)];
    
    [_two setIntensity:0.4f];
    [_two setup:self];
}

- (void)activate {
    
    [super activate];

    [_one activate];
    [_two activate];
}

- (void)deactivate {
    
    [_one deactivate];
    [_two deactivate];
  
    [super deactivate];
}

@end
