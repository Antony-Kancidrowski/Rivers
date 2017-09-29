//
//  blueCellsShader.frag
//  Rivers
//
//  Created by Antony Kancidrowski on 29/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#ifdef GL_ES
precision mediump float;
#endif

// Interpolated normal and positions
varying vec4 viewSpaceNormal;
varying vec4 viewSpacePosition;

varying float vopacity;
varying float vintensity;

varying float vresX;
varying float vresY;

varying float vtime;


float length2(vec2 p) { return dot(p, p); }

float noise(vec2 p){
    return fract(sin(fract(sin(p.x) * (43.13311)) + p.y) * 31.0011);
}

float worley(vec2 p) {
    float d = 1e30;
    for (int xo = -1; xo <= 1; ++xo) {
        for (int yo = -1; yo <= 1; ++yo) {
            vec2 tp = floor(p) + vec2(xo, yo);
            d = min(d, length2(p - tp - vec2(noise(tp))));
        }
    }
    return 3.0*exp(-4.0*abs(2.0*d - 1.0));
}

float fworley(vec2 p) {
    return 1.1 * sqrt(worley(p * 50. + 0.3 + vtime * -0.15));
}

void main(void)
{
    vec2 resolution = vec2(vresX, vresY);

    vec2 uv = gl_FragCoord.xy / resolution.xy;
    float t = fworley(uv * resolution.xy / 1500.0);
    t *= exp(-length2(abs(0.7 * uv - 1.0)));
    gl_FragColor = vec4(t * vec3(0.1, 1.1*t, 1.2*t + pow(t, 0.5-t)), 1.0);
}
