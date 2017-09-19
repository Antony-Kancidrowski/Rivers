//
//  InAppPurchasesManager.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "InAppPurchasesManager.h"

#import "AppSpecificValues.h"
#import "DebugOptions.h"

#import "InAppPurchase.h"

@interface InAppPurchasesManager ()
{
    SKProductsRequest *productsRequest;
    NSLock *iapLock;
}
@end

@implementation InAppPurchasesManager

@synthesize storedInAppPurchases;

+ (InAppPurchasesManager *)sharedInAppPurchasesManager {
    
    static InAppPurchasesManager *sharedInAppPurchasesManager;
    
    @synchronized(self)
    {
        if (!sharedInAppPurchasesManager)
            sharedInAppPurchasesManager = [InAppPurchasesManager new];
    }
    
    return sharedInAppPurchasesManager;
}

+ (InAppPurchase *)iapAtIndex:(NSUInteger)index {
    
    return [[[InAppPurchasesManager sharedInAppPurchasesManager] storedInAppPurchases] objectAtIndex:index];
}

- (instancetype)init {
    
    self = [super init];
    
    if (self != NULL)
    {
        storedInAppPurchases = [NSMutableArray new];
        
        iapLock = [NSLock new];
    }
    
    return self;
}

- (NSUInteger)purchasableItems {
    
    NSUInteger count = 0;
    
    [iapLock lock];
    
    count = [storedInAppPurchases count];
    
    [iapLock unlock];
    
    return count;
}

#pragma mark Store

-(void)fetchAvailableProducts {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:kIAPUnlockZen, kIAPUnlockReverse, kIAPUnlockTimed, kIAPUnlockKeys, nil];
    
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    
    [productsRequest start];
}

#pragma mark SKProductsRequestDelegate

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    // TODO: Report the error
    
//    NSURLErrorTimedOut (-1001)
//    The connection timed out.
//    NSURLErrorCannotFindHost (-1003)
//    The connection failed because the host could not be found.
//    NSURLErrorCannotConnectToHost (-1004)
//    The connection failed because a connection cannot be made to the host.
//    NSURLErrorNetworkConnectionLost (-1005)
//    The connection failed because the network connection was lost.
//    NSURLErrorNotConnectedToInternet (-1009)
//    The connection failed because the device is not connected to the internet.
//    NSURLErrorUserCancelledAuthentication (-1012)
//    The connection failed because the user cancelled required authentication.
//    NSURLErrorSecureConnectionFailed (-1200)
//    The secure connection failed for an unknown reason.
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    [iapLock lock];
    
    for (SKProduct *product in response.products) {
        
        BOOL found = NO;
        
        for (InAppPurchase *currentIAP in storedInAppPurchases) {
            
            if ([[product productIdentifier] compare:[currentIAP identifier]] == NSOrderedSame) {
                
                found = YES;
            }
        }
        
        if (found == NO) {
            
            InAppPurchase *iap = [InAppPurchase new];
            
            [iap setProduct:product];
            
            NSString *imageName = nil;
            
            if ([[product productIdentifier] isEqualToString:kIAPUnlockZen]) {
                
                imageName = @"unlock-zen-iap.png";
            }
            
            if ([[product productIdentifier] isEqualToString:kIAPUnlockReverse]) {
                
                imageName = @"unlock-reverse-iap.png";
            }
            
            if ([[product productIdentifier] isEqualToString:kIAPUnlockTimed]) {
                
                imageName = @"unlock-timed-iap.png";
            }
            
            if ([[product productIdentifier] isEqualToString:kIAPUnlockKeys]) {
                
                imageName = @"unlock-keys-iap.png";
            }
            
            NSAssert(imageName != nil, @"Invalid In App Purchase Identifier.");
            
            [iap setImage:[UIImage imageNamed:imageName]];
            
            [iap setIdentifier:[product productIdentifier]];
            [iap setName:[product localizedTitle]];
            [iap setDescription:[product localizedDescription]];
            
            [iap setPrice:[product price]];
            
            [storedInAppPurchases addObject:iap];
            
            if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                NSLog(@"In App Purchase:\n%@\n%@\n%@\n%@", [product productIdentifier], [product localizedTitle], [product localizedDescription], [[product price] stringValue]);
        }
    }
    
    [iapLock unlock];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchasesDownloadedNotification
                                                        object:nil];
}

@end
