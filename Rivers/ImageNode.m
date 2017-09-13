//
//  ImageNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ImageNode.h"

#import "Configuration.h"

@interface ImageNode ()
{
    
}
@end


@implementation ImageNode

+ (ImageNode *)imageWithTextureNamed:(NSString *)textureName andSize:(CGSize)size {
    
    ImageNode *newImage = [[ImageNode alloc] initWithTextureNamed:textureName andSize:size];
    
    return newImage;
}

+ (ImageNode *)imageWithTextureNamed:(NSString *)textureName {
    
    ImageNode *newImage = [[ImageNode alloc] initWithTextureNamed:textureName];
    
    return newImage;
}

+ (ImageNode *)imageWithImage:(UIImage *)image {
    
    ImageNode *newImage = [[ImageNode alloc] initWithTextureNamed:nil];
    
    SCNMaterial *material = newImage.geometry.firstMaterial;
    material.diffuse.contents = image;
    
    return newImage;
}

- (instancetype)initWithTextureNamed:(NSString *)textureName andSize:(CGSize)size {
    
    self = [super init];
    
    CGFloat x = size.width / size.height;
    CGFloat y = 1.0f;
    
    if (self != nil)
    {
        SCNVector3 vertices[] = {
            
            SCNVector3Make(  x,  y,  1.0f),
            SCNVector3Make(  x, -y,  1.0f),
            SCNVector3Make( -x, -y,  1.0f),
            SCNVector3Make( -x,  y,  1.0f)
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
        
        if (textureName) {
            
            material.diffuse.contents = [UIImage imageNamed:textureName];
            material.diffuse.intensity = kIntensity;
        }
        
        material.diffuse.wrapS = SCNWrapModeRepeat;
        material.diffuse.wrapT = SCNWrapModeRepeat;
        material.diffuse.contentsTransform = SCNMatrix4MakeScale( 1.0f, 1.0f, 1.0f);
        material.doubleSided = YES;
        
        material.specular.contents = [UIColor darkGrayColor];
        material.specular.intensity = kIntensity;
        
        material.normal.wrapS = SCNWrapModeRepeat;
        material.normal.wrapT = SCNWrapModeRepeat;
        material.litPerPixel = YES;
        
        geometry.materials = @[material];
        
        [self setGeometry:geometry];
    }
    
    return self;
}

- (instancetype)initWithTextureNamed:(NSString *)textureName {
    
    self = [super init];
    
    if (self != nil)
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
        
        if (textureName) {
        
            material.diffuse.contents = [UIImage imageNamed:textureName];
            material.diffuse.intensity = kIntensity;
        }
        
        material.diffuse.wrapS = SCNWrapModeRepeat;
        material.diffuse.wrapT = SCNWrapModeRepeat;
        material.diffuse.contentsTransform = SCNMatrix4MakeScale( 1.0f, 1.0f, 1.0f);
        material.doubleSided = YES;
        
        material.shininess = 0.25f;
        
        material.specular.contents = [UIColor darkGrayColor];
        material.specular.intensity = kIntensity;
        
        material.normal.wrapS = SCNWrapModeRepeat;
        material.normal.wrapT = SCNWrapModeRepeat;
        material.litPerPixel = YES;
        
        geometry.materials = @[material];
        
        [self setGeometry:geometry];
    }
    
    return self;
}

- (void)colorizeWithColor:(id)color {
    
    SCNMaterial *material = self.geometry.firstMaterial;
    
    material.multiply.contents = color;
}

- (void)setTexture:(NSString *)textureName {
    
    SCNMaterial *material = [[self geometry] firstMaterial];
    
    if (textureName) {
        
        material.diffuse.contents = [UIImage imageNamed:textureName];
        material.diffuse.intensity = kIntensity;
    }
}

@end
