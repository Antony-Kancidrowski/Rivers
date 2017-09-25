//
//  blueSwirlShader.vert
//  Rivers
//
//  Created by Antony Kancidrowski on 24/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#ifdef GL_ES
precision highp float;
#endif

uniform mat4 modelViewProjection;

// input
attribute vec4 position;

uniform float intensity;

uniform float resX;
uniform float resY;

uniform float time;

// output
varying float vintensity;

varying float vresX;
varying float vresY;

varying float vtime;

void main(void)
{
    vintensity = intensity;
    
    vresX = resX;
    vresY = resY;
    vtime = time;
    
    gl_Position = modelViewProjection * position;
}
