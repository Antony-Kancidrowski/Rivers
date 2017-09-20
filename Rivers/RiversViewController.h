//
//  RiversViewController.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "GridMenuViewController.h"

#import "CameraNode.h"
#import "BackgroundNode.h"

@interface RiversViewController : UIViewController <GridMenuDelegate, UIGestureRecognizerDelegate, SCNSceneRendererDelegate>

@property (strong, nonatomic) SCNScene *scene;

@property (strong, nonatomic) CameraNode *camera;
@property (strong, nonatomic) BackgroundNode *background;

@property (assign, nonatomic) CGFloat aspectRatio;

@property (assign, nonatomic) NSUInteger frameCount;

@property (assign, nonatomic) BOOL disableGestures;
@property (assign, nonatomic) BOOL allowCameraControl;

@property (assign, nonatomic) BOOL paused;

- (BOOL)toggleDebugOption:(NSString *)optionId;

- (void)setSound:(CGFloat)volume;
- (void)setMusic:(CGFloat)volume;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

- (void)applicationWillResignActive;
- (void)applicationDidBecomeActive;

- (void)store;

- (void)receiveGameCenterAuthenticatedNotification:(NSNotification *)notification;

- (void)renderer:(id<SCNSceneRenderer>)aRenderer didRenderScene:(SCNScene*)scene atTime:(NSTimeInterval)time;

@end
