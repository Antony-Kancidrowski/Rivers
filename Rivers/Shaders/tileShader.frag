//  Copyright (c) 2014 David Rönnqvist.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in the
// Software without restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#ifdef GL_ES
precision mediump float;
#endif

// Interpolated normal and positions
varying vec4 viewSpaceNormal;
varying vec4 viewSpacePosition;

varying float vtime;

#define PITCH 3.
#define POWER 130.

vec3 rotX(vec3 p,float a){return vec3(p.x,p.y*cos(a)-p.z*sin(a),p.y*sin(a)+p.z*cos(a));}
vec3 rotY(vec3 p,float a){return vec3(p.x*cos(a)-p.z*sin(a),p.y,p.x*sin(a)+p.z*cos(a));}
vec3 rotZ(vec3 p,float a){return vec3(p.x*cos(a)-p.y*sin(a), p.x*sin(a)+p.y*cos(a), p.z);}
float line(vec2 p,vec2 l){return pow(1.-length(p-l),POWER);}
float map(vec2 p){float c=line(p,vec2(p.x,floor(p.y*PITCH+.5)/PITCH))+line(p,vec2(floor(p.x*PITCH+.5)/PITCH,p.y))-1e-10;return clamp(c,0.,1.);}

void main(void){
    vec2 resolution = vec2(400.0, 300.0);
    
    vec2 p=(gl_FragCoord.xy*2.-resolution.xy)/min(resolution.x,resolution.y);
    vec3 l=vec3(p.x+1.,p.y-2.,2.5);    //light pos
    vec3 ln=normalize(l);
    float t=vtime*.3;
    float si=sin(t),co=cos(t*1.15);
    mat2 m=mat2(co,-si,si,co);
    p*=m;
    p.x+=vtime*.7;
    
    vec3 col=vec3(.5,.4,.1);
    
    float v=map(p);
    if(v>.3){
        col=vec3(.1,.1,.1);
    }else{
        float dx=map(p+vec2(0.01,0.)),dy=map(p+vec2(0.,0.01));
        vec3 n=rotZ(normalize(vec3(v-dx,v-dy,.2)),-t);
        v=pow(clamp(dot(ln,n),0.,1.),8.);
        col+=v;
    }
    
    gl_FragColor = vec4(col,1);
}


