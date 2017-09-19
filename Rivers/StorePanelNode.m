//
//  StorePanelNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "StorePanelNode.h"

#import "SoundManager.h"

#import "AppSpecificValues.h"

#import "LabelNode.h"
#import "ImageNode.h"

@interface StorePanelNode ()
{
    InAppPurchase* theInAppPurchase;
    
    ImageNode *image;

    LabelNode *title;
    LabelNode *description;
    
    LabelNode *price;
}
@end

@implementation StorePanelNode

+ (StorePanelNode *)panelWithInAppPurchase:(InAppPurchase *)iap {
    
    StorePanelNode *newPanel = [[StorePanelNode alloc] initWithInAppPurchase:iap];
    
    return newPanel;
}

- (instancetype)initWithInAppPurchase:(InAppPurchase *)iap {
    
    self = [super init];
    
    if (self != nil)
    {
        theInAppPurchase = iap;
    }
    
    return self;
}

- (void)setup:(SCNNode *)parentNode {
    
    [super setup:parentNode];
    
    const CGFloat scale = 0.12f;
    
    image = [ImageNode imageWithImage:[theInAppPurchase image]];
    
    [image setScale:SCNVector3Make(4.8f * scale, 4.8f * scale, 1.0f)];
    [image setPosition:SCNVector3Make(0.0f, 0.0f, 0.01f)];
    [image setEulerAngles:SCNVector3Zero];
    
    [image setIntensity:0.8f];
    
    [image setup:self];
    
    const CGFloat width = 350.0f;
    const CGFloat height = 120.0f;

    NSShadow *myShadow = [NSShadow new];
    [myShadow setShadowColor:[UIColor blackColor]];
    [myShadow setShadowBlurRadius:5.0];
    [myShadow setShadowOffset:CGSizeMake(2, 2)];
    
    title = [LabelNode setLabelWithText:[theInAppPurchase name] withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [title setShadow:myShadow];
    
    [title setFixedWidth:width];
    [title setFixedHeight:height];
    
    [title setScale:SCNVector3Make(4.0f * scale, 1.5f * scale, 1.0f)];
    [title setPosition:SCNVector3Make(0.0f, 0.325f, 0.02f)];
    [title setEulerAngles:SCNVector3Zero];
    
    [title setup:self];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[[theInAppPurchase product] priceLocale]];
    
    NSString *cost = [numberFormatter stringFromNumber:[theInAppPurchase price]];
    
    price = [LabelNode setLabelWithText:cost withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor blackColor]];

    [price setScale:SCNVector3Make(1.0f * scale, 0.3f * scale, 1.0f)];
    [price setPosition:SCNVector3Make(-0.19f, -0.01f, 0.02f)];
    [price setEulerAngles:SCNVector3Make(0.0f, 0.0f, M_PI_4)];
    
    [price setup:self];
    
    description = [LabelNode setLabelWithText:[theInAppPurchase description] withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [description setShadow:myShadow];
    
    [description setFixedWidth:width * 1.5f];
    [description setFixedHeight:height * 1.5f];
    
    [description setScale:SCNVector3Make(3.5f * scale, 1.25f * scale, 1.0f)];
    [description setPosition:SCNVector3Make(0.0f, -0.55f, 0.02f)];
    [description setEulerAngles:SCNVector3Zero];
    
    [description setup:self];
}

- (void)activate {
    
    [super activate];
    
    [image activate];

    [title activate];
    [description activate];
    
    [price activate];
}

- (void)deactivate {
    
    [image deactivate];

    [title deactivate];
    [description deactivate];
    
    [price deactivate];
    
    [super deactivate];
}

@end
