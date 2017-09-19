//
//  InAppPurchase.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

@interface InAppPurchase : NSObject

@property (nonatomic, strong) SKProduct *product;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDecimalNumber *price;

@property (nonatomic, assign) BOOL locked;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithProduct:(SKProduct *)skp;

@end
