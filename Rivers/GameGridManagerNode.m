//
//  GameGridManagerNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 25/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "GameGridManagerNode.h"

#import "ThemeManager.h"
#import "Theme.h"

#import "DebugOptions.h"
#import "TileNode.h"

@interface GameGridManagerNode ()
{
    NSMutableArray *gameTiles;
}

@property (nonatomic, assign) GameType gameType;

@end

@implementation GameGridManagerNode

+ (GameGridManagerNode *)gridManagerWithType:(GameType)gameType {
    
    GameGridManagerNode *newManager = [[GameGridManagerNode alloc] initWithType:gameType];
    
    return newManager;
}

- (instancetype)initWithType:(GameType)gameType {
    
    self = [super init];
    
    if (self != nil)
    {
        gameTiles = [[NSMutableArray alloc] initWithCapacity:84];
        
        self.gameType = gameType;
    }
    
    return self;
}

- (void)setTile:(SCNVector3)position {
    
    float unit_x = 0.5f;
    float unit_y = 0.5f;
    
    ThemeManager *manager = [ThemeManager sharedThemeManager];
    Theme *theme = [manager getCurrentTheme];
    
    TileNode *tileNode = [[TileNode alloc] initWithTheme:theme
                                              andTagName:@"rivers"
                                                 andSize:SCNVector3Make(unit_x, unit_y * 2, 0.125)
                                                andScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [tileNode setPosition:position];
    [tileNode setup:self];
    
    [gameTiles addObject:tileNode];
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    [self setTile:SCNVector3Make(-1.05f, -2.05f, 0.0f)];
    [self setTile:SCNVector3Make(0.0f, -2.05f, 0.0f)];
    [self setTile:SCNVector3Make(1.05f, -2.05f, 0.0f)];
    
    [self setTile:SCNVector3Make(-1.05f, 0.0f, 0.0f)];
    [self setTile:SCNVector3Make(0.0f, 0.0f, 0.0f)];
    [self setTile:SCNVector3Make(1.05f, 0.0f, 0.0f)];
    
    [self setTile:SCNVector3Make(-1.05f, 2.05f, 0.0f)];
    [self setTile:SCNVector3Make(0.0f, 2.05f, 0.0f)];
    [self setTile:SCNVector3Make(1.05f, 2.05f, 0.0f)];
}

- (void)receiveShowTilesNotification:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:@"ShowTiles"]) {
        
        NSNumber *show = [DebugOptions optionForKey:@"ShowTiles"];
        
        for (TileNode *tileNode in gameTiles) {
            
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
    
    for (TileNode *tileNode in gameTiles) {
        
        [tileNode activate];
    }
}

- (void)deactivate {
    
    for (TileNode *tileNode in gameTiles) {
        
        [tileNode deactivate];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super deactivate];
}

@end
