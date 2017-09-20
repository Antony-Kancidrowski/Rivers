//
//  ImageButtonNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ImageButtonNode.h"

#import "ImageNode.h"

#import "Configuration.h"
#import "AppSpecificValues.h"

@interface ImageButtonNode ()
{
    TagHorizontalAlignment tagAlignment;
    
    ImageNode *tagEnabledImage;
    ImageNode *tagDisabledImage;
    
    LabelNode *label;
    
    NSString *name;
    NSString *tag;
    
    ImageNode *buttonUpImage;
    ImageNode *buttonDownImage;
    ImageNode *buttonDisabledImage;
    
    SCNAction *animateTagAction;
    
    UIColor *color;
}
@end

@implementation ImageButtonNode

static const CGFloat tagScaleX = 0.8f;
static const CGFloat tagScaleY = 0.8f;

+ (ImageButtonNode *)imageButtonWithName:(NSString *)buttonName andButtonColor:(UIColor*)buttonColor  andTagName:(NSString *)tagName andTagAlignment:(TagHorizontalAlignment)alignment {
    
    ImageButtonNode *newButton = [[ImageButtonNode alloc] initWithName:(NSString *)buttonName andButtonColor:(UIColor*)buttonColor andTagName:(NSString *)tagName andTagAlignment:(TagHorizontalAlignment)alignment];
    
    return newButton;
}

- (instancetype)initWithName:(NSString *)buttonName andButtonColor:(UIColor*)buttonColor andTagName:(NSString *)tagName andTagAlignment:(TagHorizontalAlignment)alignment {
    
    self = [super init];
    
    if (self != nil)
    {
        name = buttonName;
        
        tag = tagName;
        tagAlignment = alignment;
        
        label = nil;
        
        color = buttonColor;
        
        [self EnableButton:TRUE];
    }
    
    return self;
}

- (void)setup:(SCNNode*)parentNode {
    
    [super setup:parentNode];
    
    
    if (tag) {
        
        CGFloat tagX = 0.0f;
        
        switch (tagAlignment) {
            case TagHorizontalAlignmentLeft:
                tagX = -2.5f;
                break;
                
            case TagHorizontalAlignmentRight:
                tagX = 2.5f;
                break;
                
            case TagHorizontalAlignmentCenter:
                tagX = 0.0f;
                break;
                
            default:
                NSAssert(false, @"Unknown alignment.");
                break;
        }
        
        NSString *enabledTag = [NSString stringWithFormat:@"%@.png", tag];
        tagEnabledImage = [ImageNode imageWithTextureNamed:enabledTag];
        
        [tagEnabledImage setScale:SCNVector3Make(tagScaleX, tagScaleY, 1.0f)];
        [tagEnabledImage setPosition:SCNVector3Make(tagX, 0.0f, 0.01f)];
        [tagEnabledImage setEulerAngles:SCNVector3Zero];
        
        [tagEnabledImage setHidden:![self isButtonEnabled]];
        
        [tagEnabledImage setup:self];
        
        NSString *disabledTag = [NSString stringWithFormat:@"%@-disabled.png", tag];
        tagDisabledImage = [ImageNode imageWithTextureNamed:disabledTag];
        
        [tagDisabledImage setScale:SCNVector3Make(tagScaleX, tagScaleY, 1.0f)];
        [tagDisabledImage setPosition:SCNVector3Make(tagX, 0.0f, 0.01f)];
        [tagDisabledImage setEulerAngles:SCNVector3Zero];
        
        [tagDisabledImage setHidden:[self isButtonEnabled]];
        
        [tagDisabledImage setup:self];
    }
    
    if (name) {
        
        NSString *upName = [NSString stringWithFormat:@"%@-up.png", name];
        buttonUpImage = [ImageNode imageWithTextureNamed:upName];
        
        [buttonUpImage setScale:SCNVector3Make(2.24f, 0.48f, 1.0f)];
        [buttonUpImage setPosition:SCNVector3Zero];
        [buttonUpImage setEulerAngles:SCNVector3Zero];
        [buttonUpImage setOpacity:0.6f];
        
        [buttonUpImage setHidden:![self isButtonEnabled]];
        
        SCNMaterial *buttonUpMaterial = buttonUpImage.geometry.firstMaterial;
        buttonUpMaterial.diffuse.intensity = kIntensity;
        buttonUpMaterial.specular.intensity = kIntensity;
        
        if (color) {
            
            [buttonUpImage colorizeWithColor:color];
        }
        
        [buttonUpImage setup:self];
        
        
        NSString *downName = [NSString stringWithFormat:@"%@-down.png", name];
        buttonDownImage = [ImageNode imageWithTextureNamed:downName];
        
        [buttonDownImage setScale:SCNVector3Make(2.24f, 0.48f, 1.0f)];
        [buttonDownImage setPosition:SCNVector3Zero];
        [buttonDownImage setEulerAngles:SCNVector3Zero];
        [buttonDownImage setOpacity:0.6f];
        
        [buttonDownImage setHidden:YES];
        
        if (color) {
            
            [buttonDownImage colorizeWithColor:color];
        }
        
        SCNMaterial *buttonDownMaterial = buttonDownImage.geometry.firstMaterial;
        buttonDownMaterial.diffuse.intensity = kIntensity;
        buttonDownMaterial.specular.intensity = kIntensity;
        
        [buttonDownImage setup:self];
        
        
        buttonDisabledImage = [ImageNode imageWithTextureNamed:@"graybutton-up.png"];
        
        [buttonDisabledImage setScale:SCNVector3Make(2.24f, 0.48f, 1.0f)];
        [buttonDisabledImage setPosition:SCNVector3Zero];
        [buttonDisabledImage setEulerAngles:SCNVector3Zero];
        [buttonDisabledImage setOpacity:0.6f];
        
        [buttonDisabledImage setHidden:[self isButtonEnabled]];
        
        SCNMaterial *buttonDisabledMaterial = buttonDisabledImage.geometry.firstMaterial;
        buttonDisabledMaterial.diffuse.intensity = kIntensity;
        buttonDisabledMaterial.specular.intensity = kIntensity;
        
        [buttonDisabledImage setup:self];
    }
    
    animateTagAction = [SCNAction sequence:@[
                                       [SCNAction waitForDuration:0.75],
                                       [SCNAction scaleBy:1.1f duration:0.25],
                                       [SCNAction scaleBy:(1.0f / 1.1f) duration:0.125]
                                  ]
             ];
}

