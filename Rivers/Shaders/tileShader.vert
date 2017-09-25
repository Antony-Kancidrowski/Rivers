//
//  tileShader.vert
//  Rivers
//
//  Created by Antony Kancidrowski on 24/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#ifdef GL_ES
precision highp float;
#endif

uniform mat4 modelViewProjection;
uniform mat4 normalTransform;
uniform mat4 modelView;

// input
attribute vec4 position;
attribute vec4 normal;

uniform float opacity;
uniform float intensity;

uniform float resX;
uniform float resY;

uniform float time;

// output
varying vec4 viewSpaceNormal;
varying vec4 viewSpacePosition;

varying float vopacity;
varying float vintensity;

varying float vresX;
varying float vresY;

varying float vtime;

void main(void)
{
    viewSpaceNormal   = normalTransform * normal;
    viewSpacePosition = modelView       * position;
    
    vopacity = opacity;
    vintensity = intensity;
    
    vresX = resX;
    vresY = resY;
    vtime = time;
    
    gl_Position = modelViewProjection * position;
}
