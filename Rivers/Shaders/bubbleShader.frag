//
//  bubbleShader.frag
//  Rivers
//
//  Created by Antony Kancidrowski on 28/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#ifdef GL_ES
precision highp float;
#endif

varying float vopacity;
varying float vintensity;

varying float vresX;
varying float vresY;

varying float vtime;

const float fRadius = 0.1;

void main(void)
{
    vec2 resolution = vec2(vresX, vresY);

//    vec2 uv = gl_FragCoord.xy / resolution;
//    uv.x *=  resolution.x / resolution.y;
    
    vec2 uv = (gl_FragCoord.xy - resolution.xy) / max(resolution.x, resolution.y);
    uv.x += 0.5;
    
    vec3 color = vec3(0.0);
    
    // bubbles
    for( int i=0; i<64; i++ )
    {
        float floati = float(i);
        
        // bubble seeds
        float pha = tan(floati*6.+1.0)*0.5 + 0.5;
        float siz = pow( cos(floati*2.4+5.0)*0.5 + 0.5, 4.0 );
        float pox = cos(floati*3.55+4.1) * resolution.x / resolution.y;
        
        // buble size, position and color
        float rad = fRadius + sin(floati)*0.12+0.08;
        vec2  pos = vec2( pox+sin(vtime/10.+pha+siz), -1.0-rad + (2.0+2.0*rad)
                         *mod(pha+0.1*(vtime/2.)*(0.2+0.8*siz),1.0)) * vec2(1.0, 1.0);
        float dis = length( uv - pos );
        vec3  col = mix( vec3(0.7, 0.2, 0.8), vec3(0.2,0.8,0.6), 0.5+0.5*sin(floati*sin(vtime*pox*0.03)+1.9));
        
        // render
        color += col.xyz *(1.- smoothstep( rad*(0.65+0.20*sin(pox*vtime)), rad, dis )) * (1.0 - cos(pox*vtime));
    }
    
    gl_FragColor = vec4(color, 1.0);
}
