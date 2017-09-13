//
//  DebugOptions.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "DebugOptions.h"
@interface DebugOptions()
{
    NSLock *writeLock;
}

@property (strong, readonly, nonatomic) NSString *optionsFilename;
@property (nonatomic) NSMutableDictionary *optionsDictionary;

@end

@implementation DebugOptions

+ (DebugOptions *)sharedDebugOptions {
    
    static DebugOptions *sharedDebugOptions;
    
    @synchronized(self) {
        
        if (!sharedDebugOptions)
            sharedDebugOptions = [DebugOptions new];
    }
    
    return sharedDebugOptions;
}

+ (NSNumber *)optionForKey:(id)key {
    
    DebugOptions *options = [DebugOptions sharedDebugOptions];
    
    return [options objectForKey:key];
}

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil) {
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        _optionsFilename = [[NSString alloc] initWithFormat:@"%@/debugOptions_v2.plist", path];
    }
    
    return self;
}

#pragma mark Accessors

- (void)setObject:(id)object forKey:(id <NSCopying>)key {
    
    [_optionsDictionary setObject:object forKey:key];
}

- (id)objectForKey:(id)key {
    
    return [_optionsDictionary objectForKey:key];
}

#pragma mark Persistence

- (void)writeOptions {
    
    [writeLock lock];
    
    {
        NSData *archivedStore = [NSKeyedArchiver archivedDataWithRootObject:_optionsDictionary];
        NSError *error;
        
        [archivedStore writeToFile:_optionsFilename options:NSDataWritingFileProtectionNone error:&error];
        
        if (error)
        {
            //  Error saving file, handle accordingly
            NSLog(@"Error saving debug options.");
        }
    }
    
    [writeLock unlock];
}

- (void)readOptions {
    
    NSDictionary *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:_optionsFilename];
    
    if (unarchivedObj) {
        
        _optionsDictionary = [[NSMutableDictionary alloc] initWithDictionary:unarchivedObj];
    } else {
        
        [self initialiseOptions];
    }
}

- (void)initialiseOptions {
    
    NSArray *keys = [NSArray arrayWithObjects:@"ShowDebugInformation", @"ShowBackgroundLayer", @"Zoom", @"EnableLog", nil];
    NSArray *objects = [NSArray arrayWithObjects:@"0", @"1", @"1.0", @"1", nil];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    
    _optionsDictionary = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
}

@end
