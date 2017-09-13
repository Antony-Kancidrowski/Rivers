//
//  RiversViewController.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "RiversViewController.h"

#import "Configuration.h"
#import "DebugOptions.h"

#import "AppSpecificValues.h"
#import "Configuration.h"

#import "MathHelper.h"

@interface FlyTheFlagViewController ()
{
    NSDate *nextFrameCounterReset;
}

@end

@implementation FlyTheFlagViewController

@synthesize scene;

@synthesize camera;
@synthesize background;

@synthesize aspectRatio;

@synthesize disableGestures;
@synthesize allowCameraControl;

@synthesize gridMenuShown;
@synthesize paused;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Size (%f, %f)", self.view.frame.size.width, self.view.frame.size.height);
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            
            // TODO: 375 x 667
            
            self.xmultiplier = self.view.frame.size.width / 320.0f;
            self.ymultiplier = self.view.frame.size.height / 480.0f;
        } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            
            self.xmultiplier = self.view.frame.size.width / 768.0f;
            self.ymultiplier = self.view.frame.size.height / 1024.0f;
        }
        
        self.aspectRatio = (self.view.frame.size.height / self.view.frame.size.width);
        
    } else  {
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            
            // TODO: 667 x 375
            
            self.ymultiplier = self.view.frame.size.width / 480.0f;
            self.xmultiplier = self.view.frame.size.height / 320.0f;
        } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            
            self.ymultiplier = self.view.frame.size.width / 1024.0f;
            self.xmultiplier = self.view.frame.size.height / 768.0f;
        }
        
        self.aspectRatio = (self.view.frame.size.width / self.view.frame.size.height);
    }
    
    self.xmultiplier = 1.0f;
    self.ymultiplier = 1.0f;
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Multiplier (%f, %f)", self.xmultiplier, self.ymultiplier);
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Aspect ratio (%f)", self.aspectRatio);

    scnView.preferredFramesPerSecond = kPreferredFrameRate;
    scnView.delegate = self;
    
    // Create a new scene
    self.scene = [SCNScene scene];
    
    self.camera = [CameraNode node];
    
//    [self.camera setPosition:SCNVector3Make(0.0f, 0.25f, 0.75f)];
    [self.camera setPosition:SCNVector3Make(0.0f, 0.0f, 0.0f)];
    [self.camera setEulerAngles:SCNVector3Make(-M_PI_2, 0.0f, 0.0f)];
    
    [self.camera activate:self.scene.rootNode];
    
    [self.camera setYFov:(self.aspectRatio * 16.0)];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor whiteColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    [scnView setAllowsCameraControl:self.allowCameraControl];
    
    gridMenuShown = NO;
    
    self.disableGestures = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:NULL];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveShowBackgroundChangedNotification:)
                                                 name:@"ShowBackgroundLayer"
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveShowDebugInformationNotification:)
                                                 name:@"ShowDebugInformation"
                                               object:NULL];
  
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    NSNumber *show = [DebugOptions optionForKey:@"ShowDebugInformation"];
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = show.boolValue;
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

#pragma mark Notifications

- (void)applicationWillResignActive {
    
}

- (void)applicationDidBecomeActive {
    
}

- (void)receiveShowDebugInformationNotification:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:@"ShowDebugInformation"]) {
        
        NSNumber *show = [DebugOptions optionForKey:@"ShowDebugInformation"];
        
        SCNView *scnView = (SCNView *)self.view;
        
        scnView.showsStatistics = show.boolValue;
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Successfully received Show Debug Information Changed!");
    }
}

- (void)receiveShowBackgroundChangedNotification:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:@"ShowBackgroundLayer"]) {
        
        NSNumber *show = [DebugOptions optionForKey:@"ShowBackgroundLayer"];
        
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:1.0];
        
        if (show.boolValue == false) {
            
            [background setOpacity:0.0f];
        } else {
            
            [background setOpacity:1.0f];
        }
        
        [SCNTransaction commit];
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Successfully received Show Background Changed!");
    }
}

#pragma mark UI Recognition

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ((gridMenuShown) || (self.disableGestures)) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark Debug Options

- (BOOL)toggleDebugOption:(NSString *)optionId {
    
    DebugOptions *options = [DebugOptions sharedDebugOptions];
    
    // Toggle debug option
    NSNumber *show = [options objectForKey:optionId];
    show = [NSNumber numberWithBool:!show.boolValue];
    
    [options setObject:show forKey:optionId];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:optionId
                                                        object:nil];
    
    return show.boolValue;
}

