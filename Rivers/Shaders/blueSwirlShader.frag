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

varying float vopacity;
varying float vintensity;

varying vec2 vresolution;

varying float vtime;

const int MAX_ITER = 3;

void main(void)
{
    vec2 v_texCoord = gl_FragCoord.xy / vresolution;
    
    vec2 p =  v_texCoord * 4.0 - vec2(20.0);
    vec2 i = p;
    float c = 2.0;
    float inten = 0.05; //20.0;
    
    for (int n = 1; n < MAX_ITER; ++n)
    {
        float t = vtime * (0.5 - (0.050 / float(n)));
        
        float cixpt = cos(i.x + t);
        float siypt = sin(i.y + t);
        
        float ctmix = cos(t - i.x);
        float stmiy = sin(t - i.y);

        i = p + vec2(ctmix + siypt,
                     stmiy + cixpt);
        
        c += 1.0 / length(vec2(p.x / (cixpt / inten),
                               p.y / (siypt / inten)));
    }
    
    c /= float(MAX_ITER);
    c = 1.55 - sqrt(c);
    
    vec3 color = vec3(0.02, 0.15, 0.33);
    
    color.rgb *= (1.0 / (1.0 - c));

    gl_FragColor = vec4(color * vintensity, vopacity);
}
