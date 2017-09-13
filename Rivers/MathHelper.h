//
//  MathHelper.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef Rivers_MathHelper_h
#define Rivers_MathHelper_h

static inline GLKVector3 GLKVector3MatrixMultiply(GLKVector3 p, GLKMatrix4 m)
{
    CGFloat x = (p.x*m.m[0]) + (p.y*m.m[4]) + (p.z*m.m[8]) + m.m[12];
    CGFloat y = (p.x*m.m[1]) + (p.y*m.m[5]) + (p.z*m.m[9]) + m.m[13];
    CGFloat z = (p.x*m.m[2]) + (p.y*m.m[6]) + (p.z*m.m[10]) + m.m[14];
    
    return (GLKVector3) {x, y, z};
}

static inline SCNVector3 SCNVector3MatrixMultiply(SCNVector3 p, SCNMatrix4 m)
{
    CGFloat x = (p.x*m.m11) + (p.y*m.m21) + (p.z*m.m31) + m.m41;
    CGFloat y = (p.x*m.m12) + (p.y*m.m22) + (p.z*m.m32) + m.m42;
    CGFloat z = (p.x*m.m13) + (p.y*m.m23) + (p.z*m.m33) + m.m43;
    
    return (SCNVector3) {x, y, z};
}

static inline SCNVector3 SCNVector3SCNVector3Multiply(SCNVector3 p, SCNVector3 q)
{
    CGFloat x = (p.x * q.x);
    CGFloat y = (p.y * q.y);
    CGFloat z = (p.z * q.z);
    
    return (SCNVector3) {x, y, z};
}

static inline float RoundTof(float value, float roundingValue) {
    short sign = value < 0 ? -1 : 1;
    
    int rounddown = floorf(fabs(value) / roundingValue);
    int roundup = floorf((fabs(value) + roundingValue) / roundingValue);
    
    float newvaluedown = rounddown * roundingValue * sign;
    float newvalueup = roundup * roundingValue * sign;
    
    if (fabs(newvalueup - value) < fabs(newvaluedown - value))
        return newvalueup;
    else
        return newvaluedown;
}

#endif /* Rivers_MathHelper_h */
