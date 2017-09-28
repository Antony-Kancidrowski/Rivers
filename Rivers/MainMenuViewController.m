//
//  MainMenuViewController.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "MainMenuViewController.h"

#import "FlyingTilesManagerNode.h"
#import "GLSLBackgroundNode.h"

#import "LabelNode.h"
#import "ImageNode.h"

#import "ImageButtonNode.h"
#import "ButtonNode.h"

#import "SoundManager.h"

#import "DebugOptions.h"

@interface MainMenuViewController ()
{
    ButtonNode *selectedButton;
}

@property (nonatomic, strong) SCNNode *overlay;

@property (nonatomic, strong) MainMenuNode *mainMenuNode;
@property (nonatomic, strong) ImageButtonNode *storeButton;

@property (nonatomic, strong) FlyingTilesManagerNode *flyingTiles;

@property (nonatomic, strong) ImageNode *applicationImage;
@property (nonatomic, strong) LabelNode *copyrightLabel;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.camera setPosition:SCNVector3Make(0.0f, 0.0f, 0.75f)];
    
    self.allowCameraControl = NO;
    
    self.paused = NO;
    
    selectedButton = nil;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = self.scene;
    
    scnView.pointOfView = [self.camera mainCameraNode];
    
    // configure the view
    scnView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    
    self.background = [GLSLBackgroundNode backgroundNodeWithShaderName:@"blueSwirlShader" andResolution:self.view.frame.size];
    [self.background setPosition:SCNVector3Make(0.0f, 0.0f, -5.0f)];
    [self.background setScale:SCNVector3Make(2.0f, 2.0f, 1.0f)];
    [self.background setup:self.scene.rootNode];
    
    _flyingTiles = [FlyingTilesManagerNode new];
    [_flyingTiles setPosition:SCNVector3Make(0.0f, 0.0f, -2.0f)];
    [_flyingTiles setup:self.scene.rootNode];
  
    _overlay = [SCNNode node];
    
    [_overlay setPosition:SCNVector3Zero];
    [self.scene.rootNode addChildNode:_overlay];
    [_overlay setScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    
    NSString *applicationImageName = [NSString stringWithFormat:@"%@.png", NSLocalizedString(@"MAIN_MENU_IMAGE", nil)];
    
    _applicationImage = [ImageNode imageWithTextureNamed:applicationImageName];
    [_applicationImage setScale:SCNVector3Make(1.36f, 0.40f, 1.0f)];
    
    [_applicationImage setup:_overlay];
    
    _mainMenuNode = [MainMenuNode new];
    [_mainMenuNode setPosition:SCNVector3Zero];
    [_mainMenuNode setScale:SCNVector3Make(1.2f, 1.2f, 1.0f)];
    [_mainMenuNode setDelegate:self];
    
    [_mainMenuNode setup:_overlay];
    
    _storeButton = [ImageButtonNode imageButtonWithName:nil andButtonColor:nil andTagName:@"shop" andTagAlignment:TagHorizontalAlignmentCenter];
    
    [_storeButton setScale:SCNVector3Make(0.4f, 0.4f, 1.0f)];
    
    [_storeButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [_storeButton addTarget:self action:@selector(store) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [_storeButton setup:_overlay];
    
    
    NSShadow *myShadow = [NSShadow new];
    [myShadow setShadowColor:[UIColor blackColor]];
    [myShadow setShadowBlurRadius:5.0];
    [myShadow setShadowOffset:CGSizeMake(2, 2)];
    
    _copyrightLabel = [LabelNode setLabelWithText:@"© 2017 Cidrosoft. All rights reserved." withFontNamed:@"Futura" fontSize:36 fontColor:[UIColor whiteColor]];
    [_copyrightLabel setShadow:myShadow];
    
    [_copyrightLabel setScale:SCNVector3Make(1.14f, 0.09f, 1.0f)];
    
    [_copyrightLabel setup:_overlay];

    self.camera.mainCameraNode.constraints = @[[SCNLookAtConstraint lookAtConstraintWithTarget:_overlay]];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.scene.rootNode runAction:[[SoundManager sharedSoundManager] rampUpMusic:1.25]];
    [self.scene.rootNode runAction:[[SoundManager sharedSoundManager] musicActionForKey:@"main_menu_music" loop:-1 autostart:YES]];
    
    [self setlayout];
    
    // Activate
    [self.background activate];
    [self.background animate];
    
    [_flyingTiles activate];
    
    [_applicationImage activate];
    
    [_mainMenuNode activate];
    [_storeButton activate];
    
    [_copyrightLabel activate];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self setlayout];
    
    [[SoundManager sharedSoundManager] playMusic];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // Ramp down music
    [self.scene.rootNode runAction:[[SoundManager sharedSoundManager] rampDownMusic:1.25]];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // Deactivate
    [self.background deactivate];
    
    [_flyingTiles deactivate];
    
    [_applicationImage deactivate];
    
    [_mainMenuNode deactivate];
    [_storeButton deactivate];
    
    [_copyrightLabel deactivate];
    
    [[SoundManager sharedSoundManager] stopMusic];
    
    [super viewDidDisappear:animated];
}

#pragma mark - Autorotation and Layout

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    [self setlayout];
}

