//
//  LabelNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "LabelNode.h"

@implementation LabelNode

+ (LabelNode *)setLabelWithText:(NSString *)text withFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(UIColor*)fontColor {
    
    LabelNode *labelNode = [LabelNode new];
    
    labelNode.text = text;
    
    labelNode.fontName = fontName;
    labelNode.fontSize = fontSize;
    
    labelNode.fontColor = fontColor;
    
    return labelNode;
}

+ (LabelNode *)setLabelWithText:(NSString *)text {
    
    LabelNode *labelNode = [LabelNode new];
    labelNode.text = text;
    
    return labelNode;
}

- (instancetype)init {
    
    self = [super init];
    
    if(self != nil)
    {
        SCNVector3 vertices[] = {
            
            SCNVector3Make(  1.0f,  1.0f,  1.0f),
            SCNVector3Make(  1.0f, -1.0f,  1.0f),
            SCNVector3Make( -1.0f, -1.0f,  1.0f),
            SCNVector3Make( -1.0f,  1.0f,  1.0f)
        };
        
        SCNVector3 normals[] = {
            
            SCNVector3Make(  0.0f,  0.0f,  1.0f),
            SCNVector3Make(  0.0f,  0.0f,  1.0f),
            SCNVector3Make(  0.0f,  0.0f,  1.0f),
            SCNVector3Make(  0.0f,  0.0f,  1.0f)
        };
        
        float textureCoordinates[] = {
            
            1.00f, 0.00f,
            1.00f, 1.00f,
            0.00f, 1.00f,
            0.00f, 0.00f
        };
        
        NSUInteger vertexCount = 4;
        
        
        NSMutableData *indicesData = [NSMutableData data];
        
        UInt8 indices[] = {
            
            0, 1, 2,
            2, 3, 0
        };
        
        [indicesData appendBytes:indices length:sizeof(UInt8)*6];
        SCNGeometryElement *indicesElement = [SCNGeometryElement geometryElementWithData:indicesData
                                                                           primitiveType:SCNGeometryPrimitiveTypeTriangles
                                                                          primitiveCount:2
                                                                           bytesPerIndex:sizeof(UInt8)];
        
        NSMutableData *vertexData = [NSMutableData dataWithBytes:vertices length:vertexCount * sizeof(SCNVector3)];
        
        SCNGeometrySource *verticesSource = [SCNGeometrySource geometrySourceWithData:vertexData
                                                                             semantic:SCNGeometrySourceSemanticVertex
                                                                          vectorCount:vertexCount
                                                                      floatComponents:YES
                                                                  componentsPerVector:3
                                                                    bytesPerComponent:sizeof(float)
                                                                           dataOffset:0
                                                                           dataStride:sizeof(SCNVector3)];
        
        NSMutableData *normalData = [NSMutableData dataWithBytes:normals length:vertexCount * sizeof(SCNVector3)];
        
        SCNGeometrySource *normalsSource = [SCNGeometrySource geometrySourceWithData:normalData
                                                                            semantic:SCNGeometrySourceSemanticNormal
                                                                         vectorCount:vertexCount
                                                                     floatComponents:YES
                                                                 componentsPerVector:3
                                                                   bytesPerComponent:sizeof(float)
                                                                          dataOffset:0
                                                                          dataStride:sizeof(SCNVector3)];
        
        NSMutableData *textureData = [NSMutableData dataWithBytes:textureCoordinates length:vertexCount * sizeof(float) * 2];
        
        SCNGeometrySource *textureSource = [SCNGeometrySource geometrySourceWithData:textureData
                                                                            semantic:SCNGeometrySourceSemanticTexcoord
                                                                         vectorCount:vertexCount
                                                                     floatComponents:YES
                                                                 componentsPerVector:2
                                                                   bytesPerComponent:sizeof(float)
                                                                          dataOffset:0
                                                                          dataStride:sizeof(float) * 2];
        SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[verticesSource, normalsSource, textureSource]
                                                        elements:@[indicesElement]];
        
        
        SCNMaterial *material = [SCNMaterial material];
        material.diffuse.wrapS = SCNWrapModeRepeat;
        material.diffuse.wrapT = SCNWrapModeRepeat;
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(1.0f, 1.0f, 1.0f);
        material.doubleSided = YES;
        
        material.specular.contents = [UIColor darkGrayColor];
        
        material.normal.wrapS = SCNWrapModeRepeat;
        material.normal.wrapT = SCNWrapModeRepeat;
        material.litPerPixel = YES;
        
        geometry.materials = @[material];
        
        [self setGeometry:geometry];
        
        UIFont *defaultFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        self.fontName = defaultFont.fontName;
        self.fontColor = [UIColor whiteColor];
        self.fontSize = defaultFont.pointSize;
        self.text = [NSString string];
        self.lineSpacing = 1;
        self.shadow = nil;
        
        self.labelWidth = 2048;
        self.labelHeight = 2048;
        
        self.fixedWidth = 0.0f;
        
        self.textAlignmentMode = NSTextAlignmentCenter;
        
        [self setHorizontalAlignment:LabelHorizontalAlignmentCenter];
        [self setVerticalAlignnment:LabelVerticalAlignmentBaseline];
    }
    
    return self;
}

