//
//  InAppPurchase.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "InAppPurchase.h"

@implementation InAppPurchase

@synthesize product;

@synthesize identifier;

@synthesize name;
@synthesize description;
@synthesize image;
@synthesize price;

@synthesize locked;

- (instancetype)initWithProduct:(SKProduct *)skp {
    
    self = [super init];
    
    if (self != NULL) {
        
        self.product = skp;
        
        self.name = nil;
        self.image = nil;
        self.price = nil;
        
        self.locked = YES;
    }
    
    return self;
}

@end
