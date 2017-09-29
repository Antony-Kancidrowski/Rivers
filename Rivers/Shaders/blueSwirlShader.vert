//
//  blueSwirlShader.vert
//  Rivers
//
//  Created by Antony Kancidrowski on 24/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#ifdef GL_ES
precision mediump float;
#endif

uniform mat4 modelViewProjection;

// input
attribute vec4 position;

uniform float opacity;
uniform float intensity;

uniform vec2 resolution;

uniform float time;

// output
varying float vopacity;
varying float vintensity;

varying vec2 vresolution;

varying float vtime;

void main(void)
{
    vopacity = opacity;
    vintensity = intensity;
    
    vresolution = resolution;
    vtime = time;
    
    gl_Position = modelViewProjection * position;
}
