//
//  cloudsShader.vert
//  Rivers
//
//  Created by Antony Kancidrowski on 29/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#ifdef GL_ES
precision mediump float;
#endif

uniform mat4 modelViewProjection;
uniform mat4 normalTransform;
uniform mat4 modelView;

// input
attribute vec4 position;
attribute vec4 normal;

uniform float opacity;
uniform float intensity;

uniform vec2 resolution;

uniform float time;

// output
varying vec4 viewSpaceNormal;
varying vec4 viewSpacePosition;

varying float vopacity;
varying float vintensity;

varying vec2 vresolution;

varying float vtime;

void main(void)
{
    viewSpaceNormal   = normalTransform * normal;
    viewSpacePosition = modelView       * position;
    
    vopacity = opacity;
    vintensity = intensity;
    
    vresolution = resolution;
    vtime = time;
    
    gl_Position = modelViewProjection * position;
}
