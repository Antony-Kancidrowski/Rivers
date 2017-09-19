//
//  Consumable.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "Consumable.h"

#define SCHEMA_VERSION 1

static NSString *ConsumableSchemaVersion = @"SchemaVersion";

static NSString *ConsumableQuantityPurchased = @"QuantityPurchased";
static NSString *ConsumableQuantityUsed = @"QuantityUsed";

@implementation Consumable

@synthesize quantityPurchased = _quantityPurchased;
@synthesize quantityUsed = _quantityUsed;

- (instancetype)init
{
    self = [super init];
    
    if (self != nil)
    {
        _quantityPurchased = 0;
        _quantityUsed = 0;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:SCHEMA_VERSION forKey:ConsumableSchemaVersion];
    
    [aCoder encodeInteger:_quantityPurchased forKey:ConsumableQuantityPurchased];
    [aCoder encodeInteger:_quantityUsed forKey:ConsumableQuantityUsed];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        int version = [aDecoder decodeIntForKey:ConsumableSchemaVersion];
        
        if (1 == version)
        {
            _quantityPurchased = [aDecoder decodeIntegerForKey:ConsumableQuantityPurchased];
            _quantityUsed = [aDecoder decodeIntegerForKey:ConsumableQuantityUsed];
        }
    }
    
    return self;
}

- (void)purchase:(NSUInteger)quantity {
    
    self.quantityPurchased += quantity;
}

- (void)use:(NSUInteger)quantity {
    
    self.quantityUsed += quantity;
}

- (NSUInteger)quantityAvailable {
    
    return (self.quantityPurchased - self.quantityUsed);
}

@end