// Screen Capture
//
//    CGRect bounds = self.scene.view.bounds;
//    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
//    [self drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
//    UIImage* screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

- (void)setLabelWithText:(NSString *)text withFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor {
    
    NSShadow *myShadow = [NSShadow new];
    [myShadow setShadowColor:[UIColor blackColor]];
    [myShadow setShadowBlurRadius:5.0];
    [myShadow setShadowOffset:CGSizeMake(2, 2)];
    
    label = [LabelNode setLabelWithText:text withFontNamed:fontName fontSize:fontSize fontColor:fontColor];
    [label setShadow:myShadow];
    
    [label setScale:SCNVector3Make(1.12f, 0.36f, 1.0f)];
    [label setPosition:SCNVector3Make(0.0f, 0.0f, 0.01f)];
    
    [label setup:self];
}

- (void)setLabelHorizontalAlignment:(LabelHorizontalAlignment)horizontalAlignment {
    
    [label setHorizontalAlignment:horizontalAlignment];
    
    [label drawLabel];
}

- (void)setLabelVerticalAlignment:(LabelVerticalAlignment)verticalAlignment {
    
    [label setVerticalAlignnment:verticalAlignment];
    
    [label drawLabel];
}

- (void)setLabelFixedWidth:(CGFloat)width {
    
    [label setFixedWidth:width];
    
    [label drawLabel];
}

- (void)setLabelFixedHeight:(CGFloat)height {
    
    [label setFixedHeight:height];
    
    [label drawLabel];
}

- (void)setLabelPosition:(SCNVector3)position {
    
    [label setPosition:position];
}

- (void)updateLabelText:(NSString *)text {
    
    [label updateText:text];
    [label drawLabel];
}

- (void)EnableButton:(BOOL)buttonEnabled {
    
    if (tag) {
        
        [tagEnabledImage setHidden:!buttonEnabled];
        [tagEnabledImage setScale:SCNVector3Make(tagScaleX, tagScaleY, 1.0f)];
        
        [tagDisabledImage setHidden:buttonEnabled];
        [tagDisabledImage setScale:SCNVector3Make(tagScaleX, tagScaleY, 1.0f)];
    }
    
    if (name) {
        
        [buttonDownImage setHidden:YES];
        [buttonUpImage setHidden:!buttonEnabled];
        
        [buttonDisabledImage setHidden:buttonEnabled];
    }
    
    SCNMaterial *buttonMaterial = label.geometry.firstMaterial;
    buttonMaterial.diffuse.intensity = buttonEnabled ? kIntensity : (kIntensity / 3.0f);
    buttonMaterial.specular.intensity = buttonEnabled ? kIntensity : (kIntensity / 3.0f);
 
    [super EnableButton:buttonEnabled];
}


- (void)pressButton {
    
    if (![self isButtonEnabled]) {
        
        return;
    }

    if (name) {
        
        [buttonDownImage setHidden:NO];
        [buttonUpImage setHidden:YES];
    }
    
    [super pressButton];
}

- (void)releaseButton {
    
    if (![self isButtonEnabled]) {
        
        return;
    }

    if (name) {
        
        [buttonDownImage setHidden:YES];
        [buttonUpImage setHidden:NO];
    }
    
    [super releaseButton];
}

- (void)cancelButton {
    
    if (![self isButtonEnabled]) {
        
        return;
    }
    
    if (name) {
        
        [buttonDownImage setHidden:YES];
        [buttonUpImage setHidden:NO];
    }
    
    [super cancelButton];
}

- (void)animateTag {
    
    [tagEnabledImage runAction:animateTagAction];
    [tagDisabledImage runAction:animateTagAction];
}

- (void)activate {
    
    [super activate];
    
    if (tag) {
        
        [tagEnabledImage setScale:SCNVector3Make(tagScaleX, tagScaleY, 1.0f)];
        [tagEnabledImage activate];
        
        [tagDisabledImage setScale:SCNVector3Make(tagScaleX, tagScaleY, 1.0f)];
        [tagDisabledImage activate];
    }
    
    if (label) {
        
        [label activate];
    }
    
    if (name) {
        
        [buttonUpImage activate];
        [buttonDownImage activate];
        
        [buttonDisabledImage activate];
    }
}

- (void)deactivate {
    
    if (tag) {
        
        [tagEnabledImage deactivate];
        [tagDisabledImage deactivate];
    }
    
    if (label) {
        
        [label deactivate];
    }
    
    if (name) {
        
        [buttonUpImage deactivate];
        [buttonDownImage deactivate];
        
        [buttonDisabledImage deactivate];
    }
    
    [super deactivate];
}

@end
