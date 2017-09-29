//
//  tunnelShader.frag
//  Rivers
//
//  Created by Antony Kancidrowski on 24/09/2017.
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

varying vec2 vresolution;

varying float vtime;

vec3 checkerBoard( vec2 uv, vec2 pp )
{
    vec2 p = floor( uv * 4.6 );
    float t = mod( p.x + p.y, 2.0);
    vec3 c = vec3(t+pp.x, t+pp.y, t+(pp.x*pp.y));
    
    return c;
}

vec3 tunnel( vec2 p, float scrollPos, float rotateSpeed )
{
    float a = 0.9 * atan( p.x, p.y  );
    float po = 2.0;
    float px = pow( p.x*p.x, po );
    float py = pow( p.y*p.y, po );
    float r = pow( px + py, 0.5/po );
    vec2 uvp = vec2( 0.5/r + scrollPos, a + (vtime*rotateSpeed));
    vec3 finalColor = checkerBoard( uvp, p ).xyz;
    finalColor *= r;
    
    return finalColor;
}

void main(void)
{
    vec2 uv = gl_FragCoord.xy / vresolution.xy;

    vec2 p = uv - vec2(1.0 - 0.25*cos(vtime), 1.0 - 0.25*sin(2.0*vtime));

    vec3 color = tunnel(p, vtime * 1.0, 0.5);

    gl_FragColor = vec4(color * vintensity, vopacity);
}
