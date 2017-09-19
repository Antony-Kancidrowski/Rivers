//
//  InAppPurchasesManager.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

@class InAppPurchase;

@interface InAppPurchasesManager : NSObject <SKProductsRequestDelegate>

@property (strong, readonly, nonatomic) NSMutableArray *storedInAppPurchases;

+ (InAppPurchasesManager *)sharedInAppPurchasesManager;
+ (InAppPurchase *)iapAtIndex:(NSUInteger)index;

- (void)fetchAvailableProducts;

- (NSUInteger)purchasableItems;

@end
