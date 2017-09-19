//
//  ThemeBoxManagerNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ThemeBoxManagerNode.h"

#import "AppSpecificValues.h"

#import "ThemeManager.h"

//#import "BoxNode.h"

@interface ThemeBoxManagerNode ()
{
    Theme *theTheme;
    
//    BoxNode *back;
//    
//    BoxNode *left;
//    BoxNode *right;
//    
//    BoxNode *top;
//    BoxNode *bottom;
//    
//    BoxNode *front;
//    
//    BoxNode *red;
//    BoxNode *white;
//    BoxNode *blue;
}
@end

@implementation ThemeBoxManagerNode

+ (ThemeBoxManagerNode *)boxWithTheme:(Theme *)theme {
    
    ThemeBoxManagerNode *newBox = [[ThemeBoxManagerNode alloc] initWithTheme:(Theme *)theme];
    
    return newBox;
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
    
//    back = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"box" andSize:SCNVector3Make(2.125, 2.625, 0.125)];
//    [back setPosition:SCNVector3Make(0, -0.5, 0)];
//    
//    [back setName:@"back"];
//    [back setEulerAngles:SCNVector3Make(-M_PI_2, 0, 0)];
//    
//    [back setup:self];
//    
//    left = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"box" andSize:SCNVector3Make(0.07, 2.65, 0.55)];
//    [left setPosition:SCNVector3Make(-2.145, -0.20, 0)];
//    
//    [left setName:@"left"];
//    [left setEulerAngles:SCNVector3Make(-M_PI_2, 0, 0)];
//    
//    [left setup:self];
//    
//    right = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"box" andSize:SCNVector3Make(0.07, 2.65, 0.55)];
//    [right setPosition:SCNVector3Make(2.145, -0.20, 0)];
//    
//    [right setName:@"right"];
//    [right setEulerAngles:SCNVector3Make(-M_PI_2, 0, 0)];
//    
//    [right setup:self];
//    
//    top = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"box" andSize:SCNVector3Make(2.14, 0.07, 0.55)];
//    [top setPosition:SCNVector3Make(0, -0.20, -2.64)];
//    
//    [top setName:@"top"];
//    [top setEulerAngles:SCNVector3Make(-M_PI_2, 0, 0)];
//    
//    [top setup:self];
//    
//    bottom = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"box" andSize:SCNVector3Make(2.14, 0.07, 0.55)];
//    [bottom setPosition:SCNVector3Make(0, -0.20, 2.64)];
//    
//    [bottom setName:@"bottom"];
//    [bottom setEulerAngles:SCNVector3Make(-M_PI_2, 0, 0)];
//    
//    [bottom setup:self];
//    
//    red = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"red" andSize:SCNVector3Make(1.0, 1.0, 0.25)];
//    [red setPosition:SCNVector3Make(0.25f, 0.8f, -0.85f)];
//    
//    [red setName:@"red"];
//    [red setEulerAngles:SCNVector3Make(-M_PI_2, 0.25f, 0.3f)];
//    
//    [red setup:self];
//    
//    white = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"white" andSize:SCNVector3Make(0.5, 0.5, 0.25)];
//    [white setPosition:SCNVector3Make(1.25f, 0.0f, 1.25f)];
//    
//    [white setName:@"white"];
//    [white setEulerAngles:SCNVector3Make(-M_PI_2, M_PI_4, 0)];
//    
//    [white setup:self];
//    
//    blue = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"blue" andSize:SCNVector3Make(0.5, 1.0, 0.25)];
//    [blue setPosition:SCNVector3Make(-1.25f, 0.0f, 0.75f)];
//    
//    [blue setName:@"blue"];
//    [blue setEulerAngles:SCNVector3Make(-M_PI_2, -0.1f, 0)];
//    
//    [blue setup:self];
//    
//    
//    front = [[BoxNode alloc] initWithTheme:theTheme andTextureNamed:@"box" andSize:SCNVector3Make(2.125, 2.625, 0.125)];
//    [front setPosition:SCNVector3Make(0, 0.4, 0)];
//    
//    [front setName:@"front"];
//    [front setEulerAngles:SCNVector3Make(-M_PI_2, 0, 0)];
//    
//    [front setHidden:YES];
//    
//    [front setup:self];
}

- (void)activate {
    
    [super activate];

//    [back activate];
//    
//    [left activate];
//    [right activate];
//    
//    [top activate];
//    [bottom activate];
//    
//    [red activate];
//    [white activate];
//    [blue activate];
//    
//    [front activate];
}

- (void)deactivate {
    
//    [back deactivate];
//    
//    [left deactivate];
//    [right deactivate];
//    
//    [top deactivate];
//    [bottom deactivate];
//    
//    [red deactivate];
//    [white deactivate];
//    [blue deactivate];
//    
//    [front deactivate];
  
    [super deactivate];
}

@end
