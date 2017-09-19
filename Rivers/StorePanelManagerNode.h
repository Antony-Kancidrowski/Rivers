//
//  StorePanelManagerNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"
#import "InAppPurchase.h"

@protocol StorePanelDelegate <NSObject>
@optional
- (void)storePanelManagerInAppPurchaseSelected:(InAppPurchase *)iap;
@end

@interface StorePanelManagerNode : ActorNode

// An optional delegate to receive information about what items were selected
@property (nonatomic, weak) id<StorePanelDelegate> delegate;

- (instancetype)init;

- (void)activate;
- (void)deactivate;

- (void)showFirst;

@end
