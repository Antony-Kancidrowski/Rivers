//
//  MasterKeysConsumable.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "Consumable.h"

@interface MasterKeysConsumable : Consumable

- (void)purchase:(NSUInteger)quantity;
- (void)use:(NSUInteger)quantity;

@end
