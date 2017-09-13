//
//  ImageButtonNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ButtonNode.h"
#import "LabelNode.h"

@interface ImageButtonNode : ButtonNode

+ (ImageButtonNode *)imageButtonWithName:(NSString *)buttonName andButtonColor:(UIColor*)buttonColor andTagName:(NSString *)tagName andTagAlignment:(TagHorizontalAlignment)alignment;

- (instancetype)init NS_UNAVAILABLE;

- (void)setLabelWithText:(NSString *)text withFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor;

- (void)setLabelHorizontalAlignment:(LabelHorizontalAlignment)horizontalAlignment;
- (void)setLabelVerticalAlignment:(LabelVerticalAlignment)verticalAlignment;

- (void)setLabelFixedWidth:(CGFloat)width;
- (void)setLabelFixedHeight:(CGFloat)height;

- (void)setLabelPosition:(SCNVector3)position;

- (void)activate;
- (void)deactivate;

- (void)animateTag;

- (void)pressButton;
- (void)releaseButton;

- (void)cancelButton;

- (void)updateLabelText:(NSString *)text;

- (void)EnableButton:(BOOL)buttonEnabled;

@end
