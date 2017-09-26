//
//  FlyingTilesManagerNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 25/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "FlyingTilesManagerNode.h"

#import "ThemeManager.h"
#import "Theme.h"

#import "DebugOptions.h"
#import "TileNode.h"

@interface FlyingTilesManagerNode ()
{
    NSMutableArray *flyingTiles;
}

@property (nonatomic, strong) Theme *theme;

@end

@implementation FlyingTilesManagerNode

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil)
    {
        flyingTiles = [[NSMutableArray alloc] initWithCapacity:3];
        
        ThemeManager *themeManager = [ThemeManager sharedThemeManager];
        self.theme = [themeManager getCurrentTheme];
    }
    
    return self;
}

- (void)flyRedFly:(TileNode *)blockNode {
    
    SCNAction *custom = [SCNAction customActionWithDuration:4 * M_PI actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
        
        CGFloat x = 2 * sinf(elapsedtime / 2.0f);
        CGFloat y = node.presentationNode.position.y;
        CGFloat z = 1.5f * cosf(elapsedtime / 2.0f);
        
        [node setPosition:SCNVector3Make(x, y, z)];
        
        [node setEulerAngles:SCNVector3Make(elapsedtime, elapsedtime * 2, elapsedtime)];
    }];
    
    [blockNode runAction:[SCNAction repeatActionForever:custom]];
}

- (void)red:(SCNVector3)position {
    
    float unit_x = 0.5f;
    float unit_y = 0.5f;
    
    TileNode *blockNode = [[TileNode alloc] initWithTheme:self.theme
                                               andTagName:@"red"
                                                  andSize:SCNVector3Make(unit_x * 2, unit_y * 2, 0.25)
                                                 andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [blockNode setPosition:position];
    [blockNode setup:self];
    
    [flyingTiles addObject:blockNode];
}

- (void)flyBlueFly:(TileNode *)blockNode {
    
    SCNAction *custom = [SCNAction customActionWithDuration:2 * M_PI actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
        
        CGFloat x = -1.5f * sinf(elapsedtime);
        CGFloat y = 1.0f + cosf(elapsedtime * 2.0f);
        CGFloat z = node.presentationNode.position.z;
        
        [node setPosition:SCNVector3Make(x, y, z)];
        
        [node setEulerAngles:SCNVector3Make(-elapsedtime, 0, -elapsedtime)];
    }];
    
    [blockNode runAction:[SCNAction repeatActionForever:custom]];
}

- (void)blue:(SCNVector3)position {
    
    float unit_x = 0.5f;
    float unit_y = 0.5f;
    
    TileNode *tileNode = [[TileNode alloc] initWithTheme:self.theme
                                              andTagName:@"blue"
                                                 andSize:SCNVector3Make(unit_x, unit_y * 2, 0.25)
                                                andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [tileNode setPosition:position];
    [tileNode setup:self];
    
    [flyingTiles addObject:tileNode];
}

- (void)flyWhiteFly:(TileNode *)blockNode {
    
    SCNAction *custom = [SCNAction customActionWithDuration:2 * M_PI actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
        
        CGFloat x = 2.0f * sinf(elapsedtime);
        CGFloat y = 1.0f + (cosf(elapsedtime) / 2.0f);
        CGFloat z = sinf(elapsedtime);
        
        [node setPosition:SCNVector3Make(x, y, z)];
        
        [node setEulerAngles:SCNVector3Make(elapsedtime / 2.0f, elapsedtime / 2.0f, elapsedtime)];
    }];
    
    [blockNode runAction:[SCNAction repeatActionForever:custom]];
}

- (void)white:(SCNVector3)position {
    
    float unit_x = 0.5f;
    float unit_y = 0.5f;
    
    TileNode *tileNode = [[TileNode alloc] initWithTheme:self.theme
                                              andTagName:@"white"
                                                 andSize:SCNVector3Make(unit_x, unit_y, 0.25)
                                                andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [tileNode setPosition:position];
    [tileNode setup:self];
    
    [flyingTiles addObject:tileNode];
}

- (void)setup:(SCNNode*)parentNode {
    
    [super setup:parentNode];
    
    [self red:SCNVector3Make(0.0f, -1.0f, 1.5f)];
    
    [self blue:SCNVector3Make(-0.5f, 2.0f, 1.0f)];

    [self white:SCNVector3Make(1.5f, 0.0f, -0.5f)];
}

- (void)receiveShowTilesNotification:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:@"ShowTiles"]) {
        
        NSNumber *show = [DebugOptions optionForKey:@"ShowTiles"];
        
        for (TileNode *tileNode in flyingTiles) {
            
            [tileNode setHidden:!show.boolValue];
        }
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Successfully received Show Tiles Changed!");
    }
}

- (void)activate {
    
    [super activate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveShowTilesNotification:)
                                                 name:@"ShowTiles"
                                               object:NULL];
    
    for (TileNode *tileNode in flyingTiles) {
        
        [tileNode activate];
        
        if ([[tileNode tagName] containsString:@"red"]) {
            
            [self flyRedFly:tileNode];
        } else if ([[tileNode tagName] containsString:@"blue"]) {
            
            [self flyBlueFly:tileNode];
        } else if ([[tileNode tagName] containsString:@"white"]) {
            
            [self flyWhiteFly:tileNode];
        }
    }
}

- (void)deactivate {
    
    for (TileNode *tileNode in flyingTiles) {
        
        [tileNode deactivate];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super deactivate];
}

@end
