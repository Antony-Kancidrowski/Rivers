//
//  ConsumablePurchasesController.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Consumable;

@interface ConsumablePurchasesController : NSObject

@property (strong, nonatomic) NSMutableDictionary *consumableObjects;

- (void)initialise;

- (void)purchasedMasterKeysConsumable;
- (void)useAMasterKeyConsumable;

- (NSUInteger)quantityAvailableForMasterKeysConsumable;

@end
