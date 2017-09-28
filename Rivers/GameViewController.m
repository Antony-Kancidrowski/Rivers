//
//  GameViewController.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "GameViewController.h"
#import "GLSLBackgroundNode.h"

#import "GameGridManagerNode.h"

#import "LabelNode.h"
#import "ImageNode.h"

#import "ImageButtonNode.h"
#import "ButtonNode.h"
#import "TileNode.h"

#import "SoundManager.h"

#import "DebugOptions.h"

@interface GameViewController ()
{
    ButtonNode *selectedButton;
    TileNode *selectedTile;
}

@property (nonatomic, strong) GameGridManagerNode *gridManager;

@property (nonatomic, strong) SCNNode *overlay;

@property (nonatomic, strong) LabelNode *titleLabel;

@end

@implementation GameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.camera setPosition:SCNVector3Make(0.0f, 0.0f, 0.75f)];
    
    self.allowCameraControl = NO;
    
    self.paused = NO;
    
    selectedTile = nil;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = self.scene;
    
    scnView.pointOfView = [self.camera mainCameraNode];
    
    // configure the view
    scnView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    
    self.background = [GLSLBackgroundNode backgroundNodeWithShaderName:@"tileShader" andResolution:self.view.frame.size];
    [self.background setPosition:SCNVector3Make(0.0f, 0.0f, -5.0f)];
    [self.background setScale:SCNVector3Make(2.0f, 2.0f, 1.0f)];
    [self.background setup:self.scene.rootNode];
    
    _overlay = [SCNNode node];
    
    [_overlay setPosition:SCNVector3Zero];
    [self.scene.rootNode addChildNode:_overlay];
    [_overlay setScale:SCNVector3Make(1.0f, 1.0f, 1.0f)];
    [_overlay setEulerAngles:SCNVector3Make(-0.125f, 0.0f, 0.0f)];
    
    _gridManager = [GameGridManagerNode gridManagerWithType:ZenGame];
    [_gridManager setPosition:SCNVector3Zero];
    [_gridManager setScale:SCNVector3Make(0.5f, 0.5f, 0.5f)];
    [_gridManager setup:_overlay];
    
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
    
    [_gridManager activate];
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
    
    [_gridManager deactivate];
    
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
    
    // TODO:
    
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
    
    if ((self.gridMenuShown) || (self.disableGestures)) {
        
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
            
            selectedTile = nil;
            
            for (int i = 0; i < [hitResults count]; ++i) {
                
                SCNHitTestResult *result = [hitResults objectAtIndex:i];
                
                if ([result.node.parentNode isKindOfClass:[ButtonNode class]]) {
                    
                    selectedButton = (ButtonNode *)result.node.parentNode;
                    
                } else if ([result.node isKindOfClass:[TileNode class]]) {
                    
                    selectedTile = (TileNode *)result.node;
                    
                } else if ([result.node isKindOfClass:[BackgroundNode class]]) {
                        
                    [self dismissGame];
                    break;
                    
                } else {
                    
                    continue;
                }
            }
            
            // Get its material
            SCNMaterial *material = selectedTile.geometry.firstMaterial;
            
            // Highlight it
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            // On completion - unhighlight
            [SCNTransaction setCompletionBlock:^{
                [SCNTransaction begin];
                [SCNTransaction setAnimationDuration:0.5];
                
                material.emission.contents = [UIColor blackColor];
                
                [SCNTransaction commit];
            }];
            
            material.emission.contents = [UIColor redColor];
            
            [SCNTransaction commit];
            
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
            
            selectedTile = nil;
        }
        
    } else if (gestureRecognize.state == UIGestureRecognizerStateEnded) {
        
        if (selectedButton != nil) {
            
            [selectedButton releaseButton];
            selectedButton = nil;
        }
    }
}

#pragma mark Navigation

- (void)dismissGame {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        // Retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        scnView.scene = nil;
        
        self.background = nil;
        
        selectedTile = nil;
    }];
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