- (void)setVerticalAlignnment:(LabelVerticalAlignment)verticalAlignment {
    
    _verticalAlignment = verticalAlignment;
    
    CGPoint labelAnchorPoint = self.anchorPoint;
    
    if(verticalAlignment == LabelVerticalAlignmentBaseline)
    {
        self.anchorPoint = CGPointMake(labelAnchorPoint.x, 0);
    }
    else if(verticalAlignment == LabelVerticalAlignmentCenter)
    {
        self.anchorPoint = CGPointMake(labelAnchorPoint.x, 0.5);
    }
    else if(verticalAlignment == LabelVerticalAlignmentTop)
    {
        self.anchorPoint = CGPointMake(labelAnchorPoint.x, 1);
    }
    else if(verticalAlignment == LabelVerticalAlignmentBottom)
    {
        self.anchorPoint = CGPointMake(labelAnchorPoint.x, -0.2);
    }
}

- (void)setHorizontalAlignment:(LabelHorizontalAlignment)horizontalAlignment {
    
    _horizontalAlignment = horizontalAlignment;
    
    CGPoint labelAnchorPoint = self.anchorPoint;
    
    if(horizontalAlignment == LabelHorizontalAlignmentCenter)
    {
        self.anchorPoint = CGPointMake(0.5, labelAnchorPoint.y);
    }
    else if(horizontalAlignment == LabelHorizontalAlignmentLeft)
    {
        self.anchorPoint = CGPointMake(0, labelAnchorPoint.y);
    }
    else if(horizontalAlignment == LabelHorizontalAlignmentRight)
    {
        self.anchorPoint = CGPointMake(1, labelAnchorPoint.y);
    }
}

- (void)setup:(SCNNode *)parentNode {
    
    [self drawLabel];
    
    [super setup:parentNode];
}

- (void)updateText:(NSString *)text {
    
    self.text = text;
    
    [self drawLabel];
}

/* you must call drawLabel: before using it and before every time you change the label */

- (void)drawLabel {
    
    // load text attributes
    NSMutableDictionary *textAttributes = [NSMutableDictionary new];
    
    UIFont *font = [UIFont fontWithName:self.fontName size:self.fontSize];
    textAttributes[NSFontAttributeName] = font;
    
    textAttributes[NSForegroundColorAttributeName] = self.fontColor;
    
    if (self.shadow != nil)
    {
        textAttributes[NSShadowAttributeName] = self.shadow;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    paragraphStyle.alignment = self.textAlignmentMode;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = self.lineSpacing;
    
    textAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    // getting the text rect
    CGRect textRect =
    [self.text boundingRectWithSize:CGSizeMake(self.labelWidth,
                                               self.labelHeight)
                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                         attributes:textAttributes
                            context:nil];
    
    CGFloat width = (self.fixedWidth > 0.0f) ? self.fixedWidth : (textRect.size.width + 5);
    CGFloat height = (self.fixedHeight > 0.0f) ? self.fixedHeight : (textRect.size.height + 5);
    
    textRect.size = CGSizeMake(width, height);

    self.size = textRect.size;
    
    NSAttributedString *labelString = [[NSAttributedString alloc] initWithString:self.text attributes:textAttributes];
    
    // Create UIImage
    UIGraphicsBeginImageContextWithOptions(textRect.size, NO, 0);
    [labelString drawInRect:textRect];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Update Node with textImage
    SCNMaterial *material = self.geometry.materials.firstObject;
    
    material.diffuse.contents = textImage;
}

- (void)activate {
    
    [super activate];
}

- (void)deactivate {
    
    [super deactivate];
}

@end
