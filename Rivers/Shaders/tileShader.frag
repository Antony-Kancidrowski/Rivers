//
//  tileShader.frag
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

varying float vopacity;
varying float vintensity;

varying vec2 vresolution;

varying float vtime;

#define PITCH 3.
#define POWER 130.

vec3 rotX(vec3 p,float a){return vec3(p.x,p.y*cos(a)-p.z*sin(a),p.y*sin(a)+p.z*cos(a));}
vec3 rotY(vec3 p,float a){return vec3(p.x*cos(a)-p.z*sin(a),p.y,p.x*sin(a)+p.z*cos(a));}
vec3 rotZ(vec3 p,float a){return vec3(p.x*cos(a)-p.y*sin(a), p.x*sin(a)+p.y*cos(a), p.z);}
float line(vec2 p,vec2 l){return pow(1.-length(p-l),POWER);}
float map(vec2 p){float c=line(p,vec2(p.x,floor(p.y*PITCH+.5)/PITCH))+line(p,vec2(floor(p.x*PITCH+.5)/PITCH,p.y))-1e-10;return clamp(c,0.,1.);}

void main(void){

    float t = vtime * .6;
    
    vec2 p=(gl_FragCoord.xy*2.-vresolution.xy)/min(vresolution.x, vresolution.y);
    vec3 l=vec3(p.x-1.+sin(t*2.15),p.y-2.-cos(t*2.75),2.5);    //light pos
    vec3 ln=normalize(l);
    
    float si = sin(t), co = cos(t*1.15);
    mat2 m = mat2(co, -si, si, co);
    p *= m;
    p.x += vtime * .7;
    
    vec3 color = vec3(.5, .4, .1);
    
    float v = map(p);
    
    if(v>.3){
        color = vec3(.1,.1,.1);
    }else{
        float dx = map(p+vec2(0.01,0.)), dy = map(p+vec2(0.,0.01));
        vec3 n = rotZ(normalize(vec3(v-dx, v-dy,.2)), -t);
        v = pow(clamp(dot(ln,n),0.,1.),8.);
        
        color+=v;
    }
    
    gl_FragColor = vec4(color * vintensity, vopacity);
}


