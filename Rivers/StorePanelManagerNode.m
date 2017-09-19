//
//  StorePanelManagerNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "StorePanelManagerNode.h"

#import "StorePanelNode.h"

#import "AppSpecificValues.h"
#import "DebugOptions.h"

#import "SoundManager.h"

#import "InAppPurchasesManager.h"
#import "InAppPurchase.h"

#import "ImageButtonNode.h"

static const CGFloat offset = 0.65f;

@interface StorePanelManagerNode ()
{
    NSMutableArray *panels;
    
    NSUInteger selectedPanel;
    
    ImageButtonNode *arrowLeft;
    ImageButtonNode *arrowRight;
    
    NSUInteger lastId;
    
    SCNAction *buttonLure;
}
@end

@implementation StorePanelManagerNode

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil)
    {
        lastId = 0;
        
        panels = [NSMutableArray new];
    }
    
    return self;
}

- (InAppPurchase *)iapAtIndex:(NSUInteger)index {
    
    InAppPurchase *iap = nil;
    
    NSUInteger count = [[InAppPurchasesManager sharedInAppPurchasesManager] purchasableItems];
    
    if (index < count) {
        
        iap = [InAppPurchasesManager iapAtIndex:index];
    }
    
    NSAssert((iap != nil), @"Invalid In App Purchase.");
    
    return iap;
}

- (void)addPanelForInAppPurchase:(NSUInteger)iapId {
    
    InAppPurchase *iap = [self iapAtIndex:iapId];
    
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    StorePanelNode *panel = [StorePanelNode panelWithInAppPurchase:iap];
    
    [panel setScale:SCNVector3Make(0.15f, 0.15f, 0.15f)];
    [panel setOpacity:0.0f];
    
    x = offset;
    y = offset;
    
    [panel setPosition:SCNVector3Make(x, y, 0.01f)];
    
    [panel setup:self];
    
    [panels addObject:panel];
    
    lastId++;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    // Add the panels here
    for (int i = 0; i < [[[InAppPurchasesManager sharedInAppPurchasesManager] storedInAppPurchases] count]; ++i) {
        
        [self addPanelForInAppPurchase:i];
    }
    
    static const CGFloat scale = 0.12f;
    
    arrowLeft = [ImageButtonNode imageButtonWithName:nil andButtonColor:nil andTagName:@"selectionArrowLeft" andTagAlignment:TagHorizontalAlignmentCenter];
    
    [arrowLeft setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [arrowLeft setPosition:SCNVector3Make(-0.525f, self.position.y, self.position.z + 1.0f)];
    [arrowLeft setEulerAngles:SCNVector3Zero];
    
//    [arrowLeft setOpacity:0.35f];
    
    [arrowLeft addTarget:self action:@selector(moveLeft) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [arrowLeft setup:parentNode];
    
    arrowRight = [ImageButtonNode imageButtonWithName:nil andButtonColor:nil andTagName:@"selectionArrowRight" andTagAlignment:TagHorizontalAlignmentCenter];
    
    [arrowRight setScale:SCNVector3Make(1.0f * scale, 1.0f * scale, 1.0f)];
    [arrowRight setPosition:SCNVector3Make(0.525f, self.position.y, self.position.z + 1.0f)];
    [arrowRight setEulerAngles:SCNVector3Zero];
    
//    [arrowRight setOpacity:0.35f];
    
    [arrowRight addTarget:self action:@selector(moveRight) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [arrowRight setup:parentNode];
    
    [self updateArrows];
    
    buttonLure = [SCNAction sequence:@[
                                       [SCNAction waitForDuration:2.5],
                                       [SCNAction scaleBy:1.05f duration:0.5],
                                       [SCNAction scaleBy:(1.0f / 1.05f) duration:0.5],
                                       [SCNAction waitForDuration:2.5]
                                       ]
                  ];
}

- (void)receiveInAppPurchasesDownloadedNotification:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:kInAppPurchasesDownloadedNotification]) {
        
        // Add the panels here
        for (int i = 0; i < [[[InAppPurchasesManager sharedInAppPurchasesManager] storedInAppPurchases] count]; ++i) {
            
            [self addPanelForInAppPurchase:i];
        }
        
        for (StorePanelNode *panel in panels) {
            
            [panel activate];
        }
        
        [self updateArrows];
        [self showFirst];
    }
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(kInAppPurchasesDownloadedNotification);
}

- (void)activate {
    
    [super activate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveInAppPurchasesDownloadedNotification:)
                                                 name:kInAppPurchasesDownloadedNotification
                                               object:nil];
    
    for (StorePanelNode *panel in panels) {
        
        [panel activate];
    }
    
    [arrowLeft activate];
    [arrowLeft runAction:[SCNAction repeatActionForever:buttonLure]];
    
    [arrowRight activate];
    [arrowRight runAction:[SCNAction repeatActionForever:buttonLure]];
}

