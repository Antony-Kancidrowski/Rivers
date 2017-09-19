//
//  ThemeManager.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface ThemeManager : NSObject

@property (strong, readonly, nonatomic) NSMutableArray *storedThemes;

+ (ThemeManager *)sharedThemeManager;

- (Theme *)getCurrentTheme;
- (NSInteger)getCurrentThemeId;

- (void)setThemeByIdentifier:(NSInteger)identifier;

- (void)load;
- (void)save;

- (void)setUp;

- (void)initialiseStoredThemes;

@end
