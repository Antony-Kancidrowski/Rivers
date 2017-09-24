//
//  blueSwirlShader.frag
//  Rivers
//
//  Created by Antony Kancidrowski on 24/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#ifdef GL_ES
precision highp float;
#endif

// Interpolated normal and positions
varying vec4 viewSpaceNormal;
varying vec4 viewSpacePosition;

varying float vtime;

#define MAX_ITER 3

void main(void)
{
    vec2 resolution = vec2(400.0, 300.0);
    
    vec2 v_texCoord = gl_FragCoord.xy / resolution;
    
    vec2 p =  v_texCoord * 4.0 - vec2(20.0);
    vec2 i = p;
    float c = 2.0;
    float inten = .05;
    
    for (int n = 0; n < MAX_ITER; n++)
    {
        float t = vtime * (0.5 - (0.050 / float(n+1)));
        
        i = p + vec2(cos(t - i.x) + sin(t + i.y),
                     sin(t - i.y) + cos(t + i.x));
        
        c += 1.0/length(vec2(p.x / (sin(i.x+t)/inten),
                             p.y / (cos(i.y+t)/inten)));
    }
    
    c /= float(MAX_ITER);
    c = 1.5 - sqrt(c);
    
    vec3 color = vec3(0.02, 0.15, 0.33);
    
    color.rgb *= (1.0 / (1.0 - (c + 0.05)));

    // The color of the fragment is the sum of the ambient color, diffuse color and specular color
    gl_FragColor = vec4( color,
                        1.0); // color is opaque
}
