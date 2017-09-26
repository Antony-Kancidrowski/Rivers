//
//  ThemeManager.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ThemeManager.h"
#import "Theme.h"

#import "AppSpecificValues.h"
#import "Configuration.h"

#import <GameKit/GameKit.h>

#import "DebugOptions.h"

static NSUInteger maxThemes = 9;

@interface ThemeManager()
{
    NSLock *writeLock;
}

@property (strong, readonly, nonatomic) NSString *themesFilename;

// Save themes to disk.
- (void)writeStoredThemes;

// Load themes from disk.
- (void)readStoredThemes;

- (void)initialiseStoredThemes;

@end


@implementation ThemeManager

@synthesize storedThemes, themesFilename;


+ (ThemeManager *)sharedThemeManager
{
    static ThemeManager *sharedThemeManager;
    
    @synchronized(self)
    {
        if (!sharedThemeManager)
            sharedThemeManager = [ThemeManager new];
    }
    
    return sharedThemeManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self != NULL)
    {
        [self setUp];
    }
    
    return self;
}

- (void)load
{
    [self readStoredThemes];
}

- (void)save
{
    [self writeStoredThemes];
}

- (void)setUp
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    themesFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedThemes_v2.plist", path, [GKLocalPlayer localPlayer].playerID];

    writeLock = [NSLock new];
    
    [self load];
}

#pragma mark Attributes

- (Theme *)getCurrentTheme {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    return [storedThemes objectAtIndex:[[defaults valueForKey:kThemePreference] integerValue]];
}

- (NSInteger)getCurrentThemeId {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [[defaults valueForKey:kThemePreference] integerValue];
}

- (void)setThemeByIdentifier:(NSInteger)identifier {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:identifier forKey:kThemePreference];
 
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangedNotification
                                                        object:nil];
}

#pragma mark Themes

- (void)writeStoredThemes
{
    [writeLock lock];
    {
        NSData *archivedStore = [NSKeyedArchiver archivedDataWithRootObject:storedThemes];
        NSError *error;
        
        [archivedStore writeToFile:themesFilename options:NSDataWritingFileProtectionNone error:&error];
        
        if (error)
        {
            //  Error saving file, handle accordingly
            NSLog(@"Error saving Themes progress.");
        }
    }
    [writeLock unlock];
}

- (void)initialiseStoredThemes
{
    storedThemes = [NSMutableArray new];
    
    // Setup the Themes Defaults
    NSString *path = [[NSBundle mainBundle] pathForResource:@"themes_v2" ofType:@"plist"];
    NSArray *contentList = [NSArray arrayWithContentsOfFile:path];
    
    Theme *theme = nil;
    
    for (int i = 0; i < maxThemes; i++)
    {
        NSDictionary *item = [contentList objectAtIndex:i];
        
        theme = [Theme new];
        
        theme.theme = [item mutableCopy];
        
        [storedThemes addObject:theme];
    }
}

- (void)readStoredThemes
{
    NSArray *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:themesFilename];
    
    if (unarchivedObj)
    {
        storedThemes = [[NSMutableArray alloc] initWithArray:unarchivedObj];
        
        if ((nil == storedThemes) || ([storedThemes count] < maxThemes)) {
         
            [self initialiseStoredThemes];
        }
    }
    else
    {
        [self initialiseStoredThemes];
    }
}

@end