- (void)showFirst {
    
    if ([panels count] > 0) {
        
        const NSTimeInterval duration = 0.5;
        
        StorePanelNode *currentPanel = [panels objectAtIndex:selectedPanel];
        
        __block SCNVector3 previousStart = [currentPanel position];
        
        SCNAction *customSwooshIn = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * -elapsedtime / 0.5f);
            CGFloat y = -offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(previousStart.x + x, previousStart.y + y, previousStart.z + z)];
        }];
        
        [currentPanel runAction:[SCNAction group:@[
                                                   [SCNAction waitForDuration:0.75],
                                                   customSwooshIn,
                                                   [SCNAction scaleTo:1.3f duration:duration],
                                                   [SCNAction fadeInWithDuration:duration],
                                                   [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
                                                   ]] forKey:@"SwooshIn"];
        
        
        id<StorePanelDelegate> delegate = self.delegate;
        
        if ([delegate respondsToSelector:@selector(storePanelManagerInAppPurchaseSelected:)]) {
            
            [delegate storePanelManagerInAppPurchaseSelected:[self iapAtIndex:selectedPanel]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchasePanelsNotification
                                                            object:nil];
    }
}

- (void)deactivate {
    
    for (StorePanelNode *panel in panels) {
        
        [panel deactivate];
    }
    
    [arrowLeft deactivate];
    [arrowRight deactivate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super deactivate];
}

- (void)updateArrows {
    
    if ([panels count] > 0) {
        
        [arrowLeft setHidden:(selectedPanel > 0) ? NO : YES];
        [arrowRight setHidden:(selectedPanel < (lastId - 1)) ? NO : YES];
    } else {
        
        [arrowLeft setHidden:YES];
        [arrowRight setHidden:YES];
    }
}

- (void)moveRight {
    
    if (selectedPanel < (lastId - 1)) {
        
        const NSTimeInterval duration = 0.5;
        
        StorePanelNode *currentPanel = [panels objectAtIndex:selectedPanel];
        
        if (([currentPanel actionForKey:@"SwooshIn"] != nil) || ([currentPanel actionForKey:@"SwooshOut"] != nil)) {
            
            return;
        }
        
        __block SCNVector3 currentStart = [currentPanel position]; //[[currentPanel presentationNode] position];
        
        SCNAction *customSwooshOut = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * -elapsedtime / 0.5f);
            CGFloat y = offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(currentStart.x + x, currentStart.y + y, currentStart.z + z)];
        }];
        
        [currentPanel runAction:[SCNAction group:@[
            customSwooshOut,
            [SCNAction scaleTo:0.15f duration:duration],
            [SCNAction fadeOutWithDuration:duration],
            [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
        ]] forKey:@"SwooshOut"];
        
        selectedPanel++;
        
        StorePanelNode *nextPanel = [panels objectAtIndex:selectedPanel];
        
        __block SCNVector3 nextStart = [nextPanel position]; //[[nextPanel presentationNode] position];
        
        SCNAction *customSwooshIn = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * -elapsedtime / 0.5f);
            CGFloat y = -offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(nextStart.x + x, nextStart.y + y, nextStart.z + z)];
        }];
        
        [nextPanel runAction:[SCNAction group:@[
            customSwooshIn,
            [SCNAction scaleTo:1.3f duration:duration],
            [SCNAction fadeInWithDuration:duration],
            [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
        ]] forKey:@"SwooshIn"];
    }
    
    id<StorePanelDelegate> delegate = self.delegate;
    
    if ([delegate respondsToSelector:@selector(storePanelManagerInAppPurchaseSelected:)]) {
        
        [delegate storePanelManagerInAppPurchaseSelected:[self iapAtIndex:selectedPanel]];
    }
    
    [self updateArrows];
}

- (void)moveLeft {
    
    if (selectedPanel > 0) {
        
        const NSTimeInterval duration = 0.5;
        
        StorePanelNode *currentPanel = [panels objectAtIndex:selectedPanel];
        
        if (([currentPanel actionForKey:@"SwooshIn"] != nil) || ([currentPanel actionForKey:@"SwooshOut"] != nil)) {
            
            return;
        }
        
        __block SCNVector3 currentStart = [currentPanel position];
        
        SCNAction *customSwooshOut = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * elapsedtime / 0.5f);
            CGFloat y = offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(currentStart.x + x, currentStart.y + y, currentStart.z + z)];
        }];
        
        [currentPanel runAction:[SCNAction group:@[
            customSwooshOut,
            [SCNAction scaleTo:0.15f duration:duration],
            [SCNAction fadeOutWithDuration:duration],
            [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
        ]] forKey:@"SwooshOut"];
        
        selectedPanel--;
        
        StorePanelNode *previousPanel = [panels objectAtIndex:selectedPanel];
        
        __block SCNVector3 previousStart = [previousPanel position];
        
        SCNAction *customSwooshIn = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
            
            CGFloat x = offset * sinf(M_PI_2 * elapsedtime / 0.5f);
            CGFloat y = -offset * elapsedtime / 0.5f;
            CGFloat z = 0.0f;
            
            [node setPosition:SCNVector3Make(previousStart.x + x, previousStart.y + y, previousStart.z + z)];
        }];
        
        [previousPanel runAction:[SCNAction group:@[
            customSwooshIn,
            [SCNAction scaleTo:1.3f duration:duration],
            [SCNAction fadeInWithDuration:duration],
            [SoundManager selectionSlideSoundActionWithWaitForCompletion:NO]
        ]] forKey:@"SwooshIn"];
    }
    
    id<StorePanelDelegate> delegate = self.delegate;
    
    if ([delegate respondsToSelector:@selector(storePanelManagerInAppPurchaseSelected:)]) {
        
        [delegate storePanelManagerInAppPurchaseSelected:[self iapAtIndex:selectedPanel]];
    }
    
    [self updateArrows];
}

@end
