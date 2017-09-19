//
//  StorePanelNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"
#import "InAppPurchase.h"

@interface StorePanelNode : ActorNode

+ (StorePanelNode *)panelWithInAppPurchase:(InAppPurchase *)iap;

- (instancetype)init NS_UNAVAILABLE;

- (void)activate;
- (void)deactivate;

@end
