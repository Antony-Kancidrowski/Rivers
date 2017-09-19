//
//  Theme.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "Theme.h"

#define SCHEMA_VERSION 1

static NSString *ThemeSchemaVersion = @"SchemaVersion";

static NSString *ThemeKey = @"themeKey";

@implementation Theme

@synthesize theme;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:SCHEMA_VERSION forKey:ThemeSchemaVersion];
    
    [aCoder encodeObject:theme forKey:ThemeKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        int version = [aDecoder decodeIntForKey:ThemeSchemaVersion];
        
        if (1 == version) {
            
            self.theme = [aDecoder decodeObjectForKey:ThemeKey];
        }
    }
    
    return self;
}

- (NSString *)itemForKey:(NSString *)key {
    
    return [self.theme valueForKey:key];
}

@end