- (void)setZoom:(CGFloat)zoom {
    
    DebugOptions *options = [DebugOptions sharedDebugOptions];
    
    NSNumber *value = [NSNumber numberWithFloat:zoom];
    [options setObject:value forKey:@"Zoom"];
}

#pragma mark Grid

#pragma mark - Grid

- (void)showGridWithHeaderFromPoint:(CGPoint)point {
    
    NSArray *items = @[
                       [[GridMenuItem alloc] initWithType:MENU_ITEM_IMAGE withImage:[UIImage imageNamed:@"dm_pause"] title:@"Pause" dismisses:YES],
                       [[GridMenuItem alloc] initWithType:MENU_ITEM_IMAGE withImage:[UIImage imageNamed:@"dm_reset"] title:@"Reset" dismisses:YES],
                       [[GridMenuItem alloc] initWithType:MENU_ITEM_IMAGE withImage:[UIImage imageNamed:@"dm_back"] title:@"Back" dismisses:YES]
                       ];
    
    NSInteger numberOfOptions = [items count];
    
    GridMenuViewController *av = [[GridMenuViewController alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.title = NSLocalizedString(@"MAINMENU", nil);
    av.delegate = self;
    av.animationDuration = 0.2;
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    header.text = NSLocalizedString(av.title, nil);
    header.font = [UIFont boldSystemFontOfSize:18];
    header.backgroundColor = [UIColor blackColor];
    header.textColor = [UIColor grayColor];
    header.textAlignment = NSTextAlignmentCenter;
    av.headerView = header;
    
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width / 2.f, self.view.bounds.size.height / 2.f)];
    
    SCNView *scnView = (SCNView *)self.view;
    [scnView setAllowsCameraControl:NO];
    
    self.gridMenuShown = YES;
}

- (void)gridMenu:(GridMenuViewController *)gridMenu willDismissWithSelectedItem:(GridMenuItem *)item atIndex:(NSInteger)itemIndex {
    
    if ([gridMenu.title compare:NSLocalizedString(@"MAINMENU", nil)] != NSOrderedSame) {
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
        
        if (item.dismisses) {
            
            SCNView *scnView = (SCNView *)self.view;
            [scnView setAllowsCameraControl:self.allowCameraControl];
            
            self.gridMenuShown = NO;
        }
        
        return;
    }
    
    BOOL newMenu = NO;
    
    switch (itemIndex) {
        case 0:
        {
            // TODO:
        }
            break;
            
        case 1:
        {
            // TODO:
        }
            break;
            
        case 2:
        {
            // TODO:
        }
            break;
            
        default:
            break;
    }
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
    
    if ((item.dismisses) && (!newMenu)) {
        
        SCNView *scnView = (SCNView *)self.view;
        [scnView setAllowsCameraControl:self.allowCameraControl];
        
        self.gridMenuShown = NO;
    }
}

- (void)gridMenuWillDismiss:(GridMenuViewController *)gridMenu {
    
    SCNView *scnView = (SCNView *)self.view;
    [scnView setAllowsCameraControl:self.allowCameraControl];
    
    gridMenuShown = NO;
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Grid Menu %@ dismissed.", gridMenu.title);
}

#pragma mark SCNSceneRendererDelegate

- (void)renderer:(id<SCNSceneRenderer>)aRenderer didRenderScene:(SCNScene*)scene atTime:(NSTimeInterval)time {
    
    NSDate *now = [NSDate date];
    
    if (nextFrameCounterReset) {
        
        if (NSOrderedDescending == [now compare:nextFrameCounterReset]) {
            
            self.frameCount = 0;
            nextFrameCounterReset = [now dateByAddingTimeInterval:1.0];
        }
    } else {
        
        nextFrameCounterReset = [now dateByAddingTimeInterval:1.0];
    }
    
    self.frameCount++;
}

#pragma mark - UIStateRestoration

// encodeRestorableStateWithCoder is called when the app is suspended to the background
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    // TODO:
    
    [super encodeRestorableStateWithCoder:coder];
}

// decodeRestorableStateWithCoder is called when the app is re-launched
- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    // TODO:
    
    [super decodeRestorableStateWithCoder:coder];
}

@end
