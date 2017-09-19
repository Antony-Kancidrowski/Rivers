//
//  Consumable.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Consumable : NSObject <NSCoding>

@property (assign) NSUInteger quantityPurchased;
@property (assign) NSUInteger quantityUsed;

@property (readonly) NSUInteger quantityAvailable;

- (void)purchase:(NSUInteger)quantity;
- (void)use:(NSUInteger)quantity;

@end
