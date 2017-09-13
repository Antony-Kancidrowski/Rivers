//
//  GridMenuScrollView.h
//  Rivers
//
//  Created by Antony Kancidrowski on 26/02/2016.
//  Copyright © 2016 Antony Kancidrowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GridMenuScrollViewDelegate <NSObject>
@required
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface GridMenuScrollView : UIScrollView

@property (nonatomic, weak) id<GridMenuScrollViewDelegate> gridMenuScrollViewDelegate;

@end
