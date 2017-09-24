//
//  GLSLNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 22/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "GLSLNode.h"

#import "Configuration.h"
#import "DebugOptions.h"

#import "CameraNode.h"

@interface GLSLNode () <SCNProgramDelegate>
{
    NSTimeInterval shaderTime;
}

@property (strong, nonatomic) GLKTextureInfo *texture;
@property (strong, nonatomic) NSString *shaderName;

@end


@implementation GLSLNode

+ (GLSLNode *)glslNodeWithShaderName:(NSString *)shaderName {
    
    GLSLNode *newGLSLNode = [[GLSLNode alloc] initWithShaderName:shaderName];
    
    return newGLSLNode;
}

- (instancetype)initWithShaderName:(NSString *)shaderName {
    
    self = [super init];
    
    if (self != nil)
    {
        self.texture = nil;
        
        self.shaderName = shaderName;
        
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
    plane.widthSegmentCount = 1;
    plane.heightSegmentCount = 1;
    
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
    
    // Bind a bool to switch between using a texture (see below) and a solid color (see above)
    [plane.firstMaterial handleBindingOfSymbol:@"time"
                                        usingBlock:^(unsigned int programID,
                                                     unsigned int location,
                                                     SCNNode *renderedNode,
                                                     SCNRenderer *renderer)
     {
         CAAnimation *animation = [self animationForKey:@"glsl"];
         glUniform1f(location, shaderTime+=(0.01 * animation.speed));
     }];
    
    // Make the flag use the custom shaders
    plane.firstMaterial.program = program;
}

#pragma mark - ActorActivation

- (void)activate {
    
    [super activate];
    
    // Need to animate to show the fluttering...we'll use opacity with no change to accomplish this
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = NULL;
    opacity.toValue = NULL;
    opacity.duration = 1;
    opacity.repeatCount = INFINITY;
    opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self addAnimation:opacity forKey:@"glsl"];
}

- (void)deactivate {
    
    [self removeAnimationForKey:@"glsl"];
    
    [super deactivate];
}

@end
