//
//  GLSLBackgroundNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 22/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "GLSLBackgroundNode.h"

#import "Configuration.h"
#import "DebugOptions.h"

#import "CameraNode.h"

@interface GLSLBackgroundNode () <SCNProgramDelegate>
{
    NSTimeInterval shaderTime;
    
    CGFloat intensity;
    CGSize resolution;
}

@property (strong, nonatomic) GLKTextureInfo *texture;
@property (strong, nonatomic) NSString *shaderName;

@end


@implementation GLSLBackgroundNode

+ (GLSLBackgroundNode *)backgroundNodeWithShaderName:(NSString *)shaderName andResolution:(CGSize)size {
    
    GLSLBackgroundNode *newBackground = [[GLSLBackgroundNode alloc] initWithShaderName:shaderName andResolution:size];
    
    return newBackground;
}

- (instancetype)initWithShaderName:(NSString *)shaderName andResolution:(CGSize)size {
    
    self = [super init];
    
    if (self != nil)
    {
        self.texture = nil;
        
        self.shaderName = shaderName;
        
        resolution = size;
        shaderTime = 355.0f / 113.0f;
    }
    
    return self;
}

- (void)setup:(SCNNode*)parentNode {
    
    [self createMesh];
    
    [super setup:parentNode];
}

- (void)createMesh {
    
    SCNPlane *plane = [SCNPlane planeWithWidth:5.0f height:8.0f];
    plane.widthSegmentCount = 10;
    plane.heightSegmentCount = 10;
    
    [self setGeometry:plane];
    
    // Read the shaders source from the two files.
    NSURL *vertexShaderURL   = [[NSBundle mainBundle] URLForResource:_shaderName withExtension:@"vert"];
    NSURL *fragmentShaderURL = [[NSBundle mainBundle] URLForResource:_shaderName withExtension:@"frag"];
    NSString *vertexShader   = [[NSString alloc] initWithContentsOfURL:vertexShaderURL
                                                              encoding:NSUTF8StringEncoding
                                                                 error:NULL];
    NSString *fragmentShader = [[NSString alloc] initWithContentsOfURL:fragmentShaderURL
                                                              encoding:NSUTF8StringEncoding
                                                                 error:NULL];
    
    // Create a shader program and assign the shaders
    SCNProgram *program = [SCNProgram program];
    program.vertexShader   = vertexShader;
    program.fragmentShader = fragmentShader;
    
    // Become the program delegate (to get runtime compilation errors)
    program.delegate = self;
    
    
    // Associate geometry and node data with the attributes and uniforms
    // -----------------------------------------------------------------
    
    // Attributes (position, normal, texture coordinate)
    [program setSemantic:SCNGeometrySourceSemanticVertex
               forSymbol:@"position"
                 options:nil];
    [program setSemantic:SCNGeometrySourceSemanticNormal
               forSymbol:@"normal"
                 options:nil];
    [program setSemantic:SCNGeometrySourceSemanticTexcoord
               forSymbol:@"textureCoordinate"
                 options:nil];
    
    // Uniforms (the three different transformation matrices)
    [program setSemantic:SCNModelViewProjectionTransform
               forSymbol:@"modelViewProjection"
                 options:nil];
    [program setSemantic:SCNModelViewTransform
               forSymbol:@"modelView"
                 options:nil];
    [program setSemantic:SCNNormalTransform
               forSymbol:@"normalTransform"
                 options:nil];
    
    [plane.firstMaterial handleBindingOfSymbol:@"resX"
                                       usingBlock:^(unsigned int programID,
                                                    unsigned int location,
                                                    SCNNode *renderedNode,
                                                    SCNRenderer *renderer)
     {
         glUniform1f(location, resolution.width);
     }];
    
    [plane.firstMaterial handleBindingOfSymbol:@"resY"
                                       usingBlock:^(unsigned int programID,
                                                    unsigned int location,
                                                    SCNNode *renderedNode,
                                                    SCNRenderer *renderer)
     {
         glUniform1f(location, resolution.height);
     }];
    
    [plane.firstMaterial handleBindingOfSymbol:@"intensity"
                                    usingBlock:^(unsigned int programID,
                                                 unsigned int location,
                                                 SCNNode *renderedNode,
                                                 SCNRenderer *renderer)
     {
         glUniform1f(location, intensity * self.opacity);
     }];
    
    [plane.firstMaterial handleBindingOfSymbol:@"opacity"
                                    usingBlock:^(unsigned int programID,
                                                 unsigned int location,
                                                 SCNNode *renderedNode,
                                                 SCNRenderer *renderer)
     {
         glUniform1f(location, self.opacity);
     }];
    
    // Bind a bool to switch between using a texture (see below) and a solid color (see above)
    [plane.firstMaterial handleBindingOfSymbol:@"time"
                                        usingBlock:^(unsigned int programID,
                                                     unsigned int location,
                                                     SCNNode *renderedNode,
                                                     SCNRenderer *renderer)
     {
         shaderTime += (1.0 / kPreferredFrameRate);
         
         glUniform1f(location, shaderTime);
     }];
    
    // Make the plane use the custom shaders
    plane.firstMaterial.program = program;
}

- (void)animate {
    
    SCNAction *custom = [SCNAction customActionWithDuration:2 * M_PI actionBlock:^(SCNNode* node, CGFloat elapsedtime) {
        
        intensity = 0.6f + (0.2f * cosf(elapsedtime) * sinf(elapsedtime * 4.0f));
    }];
    
    
    [self runAction:[SCNAction repeatActionForever:custom]];
}

@end
