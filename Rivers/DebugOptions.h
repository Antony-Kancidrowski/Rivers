//
//  DebugOptions.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugOptions : NSObject

+ (DebugOptions *)sharedDebugOptions;
+ (NSNumber *)optionForKey:(id)key;

- (void)setObject:(id)object forKey:(id <NSCopying>)key;
- (id)objectForKey:(id)key;

- (void)writeOptions;
- (void)readOptions;

@end
