//
//  MasterKeysConsumable.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "MasterKeysConsumable.h"

#import "AppSpecificValues.h"

@implementation MasterKeysConsumable

- (void)purchase:(NSUInteger)quantity {
    
    [super purchase:quantity];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMasterKeyChangeNotification
                                                        object:nil];
}

- (void)use:(NSUInteger)quantity {
    
    [super use:quantity];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMasterKeyChangeNotification
                                                        object:nil];
}

@end
