//
//  ConsumablePurchasesController.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ConsumablePurchasesController.h"

#import "AppSpecificValues.h"

#import "MasterKeysConsumable.h"

#import <GameKit/GameKit.h>

@interface ConsumablePurchasesController()
{
    NSLock *writeLock;
}

@property (strong, readonly, nonatomic) NSString *consumablePurchasesFilename;

// Save consumable purchases to disk.
- (void)writeConsumablePurchases;

// Load consumable purchases from disk.
- (void)readConsumablePurchases;

- (void)initialiseConsumablePurchases;

@end


@implementation ConsumablePurchasesController

@synthesize consumableObjects, consumablePurchasesFilename;

- (instancetype)init
{
    self = [super init];
    
    if (self != NULL)
    {
        [self setUp];
    }
    
    return self;
}

- (void)initialise
{
    [self initialiseConsumablePurchases];
    [self writeConsumablePurchases];
}

- (void)setUp
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    consumablePurchasesFilename = [[NSString alloc] initWithFormat:@"%@/%@.storedConsumablePurchases_v2.plist", path, [GKLocalPlayer localPlayer].playerID];
    
    writeLock = [NSLock new];
    
    [self readConsumablePurchases];
}

#pragma mark Consumable Purchases

- (void)writeConsumablePurchases
{
    [writeLock lock];
    {
        NSData *archivedStore = [NSKeyedArchiver archivedDataWithRootObject:consumableObjects];
        NSError *error;
        
        [archivedStore writeToFile:consumablePurchasesFilename options:NSDataWritingFileProtectionNone error:&error];
        
        if (error)
        {
            //  Error saving file, handle accordingly
        }
    }
    [writeLock unlock];
}

- (void)initialiseConsumablePurchases
{
    consumableObjects = [NSMutableDictionary new];
    
    [consumableObjects setObject:[MasterKeysConsumable new] forKey:kIAPUnlockKeys];
}

- (void)readConsumablePurchases
{
    NSDictionary *unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:consumablePurchasesFilename];
    
    if (unarchivedObj)
    {
        consumableObjects = [[NSMutableDictionary alloc] initWithDictionary:unarchivedObj];
    }
    else
    {
        [self initialiseConsumablePurchases];
    }
}

#pragma mark Master Keys

- (NSUInteger)quantityAvailableForMasterKeysConsumable {
    
    Consumable *consumable = [consumableObjects objectForKey:kIAPUnlockKeys];
    
    return [consumable quantityAvailable];
}

- (void)purchasedMasterKeysConsumable {
    
    Consumable *consumable = [consumableObjects objectForKey:kIAPUnlockKeys];
    
    [consumable purchase:9];
    
    [self writeConsumablePurchases];
}

- (void)useAMasterKeyConsumable {
    
    Consumable *consumable = [consumableObjects objectForKey:kIAPUnlockKeys];
    
    [consumable use:1];
    
    [self writeConsumablePurchases];
}

@end
