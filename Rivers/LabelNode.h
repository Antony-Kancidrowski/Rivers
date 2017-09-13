//
//  LabelNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"

typedef NS_ENUM(NSInteger, LabelVerticalAlignment) {
    
    LabelVerticalAlignmentBaseline    = 0,
    LabelVerticalAlignmentCenter      = 1,
    LabelVerticalAlignmentTop         = 2,
    LabelVerticalAlignmentBottom      = 3,
};

typedef NS_ENUM(NSInteger, LabelHorizontalAlignment) {
    
  LabelHorizontalAlignmentCenter    = 0,
  LabelHorizontalAlignmentLeft      = 1,
  LabelHorizontalAlignmentRight     = 2,
};

@interface LabelNode : ActorNode

+ (LabelNode *)setLabelWithText:(NSString *)text withFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor;
+ (LabelNode *)setLabelWithText:(NSString *)text;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, setter=setHorizontalAlignment:) LabelHorizontalAlignment horizontalAlignment;
@property (nonatomic, setter=setVerticalAlignnment:) LabelVerticalAlignment verticalAlignment;
@property (nonatomic) NSInteger lineSpacing;
@property (nonatomic, strong) NSShadow *shadow;
@property (nonatomic) NSTextAlignment textAlignmentMode;
@property (nonatomic) CGFloat fontSize;

@property (nonatomic) CGFloat fixedWidth;
@property (nonatomic) CGFloat fixedHeight;

@property (nonatomic) NSInteger labelWidth;
@property (nonatomic) NSInteger labelHeight;

@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic) CGSize size;

- (instancetype)init;

- (void)updateText:(NSString *)text;

- (void)drawLabel;

- (void)activate;
- (void)deactivate;

@end