- (void)setlayout {
    
    // Retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    SCNCamera *cam = scnView.pointOfView.camera;
    
    SCNMatrix4 pt = cam.projectionTransform;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        self.xmultiplier = self.view.frame.size.width / 320.0f;
        self.ymultiplier = self.view.frame.size.height / 480.0f;
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        self.xmultiplier = self.view.frame.size.width / 768.0f;
        self.ymultiplier = self.view.frame.size.height / 1024.0f;
    }
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"UIInterfaceOrientationPortrait");
    } else {
        
        self.xmultiplier *= self.view.frame.size.width / self.view.frame.size.height;
        self.ymultiplier *= self.view.frame.size.width / self.view.frame.size.height;
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"UIInterfaceOrientationLandscape");
    }
    
    [_applicationImage setPosition:SCNVector3Make(0.0f, -pt.m43 * self.ymultiplier, 0.0f)];
    
    [_storeButton setPosition:SCNVector3Make(-pt.m33 * self.xmultiplier * 1.35f, pt.m43 * self.ymultiplier, 0.0f)];

    [_copyrightLabel setPosition:SCNVector3Make(0.0f, pt.m43 * self.ymultiplier, 0.0f)];
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Camera projection transform %f, %f", pt.m33, pt.m43);
}

#pragma mark - Gestures

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([super gestureRecognizerShouldBegin:gestureRecognizer]) {
        
        if ((self.paused) &&
            (![gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])) {
            
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)gestureRecognize {
    
    if ((self.debugMenuShown) || (self.disableGestures)) {
        
        return;
    }
    
    if (gestureRecognize.state == UIGestureRecognizerStateBegan) {
        
        // Retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        
        // Check what nodes are tapped
        CGPoint p = [gestureRecognize locationInView:scnView];
        
        NSArray *hitResults = [scnView hitTest:p options:nil];
        
        // Check that we clicked on at least one object
        if([hitResults count] > 0) {
            
            selectedButton = nil;
            
            for (int i = 0; i < [hitResults count]; ++i) {
                
                SCNHitTestResult *result = [hitResults objectAtIndex:i];
                
                if ([result.node.parentNode isKindOfClass:[ButtonNode class]]) {
                    
                    selectedButton = (ButtonNode *)result.node.parentNode;
                } else {
                    
                    continue;
                }
            }
            
            if (selectedButton != nil) {
                
                [selectedButton pressButton];
            }
        }
    } else if (gestureRecognize.state == UIGestureRecognizerStateChanged) {
        
        if (selectedButton == nil) {
            
            return;
        }
        
        // Retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        
        // Check what nodes are tapped
        CGPoint p = [gestureRecognize locationInView:scnView];
        
        NSArray *hitResults = [scnView hitTest:p options:nil];
        
        // Check that we clicked on at least one object
        if([hitResults count] > 0) {
            
            ButtonNode *current;
            
            for (int i = 0; i < [hitResults count]; ++i) {
                
                SCNHitTestResult *result = [hitResults objectAtIndex:i];
                
                if ([result.node.parentNode isKindOfClass:[ButtonNode class]]) {
                    
                    current = (ButtonNode *)result.node.parentNode;
                    
                    if (current == selectedButton) {
                        
                        return;
                    }
                } else {
                    
                    continue;
                }
            }
            
            [selectedButton cancelButton];
            
            selectedButton = nil;
        }
        
    } else if (gestureRecognize.state == UIGestureRecognizerStateEnded) {
        
        if (selectedButton != nil) {
            
            [selectedButton releaseButton];
            selectedButton = nil;
        }
    }
}

#pragma mark - Navigation

- (void)playGame {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Navigate to Game Type.");
    
    // TODO: Ramp down music and fade to black, then perform segue
    
    [self performSegueWithIdentifier:@"GameSegue" sender:self];
    
}

- (void)tutorial {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Navigate to tutorial.");
    
    // TODO: Ramp down music and fade to black, then perform segue
    
    [self performSegueWithIdentifier:@"TutorialSegue" sender:self];
    
}

- (void)settings {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Navigate to settings.");
    
    [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"GameSegue"]) {
        
        [[SoundManager sharedSoundManager] stopMusic];
        
        //        [mainMenuNode runAction:menuOff];
        
        // TODO: Setup details to pass to segue
        
    } else if ([segue.identifier isEqualToString:@"TutorialSegue"]) {
        
        [[SoundManager sharedSoundManager] stopMusic];
        
        //        [mainMenuNode runAction:menuOff];
        
        // TODO: Setup details to pass to segue
        
    } else if ([segue.identifier isEqualToString:@"SettingsSegue"]) {
        
        // TODO: Setup details to pass to segue
        
    }
}

#pragma mark GameCenter View Controllers

- (void)leaderBoard {
    
    GKGameCenterViewController *leaderboardController = [GKGameCenterViewController new];
    
    if (leaderboardController != NULL)
    {
        leaderboardController.gameCenterDelegate = self;
        
        leaderboardController.leaderboardIdentifier = kZenLeaderboardID;
        leaderboardController.leaderboardTimeScope = GKLeaderboardTimeScopeAllTime;
        
        [self presentViewController:leaderboardController animated:YES completion:nil];
    }
}

- (void)achievements {
    
    GKGameCenterViewController *achievements = [GKGameCenterViewController new];
    
    if (achievements != NULL)
    {
        achievements.gameCenterDelegate = self;
        
        [self presentViewController:achievements animated:YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark Authentication

- (void)receiveGameCenterAuthenticatedNotification:(NSNotification *)notification {
    
    [super receiveGameCenterAuthenticatedNotification:notification];
    
    if ([[notification name] isEqualToString:@"GameCenterAuthenticated"]) {
        
        [_mainMenuNode authenticateGKPlayer:([GKLocalPlayer localPlayer].authenticated)];
    }
}

#pragma mark - UIStateRestoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"GameSceneViewController: encodeRestorableStateWithCoder");
    
    // TODO: Encode restorable state
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"GameSceneViewController: decodeRestorableStateWithCoder");
    
    // TODO: Decode restoraable state
    
    [super decodeRestorableStateWithCoder:coder];
}

@end
