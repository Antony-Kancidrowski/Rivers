//
//  StoreViewController.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "StoreViewController.h"

#import "TexturedBackgroundNode.h"

#import "AppSpecificValues.h"
#import "DebugOptions.h"

#import "StorePanelNode.h"

#import "ImageButtonNode.h"
#import "ImageNode.h"
#import "LabelNode.h"

#import "AchievementPopupManagerNode.h"
#import "GameCenterManager.h"

#import "InAppPurchasesManager.h"

#import "SoundManager.h"

#import "GamesManager.h"
#import "Game.h"

@interface StoreViewController ()
{
    StorePanelManagerNode *storePanelManager;
    
    InAppPurchase *selectedInAppPurchase;
    
    ImageNode *storePanel;
    
    LabelNode *headerText;
    LabelNode *openClosedText;
    
    ImageNode *openClosed;
    
    ImageButtonNode *purchaseButton;
    ImageButtonNode *restoreButton;
    ImageButtonNode *closeButton;
    
    ButtonNode *selectedButton;
    
    SCNAction *buttonLure;
}
@end

@implementation StoreViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.background = [TexturedBackgroundNode backgroundWithTextureNamed:@"black-background.png"];
    
    [self.background setScale:SCNVector3Make(8.0f, 8.0f, 0.0f)];
    [self.background setPosition:SCNVector3Zero];
    
    [self.background setup:self.scene.rootNode];
    
    storePanel = [ImageNode imageWithTextureNamed:@"store-panel.png" andSize:CGSizeMake(1.75f, 2.25f)];
    
    CGFloat scaleX = 1.80f;
    CGFloat scaleY = 1.80f;// * self.aspectRatio;
    
    [storePanel setScale:SCNVector3Make(scaleX, scaleY, 1.0f)];
    [storePanel setup:self.scene.rootNode];
    
    openClosed = [ImageNode imageWithTextureNamed:@"store-open-closed.png"];
    
    [openClosed setScale:SCNVector3Make(2.90f / 4.0f, 1.94f / 4.0f, 1.0f)];
    [openClosed setPosition:SCNVector3Make(0.0f, 0.54f, 0.01f)];
    
    [openClosed setup:storePanel];
    
    
    storePanelManager = [StorePanelManagerNode new];
    [storePanelManager setScale:SCNVector3Make(1.85f / 2.45f, 1.85f / 2.45f, 1.0f)];
    [storePanelManager setPosition:SCNVector3Make(0.0f, 0.0f, 0.0f)];
    
    [storePanelManager setDelegate:self];
    [storePanelManager setup:storePanel];
    
    
    NSShadow *myShadow = [NSShadow new];
    [myShadow setShadowColor:[UIColor blackColor]];
    [myShadow setShadowBlurRadius:5.0];
    [myShadow setShadowOffset:CGSizeMake(2, 2)];
    
    headerText = [LabelNode setLabelWithText:NSLocalizedString(@"Store", nil) withFontNamed:@"Zapfino" fontSize:60 fontColor:[UIColor whiteColor]];
    [headerText setShadow:myShadow];
    
    [headerText setScale:SCNVector3Make(0.3f, 0.2f, 1.0f)];
    [headerText setPosition:SCNVector3Make(0.0f, 0.925f, 1.4f)];
    
    [headerText setup:storePanel];
    
    openClosedText = [LabelNode setLabelWithText:NSLocalizedString(@"Closed", nil) withFontNamed:@"BradleyHandITCTT-Bold" fontSize:60 fontColor:[UIColor blackColor]];
    [openClosedText setShadow:myShadow];
    
    [openClosedText setScale:SCNVector3Make(0.5f, 0.35f, 1.0f)];
    [openClosedText setPosition:SCNVector3Make(0.0f, -0.15f, 0.5f)];
    [openClosedText setOpacity:0.5f];
    
    [openClosedText setup:openClosed];
    
    
    static const CGFloat arrowscale = 0.05f;
    
    const CGFloat scale = 0.18;
    
    const CGFloat menuWidth = 240.0f;
    const CGFloat menuHeight = 80.0f;
    
    purchaseButton = [ImageButtonNode imageButtonWithName:@"redbutton" andButtonColor:nil andTagName:@"shop" andTagAlignment:TagHorizontalAlignmentLeft];
    [purchaseButton setLabelWithText:NSLocalizedString(@"Purchase", nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [purchaseButton setLabelFixedWidth:menuWidth];
    [purchaseButton setLabelFixedHeight:menuHeight];
    [purchaseButton setLabelPosition:SCNVector3Make(0.0f, -0.12f, 0.05f)];
    
    [purchaseButton setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [purchaseButton setPosition:SCNVector3Make(0.0f, -0.4f, 1.0f)];
    
    [purchaseButton EnableButton:NO];
    
    [purchaseButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [purchaseButton addTarget:self action:@selector(purchaseCurrentProduct) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [purchaseButton setup:storePanel];
    
    
    restoreButton = [ImageButtonNode imageButtonWithName:@"yellowbutton" andButtonColor:nil andTagName:@"restore" andTagAlignment:TagHorizontalAlignmentRight];
    [restoreButton setLabelWithText:NSLocalizedString(@"Restore", nil) withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [restoreButton setLabelFixedWidth:menuWidth];
    [restoreButton setLabelFixedHeight:menuHeight];
    [restoreButton setLabelPosition:SCNVector3Make(0.0f, -0.12f, 0.05f)];
    
    [restoreButton setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [restoreButton setPosition:SCNVector3Make(0.0f, -0.7f, 1.0f)];
    
    [restoreButton EnableButton:NO];
    
    [restoreButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [restoreButton addTarget:self action:@selector(restorePurchases) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [restoreButton setup:storePanel];
    
    
    closeButton = [ImageButtonNode imageButtonWithName:nil andButtonColor:nil andTagName:@"menu-close-x" andTagAlignment:TagHorizontalAlignmentCenter];
    [closeButton setScale:SCNVector3Make(2.5f * arrowscale, 2.5f * arrowscale, 1.0f)];
    [closeButton setPosition:SCNVector3Make(0.925f * (1.85f / 2.45f), 0.925f, 0.6f)];
    
    [closeButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [closeButton addTarget:self action:@selector(dismissStore) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [closeButton setup:storePanel];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = self.scene;
    
    scnView.pointOfView = [self.camera mainCameraNode];
    
    // configure the view
    scnView.backgroundColor = [UIColor clearColor];
    
    buttonLure = [SCNAction sequence:@[
                                         [SCNAction waitForDuration:2.5],
                                         [SCNAction scaleBy:1.05f duration:0.5],
                                         [SCNAction scaleBy:(1.0f / 1.05f) duration:0.5],
                                         [SCNAction waitForDuration:2.5]
                                         ]
                    ];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.background activate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveInAppPurchasePanelsNotification:)
                                                 name:kInAppPurchasePanelsNotification
                                               object:nil];
    
    [storePanelManager activate];
    
    [storePanel activate];
    
    [openClosed activate];
    [openClosedText activate];
    
    [headerText activate];
    
    [purchaseButton activate];
    [restoreButton activate];
    [closeButton activate];
    [closeButton runAction:[SCNAction repeatActionForever:buttonLure]];
    
    AchievementPopupManagerNode *achievementManager = [[GameCenterManager sharedGameCenterManager] achievementManager];
    [achievementManager setEulerAngles:SCNVector3Zero];
    [achievementManager setPosition:SCNVector3Zero];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [storePanelManager showFirst];
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self.background deactivate];
    
    [storePanelManager deactivate];
    
    [storePanel deactivate];
    
    [openClosed deactivate];
    [openClosedText deactivate];
    
    [headerText deactivate];
    
    [purchaseButton deactivate];
    [restoreButton deactivate];
    [closeButton deactivate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

#pragma mark - Autorotation and Layout

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    [self setlayout];
}

- (void)setlayout {
    
    // Retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    SCNCamera *cam = scnView.pointOfView.camera;
    
    SCNMatrix4 pt = cam.projectionTransform;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        self.xmultiplier = self.view.frame.size.width / 320.0f;
        self.ymultiplier = self.view.frame.size.height / 480.0f;
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        self.xmultiplier = self.view.frame.size.width / 768.0f;
        self.ymultiplier = self.view.frame.size.height / 1024.0f;
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"UIInterfaceOrientationPortrait");
    } else {
        
        self.xmultiplier *= self.view.frame.size.width / self.view.frame.size.height;
        self.ymultiplier *= self.view.frame.size.width / self.view.frame.size.height;
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"UIInterfaceOrientationLandscape");
    }
    
    // TODO: Layout
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Camera projection transform %f, %f", pt.m33, pt.m43);
}

#pragma mark - Gestures

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)gestureRecognize {
    
    if (self.gridMenuShown) {
        
        return;
    }
    
    if (gestureRecognize.state == UIGestureRecognizerStateBegan) {
        
        // Retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        
        // Check what nodes are tapped
        CGPoint p = [gestureRecognize locationInView:scnView];
        
        NSArray *hitResults = [scnView hitTest:p options:nil];
        
        // Check that we clicked on at least one object
        if([hitResults count] > 0) {
            
            selectedButton = nil;
            
            for (int i = 0; i < [hitResults count]; ++i) {
                
                SCNHitTestResult *result = [hitResults objectAtIndex:i];
                
                if ([result.node.parentNode isKindOfClass:[ButtonNode class]]) {
                    
                    selectedButton = (ButtonNode *)result.node.parentNode;
                } else {
                    
                    continue;
                }
            }
            
            if (selectedButton != nil) {
                
                [selectedButton pressButton];
            }
        }
    } else if (gestureRecognize.state == UIGestureRecognizerStateChanged) {
        
        if (selectedButton == nil) {
            
            return;
        }
        
        // Retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        
        // Check what nodes are tapped
        CGPoint p = [gestureRecognize locationInView:scnView];
        
        NSArray *hitResults = [scnView hitTest:p options:nil];
        
        // Check that we clicked on at least one object
        if([hitResults count] > 0) {
            
            ButtonNode *current;
            
            for (int i = 0; i < [hitResults count]; ++i) {
                
                SCNHitTestResult *result = [hitResults objectAtIndex:i];
                
                if ([result.node.parentNode isKindOfClass:[ButtonNode class]]) {
                    
                    current = (ButtonNode *)result.node.parentNode;
                    
                    if (current == selectedButton) {
                        
                        return;
                    }
                } else {
                    
                    continue;
                }
            }
            
            [selectedButton cancelButton];
            
            selectedButton = nil;
        }
        
    } else if (gestureRecognize.state == UIGestureRecognizerStateEnded) {
        
        if (selectedButton != nil) {
            
            [selectedButton releaseButton];
            selectedButton = nil;
        }
    }
}

#pragma mark Navigation

- (void)dismissStore {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        // Retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        scnView.scene = nil;
        
        self.background = nil;

        storePanelManager = nil;
        
        selectedInAppPurchase = nil;
        
        storePanel = nil;
        
        headerText = nil;
        
        purchaseButton = nil;
        closeButton = nil;
        
        selectedButton = nil;
    }];
}

#pragma mark Store

- (BOOL)canMakePurchases {
    
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseCurrentProduct {
    
    [self purchaseMyProduct:[selectedInAppPurchase product]];
}

- (void)restorePurchases {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)purchaseMyProduct:(SKProduct *)product {
    
    if ([self canMakePurchases]) {
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    } else {
        
        // TODO: Show purchaes are disabled
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Purchases are disabled in your device");
    }
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    GamesManager *gamesManager = [GamesManager sharedGamesManager];
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchasing:
                
                if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                    NSLog(@"Purchasing");
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                if ([transaction.payment.productIdentifier isEqualToString:kIAPUnlockZen]) {
                    
                    // TODO: Show purchae success
                    
                    for (Game* game in [gamesManager storedZenGames]) {
                        
                        [game setLocked:FALSE];
                    }
                    
                    [gamesManager save];
                    
                    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                        NSLog(@"Unlock Zen purchase - Completed succesfully.");
                    
                } else if ([transaction.payment.productIdentifier isEqualToString:kIAPUnlockTimed]) {
                    
                    // TODO: Show purchase success
                    
                    for (Game* game in [gamesManager storedTimedGames]) {
                        
                        [game setLocked:FALSE];
                    }
                    
                    [gamesManager save];
                    
                    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                        NSLog(@"Unlock Timed purchase - Completed succesfully.");
                    
                } else if ([transaction.payment.productIdentifier isEqualToString:kIAPUnlockKeys]) {
                    
                    // TODO: Show purchase success
                    
                    [[[GamesManager sharedGamesManager] consumablePurchasesController] purchasedMasterKeysConsumable];
                    
                    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                        NSLog(@"Master Keys purchase - Completed succesfully.");
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                
                if ([transaction.payment.productIdentifier isEqualToString:kIAPUnlockZen]) {
                    
                    // TODO: Show restore success
                    
                    for (Game* game in [gamesManager storedZenGames]) {
                     
                        [game setLocked:FALSE];
                    }
                    
                    [gamesManager save];
                    
                    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                        NSLog(@"Unlock Zen restore - Completed succesfully.");
                    
                } else if ([transaction.payment.productIdentifier isEqualToString:kIAPUnlockTimed]) {
                    
                    // TODO: Show restore success
                    
                    for (Game* game in [gamesManager storedTimedGames]) {
                        
                        [game setLocked:FALSE];
                    }
                    
                    [gamesManager save];
                    
                    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                        NSLog(@"Unlock Timed restore - Completed succesfully.");
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                
                // TODO: Show failed...you have not been charged
                
                if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
                    NSLog(@"Purchase failed ");
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark Notifications

- (void)receiveInAppPurchasePanelsNotification:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:kInAppPurchasePanelsNotification]) {
        
        [purchaseButton EnableButton:YES];
        [restoreButton EnableButton:YES];
        
        [openClosed setHidden:YES];
        [openClosedText setHidden:YES];
        
        [purchaseButton runAction:[SCNAction repeatActionForever:buttonLure]];
        [restoreButton runAction:[SCNAction repeatActionForever:buttonLure]];
    }
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(kInAppPurchasePanelsNotification);
}

#pragma mark StorePanelDelegate

- (void)storePanelManagerInAppPurchaseSelected:(InAppPurchase *)iap {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"In App Purchase: %@", [iap name]);
    
    selectedInAppPurchase = iap;
}

@end
