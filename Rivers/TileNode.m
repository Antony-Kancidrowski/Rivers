//
//  TileNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 25/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "TileNode.h"

#import "AppSpecificValues.h"

#import "SoundManager.h"

#import "Configuration.h"
#import "DebugOptions.h"

#import "ThemeManager.h"
#import "Theme.h"

@interface TileNode ()
{
    
}

@property (nonatomic, assign) NodeType nodeType;

@property (nonatomic, assign) SCNVector3 tileSize;

@end

@implementation TileNode

@synthesize tagName;
@synthesize respondToThemeNotification;

- (instancetype)initWithTheme:(Theme *)theme andTagName:(NSString *)name andSize:(SCNVector3)size andScale:(SCNVector3)scale {
    
    self = [super init];
    
    if (self != nil)
    {
        SCNVector3 vertices[] = {
            // Front
            SCNVector3Make(  size.x, -size.y,  size.z),
            SCNVector3Make(  size.x,  size.y,  size.z),
            SCNVector3Make( -size.x,  size.y,  size.z),
            SCNVector3Make( -size.x, -size.y,  size.z),
            
            // Back
            SCNVector3Make(  size.x,  size.y, -size.z),
            SCNVector3Make( -size.x, -size.y, -size.z),
            SCNVector3Make(  size.x, -size.y, -size.z),
            SCNVector3Make( -size.x,  size.y, -size.z),
            
            // Left
            SCNVector3Make( -size.x, -size.y,  size.z),
            SCNVector3Make( -size.x,  size.y,  size.z),
            SCNVector3Make( -size.x,  size.y, -size.z),
            SCNVector3Make( -size.x, -size.y, -size.z),
            
            // Right
            SCNVector3Make(  size.x, -size.y, -size.z),
            SCNVector3Make(  size.x,  size.y, -size.z),
            SCNVector3Make(  size.x,  size.y,  size.z),
            SCNVector3Make(  size.x, -size.y,  size.z),
            
            // Top
            SCNVector3Make(  size.x,  size.y,  size.z),
            SCNVector3Make(  size.x,  size.y, -size.z),
            SCNVector3Make( -size.x,  size.y, -size.z),
            SCNVector3Make( -size.x,  size.y,  size.z),
            
            // Bottom
            SCNVector3Make(  size.x, -size.y, -size.z),
            SCNVector3Make(  size.x, -size.y,  size.z),
            SCNVector3Make( -size.x, -size.y,  size.z),
            SCNVector3Make( -size.x, -size.y, -size.z)
        };
        
        SCNVector3 normals[] = {
            // Front
            SCNVector3Make(  0.0f,  0.0f,  1.0f),
            SCNVector3Make(  0.0f,  0.0f,  1.0f),
            SCNVector3Make(  0.0f,  0.0f,  1.0f),
            SCNVector3Make(  0.0f,  0.0f,  1.0f),
            
            // Back
            SCNVector3Make(  0.0f,  0.0f, -1.0f),
            SCNVector3Make(  0.0f,  0.0f, -1.0f),
            SCNVector3Make(  0.0f,  0.0f, -1.0f),
            SCNVector3Make(  0.0f,  0.0f, -1.0f),
            
            // Left
            SCNVector3Make(  0.0f, -1.0f,  0.0f),
            SCNVector3Make(  0.0f, -1.0f,  0.0f),
            SCNVector3Make(  0.0f, -1.0f,  0.0f),
            SCNVector3Make(  0.0f, -1.0f,  0.0f),
            
            // Right
            SCNVector3Make(  0.0f,  1.0f,  0.0f),
            SCNVector3Make(  0.0f,  1.0f,  0.0f),
            SCNVector3Make(  0.0f,  1.0f,  0.0f),
            SCNVector3Make(  0.0f,  1.0f,  0.0f),
            
            // Top
            SCNVector3Make( -1.0f,  0.0f,  0.0f),
            SCNVector3Make( -1.0f,  0.0f,  0.0f),
            SCNVector3Make( -1.0f,  0.0f,  0.0f),
            SCNVector3Make( -1.0f,  0.0f,  0.0f),
            
            // Bottom
            SCNVector3Make(  1.0f,  0.0f,  0.0f),
            SCNVector3Make(  1.0f,  0.0f,  0.0f),
            SCNVector3Make(  1.0f,  0.0f,  0.0f),
            SCNVector3Make(  1.0f,  0.0f,  0.0f)
        };
        
        float textureCoordinates[] = {
            // Front
            0.50f, 0.00f,
            0.50f, 0.50f,
            0.00f, 0.50f,
            0.00f, 0.00f,
            
            // Back
            1.00f, 0.00f,
            0.50f, 0.50f,
            1.00f, 0.50f,
            0.50f, 0.00f,
            
            // Left
            0.25f, 0.50f,
            0.25f, 1.00f,
            0.00f, 1.00f,
            0.00f, 0.50f,
            
            // Right
            0.50f, 0.50f,
            0.50f, 1.00f,
            0.25f, 1.00f,
            0.25f, 0.50f,
            
            // Top
            1.00f, 0.75f,
            1.00f, 1.00f,
            0.50f, 1.00f,
            0.50f, 0.75f,
            
            // Bottom
            1.00f, 0.50f,
            1.00f, 0.75f,
            0.50f, 0.75f,
            0.50f, 0.50f
        };
        
        NSUInteger vertexCount = 24;
        
        
        NSMutableData *indicesData = [NSMutableData data];
        
        UInt8 indices[] =
        {
            // Front
            0, 1, 2,
            2, 3, 0,
            
            // Back
            4, 6, 5,
            4, 5, 7,
            
            // Left
            8, 9, 10,
            10, 11, 8,
            
            // Right
            12, 13, 14,
            14, 15, 12,
            
            // Top
            16, 17, 18,
            18, 19, 16,
            
            // Bottom
            20, 21, 22,
            22, 23, 20
        };
        
        [indicesData appendBytes:indices length:sizeof(UInt8)*36];
        SCNGeometryElement *indicesElement = [SCNGeometryElement geometryElementWithData:indicesData
                                                                           primitiveType:SCNGeometryPrimitiveTypeTriangles
                                                                          primitiveCount:12
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
        
        self.tagName = name;
        self.respondToThemeNotification = YES;
        
        NSString *key = @"tileKey";
        
        NSString *textureName = [NSString stringWithFormat:@"%@.png", [theme.theme valueForKey:key]];
        NSString *normalName = [NSString stringWithFormat:@"%@-normal.png", [theme.theme valueForKey:key]];
        
        SCNMaterial *material = [SCNMaterial material];
        material.diffuse.contents = [UIImage imageNamed:textureName];
        material.diffuse.wrapS = SCNWrapModeRepeat;
        material.diffuse.wrapT = SCNWrapModeRepeat;
        material.diffuse.intensity = 0.35f;
        material.diffuse.contentsTransform = SCNMatrix4MakeScale( 1.0f, 1.0f, 1.0f);
        material.doubleSided = NO;
        
        NSString *tagName = [NSString stringWithFormat:@"tile-%@.png", name];
        
        material.multiply.contents = [UIImage imageNamed:tagName];
        material.multiply.wrapS = SCNWrapModeRepeat;
        material.multiply.wrapT = SCNWrapModeRepeat;
    
        material.specular.contents = [UIImage imageNamed:textureName];
        material.specular.wrapS = SCNWrapModeRepeat;
        material.specular.wrapT = SCNWrapModeRepeat;
        material.specular.intensity = 0.25f;
        
        material.normal.contents = [UIImage imageNamed:normalName];
        material.normal.wrapS = SCNWrapModeRepeat;
        material.normal.wrapT = SCNWrapModeRepeat;
        material.normal.intensity = 0.5f;
        
        material.litPerPixel = YES;
        
        material.lightingModelName = SCNLightingModelBlinn;
        
        geometry.materials = @[material];
        
        [self setGeometry:geometry];
        
        [self setTileSize:size];
    }
    
    return self;
}

- (void)activate {
       
    NSNumber *show = [DebugOptions optionForKey:@"ShowTiles"];
    
    [self setHidden:!show.boolValue];
    
    [super activate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveThemeChangeNotification:)
                                                 name:kThemeChangedNotification
                                               object:NULL];
}

- (void)deactivate {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super deactivate];
}

- (void)receiveThemeChangeNotification:(NSNotification *)notification {
    
    if ((self.respondToThemeNotification) && ([[notification name] isEqualToString:kThemeChangedNotification])) {
        
        ThemeManager *themeManager = [ThemeManager sharedThemeManager];
        Theme *theme = [themeManager getCurrentTheme];
        
        NSString *key = @"tileKey";
        
        NSString *textureName = [NSString stringWithFormat:@"%@.png", [theme.theme valueForKey:key]];
        NSString *normalName = [NSString stringWithFormat:@"%@-normal.png", [theme.theme valueForKey:key]];
        
        SCNMaterial *material = self.geometry.firstMaterial;
        
        material.diffuse.contents = [UIImage imageNamed:textureName];
        material.normal.contents = [UIImage imageNamed:normalName];
    }
}

@end
