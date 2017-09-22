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
@property (strong, nonatomic) CameraNode *cameraNode;
@property (strong, nonatomic) NSString *shaderName;

@end


@implementation GLSLNode

+ (GLSLNode *)glslNodeWithName:(NSString *)shaderName andCameraNode:(CameraNode *)cameraNode {
    
    GLSLNode *newGLSLNode = [[GLSLNode alloc] initWithName:shaderName andCameraNode:cameraNode];
    
    return newGLSLNode;
}

- (instancetype)initWithName:(NSString *)shaderName andCameraNode:(CameraNode *)cameraNode {
    
    self = [super init];
    
    if (self != nil)
    {
        self.texture = nil;
        self.cameraNode = cameraNode;
        
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
    
    SCNPlane *flagPlane = [SCNPlane planeWithWidth:3.0f height:2.25f];
    flagPlane.widthSegmentCount = 100;
    flagPlane.heightSegmentCount = 75;
    
    [self setGeometry:flagPlane];
    
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
    
    
    
    // Bind additional uniforms to the shader code
    // -------------------------------------------
    
    // Bind the ambient color with a custom light
    [flagPlane.firstMaterial handleBindingOfSymbol:@"ambientColor"
                                        usingBlock:^(unsigned int programID,
                                                     unsigned int location,
                                                     SCNNode *renderedNode,
                                                     SCNRenderer *renderer)
     {
         // the 3f suffix stands for "3 floats"
         glUniform3f(location, 0.100, 0.100, 0.100);
     }];
    
    // Bind the shininess light
    [flagPlane.firstMaterial handleBindingOfSymbol:@"shininess"
                                        usingBlock:^(unsigned int programID,
                                                     unsigned int location,
                                                     SCNNode *renderedNode,
                                                     SCNRenderer *renderer)
     {
         glUniform1f(location, 25.0);
     }];
    
    // Bind the light direction of the custom light
    [flagPlane.firstMaterial handleBindingOfSymbol:@"lightDirection"
                                        usingBlock:^(unsigned int programID,
                                                     unsigned int location,
                                                     SCNNode *renderedNode,
                                                     SCNRenderer *renderer)
     {
         CGFloat x = self.cameraNode.mainCameraNode.position.x;
         CGFloat y = self.cameraNode.mainCameraNode.position.y;
         CGFloat z = self.cameraNode.mainCameraNode.position.z;
         
         // the 3f suffix stands for "3 floats"
         glUniform3f(location, x, y, z);
     }];
    
    // Bind a bool to switch between using a texture (see below) and a solid color (see above)
    [flagPlane.firstMaterial handleBindingOfSymbol:@"time"
                                        usingBlock:^(unsigned int programID,
                                                     unsigned int location,
                                                     SCNNode *renderedNode,
                                                     SCNRenderer *renderer)
     {
         CAAnimation *animation = [self animationForKey:@"flag"];
         glUniform1f(location, shaderTime+=(0.01 * animation.speed));
     }];
    
    // Bind the texture sampler (using GLKit to load the texture)
    [flagPlane.firstMaterial handleBindingOfSymbol:@"flagTexture"
                                        usingBlock:^(unsigned int programID,
                                                     unsigned int location,
                                                     SCNNode *renderedNode,
                                                     SCNRenderer *renderer)
     {
         
         if (!self.texture) {
             
             NSError *textureLoadingError = nil;
             //NSString *textureName = [NSString stringWithFormat:@"%@_F", [self.flag name]];
             NSString *textureName = @"";
             
             UIImage *image = [UIImage imageNamed:textureName];
             
             NSData *data = UIImagePNGRepresentation(image);
             GLKTextureInfo *texture = [GLKTextureLoader textureWithContentsOfData:data options:nil error:&textureLoadingError];
             
             if(!texture) {
                 // Handle the error
             }
             self.texture = texture;
         }
         
         glBindTexture(GL_TEXTURE_2D, self.texture.name);
     }];
    
    
    // Make the flag use the custom shaders
    flagPlane.firstMaterial.program = program;
    
    flagPlane.firstMaterial.doubleSided = YES;
}

#pragma mark - ActorActivation

- (void)activate {
    
    [super activate];
    
    // Need to animate to show the fluttering...we'll use opacity with no change to accomplish this
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = NULL;
    opacity.toValue = NULL;
    opacity.duration = 10;
    opacity.repeatCount = INFINITY;
    opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self addAnimation:opacity forKey:@"glsl"];
}

- (void)deactivate {
    
    [self removeAnimationForKey:@"glsl"];
    
    [super deactivate];
}

@end
