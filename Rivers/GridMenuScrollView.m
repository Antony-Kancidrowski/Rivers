//
//  GridMenuScrollView.m
//  Rivers
//
//  Created by Antony Kancidrowski on 26/02/2016.
//  Copyright © 2016 Antony Kancidrowski. All rights reserved.
//

#import "GridMenuScrollView.h"

@implementation GridMenuScrollView

@synthesize gridMenuScrollViewDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent: (UIEvent *)event {

    [gridMenuScrollViewDelegate touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [gridMenuScrollViewDelegate touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [gridMenuScrollViewDelegate touchesEnded:touches withEvent:event];
}

@end
