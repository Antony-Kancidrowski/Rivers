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

@property (nonatomic, strong) TileNode *red;
@property (nonatomic, strong) TileNode *white;
@property (nonatomic, strong) TileNode *blue;

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
    
    _red = [[TileNode alloc] initWithTagName:@"red" andSize:SCNVector3Make(1.0, 1.0, 0.25) andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [_red setPosition:SCNVector3Make(0.25f, 0.8f, -0.85f)];
    
    [_red setName:@"red"];
    [_red setEulerAngles:SCNVector3Make(-M_PI_2, 0.25f, 0.3f)];
    
    [_red setup:self];
    
    _white = [[TileNode alloc] initWithTagName:@"white" andSize:SCNVector3Make(0.5, 0.5, 0.25) andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [_white setPosition:SCNVector3Make(1.25f, 0.0f, 1.25f)];
    
    [_white setName:@"white"];
    [_white setEulerAngles:SCNVector3Make(-M_PI_2, M_PI_4, 0)];
    
    [_white setup:self];
    
    _blue = [[TileNode alloc] initWithTagName:@"blue" andSize:SCNVector3Make(0.5, 1.0, 0.25) andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [_blue setPosition:SCNVector3Make(-1.25f, 0.0f, 0.75f)];
    
    [_blue setName:@"blue"];
    [_blue setEulerAngles:SCNVector3Make(-M_PI_2, -0.1f, 0)];
    
    [_blue setup:self];
}

- (void)activate {
    
    [super activate];

    [_red activate];
    [_white activate];
    [_blue activate];
}

- (void)deactivate {
    
    [_red deactivate];
    [_white deactivate];
    [_blue deactivate];
  
    [super deactivate];
}

@end
