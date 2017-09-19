//
//  StoreViewController.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#import "RiversViewController.h"
#import "StorePanelManagerNode.h"

@interface StoreViewController : RiversViewController <SKPaymentTransactionObserver, SKRequestDelegate, StorePanelDelegate>

- (void)purchaseMyProduct:(SKProduct*)product;

- (BOOL)canMakePurchases;

@end
