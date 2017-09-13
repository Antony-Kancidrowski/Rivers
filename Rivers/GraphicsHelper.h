//
//  GraphicsHelper.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifndef Rivers_GraphicsHelper_h
#define Rivers_GraphicsHelper_h

static inline CGPoint CentroidOfTouchesInView(NSSet *touches, UIView *view) {
    CGFloat sumX = 0.f;
    CGFloat sumY = 0.f;
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:view];
        sumX += location.x;
        sumY += location.y;
    }
    
    return CGPointMake((CGFloat)round(sumX / touches.count), (CGFloat)round(sumY / touches.count));
}

#endif /* Rivers_GraphicsHelper_h */
