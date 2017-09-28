//
//  SettingsViewController.m
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "SettingsViewController.h"

#import "TexturedBackgroundNode.h"

#import "AppSpecificValues.h"
#import "Configuration.h"
#import "DebugOptions.h"

#import "SoundManager.h"

#import "ThemePanelManagerNode.h"

#import "ImageButtonNode.h"

#import "SliderNode.h"
#import "VolumeSliderNode.h"

#import "ImageNode.h"
#import "LabelNode.h"

@interface SettingsViewController ()
{
    ThemePanelManagerNode *themePanelManager;
    
    ImageNode *settingsPanel;
    
    LabelNode *headerText;
    
    LabelNode *soundText;
    LabelNode *musicText;
    
    LabelNode *themeText;
    
    VolumeSliderNode *musicSlider;
    VolumeSliderNode *soundSlider;
    
    ImageButtonNode *closeButton;
    
    SliderNode *selectedSlider;
    ButtonNode *selectedButton;
    
    SCNAction *buttonLure;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.background = [TexturedBackgroundNode backgroundWithTextureNamed:@"black-background.png"];
    
    [self.background setScale:SCNVector3Make(8.0f, 8.0f, 0.0f)];
    [self.background setPosition:SCNVector3Zero];
    
    [self.background setup:self.scene.rootNode];
    
    settingsPanel = [ImageNode imageWithTextureNamed:@"settings-panel.png" andSize:CGSizeMake(1.75f, 2.25f)];
    
    CGFloat scaleX = 1.80f;
    CGFloat scaleY = 1.80f;
    
    [settingsPanel setScale:SCNVector3Make(scaleX, scaleY, 1.0f)];
    [settingsPanel setup:self.scene.rootNode];
    
    themePanelManager = [ThemePanelManagerNode new];
    [themePanelManager setScale:SCNVector3Make(0.6f, 0.6f, 1.0f)];
    [themePanelManager setPosition:SCNVector3Make(0.0f, -0.45f, 0.0f)];
    
    [themePanelManager setup:settingsPanel];
    
    NSShadow *myShadow = [NSShadow new];
    [myShadow setShadowColor:[UIColor blackColor]];
    [myShadow setShadowBlurRadius:5.0];
    [myShadow setShadowOffset:CGSizeMake(2, 2)];
    
    headerText = [LabelNode setLabelWithText:NSLocalizedString(@"Settings", nil) withFontNamed:@"Zapfino" fontSize:60 fontColor:[UIColor whiteColor]];
    [headerText setShadow:myShadow];
    
    [headerText setScale:SCNVector3Make(0.3f, 0.20f, 1.0f)];
    [headerText setPosition:SCNVector3Make(0.0f, 1.0f, 1.4f)];
    
    [headerText setup:settingsPanel];
    
    
    const CGFloat headingsscale = 0.8f;
    
    soundText = [LabelNode setLabelWithText:NSLocalizedString(@"Sound", nil) withFontNamed:@"Futura" fontSize:60 fontColor:[UIColor whiteColor]];
    [soundText setShadow:myShadow];
    
    [soundText setTextAlignmentMode:NSTextAlignmentLeft];
    
    [soundText setScale:SCNVector3Make(0.15f * headingsscale, 0.07f * headingsscale, 1.0f)];
    [soundText setPosition:SCNVector3Make(-0.45f, 0.55f, 1.4f)];
    
    [soundText setup:settingsPanel];
    
    soundSlider = [VolumeSliderNode new];
    [soundSlider setScale:SCNVector3Make(0.1f * headingsscale, 0.1f * headingsscale, 1.0f)];
    [soundSlider setPosition:SCNVector3Make(0.13f, 0.55f, 1.4f)];
    
    [soundSlider addTarget:self action:@selector(soundChanged:)];
    [soundSlider setup:settingsPanel];
    
    musicText = [LabelNode setLabelWithText:NSLocalizedString(@"Music", nil) withFontNamed:@"Futura" fontSize:60 fontColor:[UIColor whiteColor]];
    [musicText setShadow:myShadow];
    
    [musicText setTextAlignmentMode:NSTextAlignmentLeft];
    
    [musicText setScale:SCNVector3Make(0.15f * headingsscale, 0.07f * headingsscale, 1.0f)];
    [musicText setPosition:SCNVector3Make(-0.45f, 0.25f, 1.4f)];
    
    [musicText setup:settingsPanel];
    
    musicSlider = [VolumeSliderNode new];
    [musicSlider setScale:SCNVector3Make(0.1f * headingsscale, 0.1f * headingsscale, 1.0f)];
    [musicSlider setPosition:SCNVector3Make(0.13f, 0.25f, 1.4f)];
    
    [musicSlider addTarget:self action:@selector(musicChanged:)];
    [musicSlider setup:settingsPanel];
    
    themeText = [LabelNode setLabelWithText:NSLocalizedString(@"Theme", nil) withFontNamed:@"Futura" fontSize:60 fontColor:[UIColor whiteColor]];
    [themeText setShadow:myShadow];
    
    [themeText setTextAlignmentMode:NSTextAlignmentLeft];
    
    [themeText setScale:SCNVector3Make(0.15f * headingsscale, 0.07f * headingsscale, 1.0f)];
    [themeText setPosition:SCNVector3Make(-0.45f, -0.15f, 1.4f)];
    
    [themeText setup:settingsPanel];
    
    
    const CGFloat arrowscale = 0.05f;
    
    
    
    closeButton = [ImageButtonNode imageButtonWithName:nil andButtonColor:nil andTagName:@"menu-close-x" andTagAlignment:TagHorizontalAlignmentCenter];
    [closeButton setScale:SCNVector3Make(2.5f * arrowscale, 2.5f * arrowscale, 1.0f)];
    [closeButton setPosition:SCNVector3Make(0.925f * (1.75f / 2.25f), 0.925f, 0.6f)];
    
    [closeButton addPressSoundAction:[SoundManager menuselectionSoundActionWithWaitForCompletion:NO]];
    
    [closeButton addTarget:self action:@selector(dismissSettings) forControlEvent:ButtonNodeControlEventTouchUpInside];
    [closeButton setup:settingsPanel];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = self.scene;
    
    scnView.pointOfView = [self.camera mainCameraNode];
    
    // configure the view
    scnView.backgroundColor = [UIColor clearColor];
    
    buttonLure = [SCNAction sequence:@[
                                       [SCNAction waitForDuration:2.5],
                                       [SCNAction scaleBy:1.05f duration:0.5],
                                       [SCNAction scaleBy:(1.0f / 1.05f) duration:0.5],
                                       [SCNAction waitForDuration:2.5]
                                       ]
                  ];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.background activate];
    
    [settingsPanel activate];
    
    [headerText activate];
    
    [soundText activate];
    [soundSlider activate];
    
    
    CGFloat soundVolume = [[[NSUserDefaults standardUserDefaults] valueForKey:kSoundPreference] floatValue];
    [soundSlider updateVolume:soundVolume];
    
    [musicText activate];
    [musicSlider activate];
    
    CGFloat musicVolume = [[[NSUserDefaults standardUserDefaults] valueForKey:kMusicPreference] floatValue];
    [musicSlider updateVolume:musicVolume];
    
    [themeText activate];
    
    [themePanelManager activate];
    
    [closeButton activate];
    [closeButton runAction:[SCNAction repeatActionForever:buttonLure]];
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self.background deactivate];
    
    [settingsPanel deactivate];
    
    [headerText deactivate];
    
    [soundText deactivate];
    [soundSlider deactivate];
    
    [musicText deactivate];
    [musicSlider deactivate];
    
    [themeText deactivate];
    
    [themePanelManager deactivate];
    
    [closeButton deactivate];
    
    [super viewDidDisappear:animated];
}

- (void)applicationWillResignActive {
    
    // TODO:
    
    [super applicationWillResignActive];
}

- (void)applicationDidBecomeActive {
    
    [super applicationDidBecomeActive];
    
    [themePanelManager moveToCurrentTheme];
}

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)gestureRecognize {
    
    if (self.gridMenuShown) {
        
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

- (IBAction)panAction:(UIPanGestureRecognizer *)gestureRecognize {
    
    if (gestureRecognize.state == UIGestureRecognizerStateBegan) {
        
        // retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        
        // check what nodes are tapped
        CGPoint p = [gestureRecognize locationInView:scnView];
        NSArray *hitResults = [scnView hitTest:p options:nil];
        
        // check that we clicked on at least one object
        if ([hitResults count] > 0) {
            
            selectedSlider = nil;
            
            for (int i = 0; i < [hitResults count]; ++i) {
                
                SCNHitTestResult *result = [hitResults objectAtIndex:i];
                
                if ([result.node.parentNode isKindOfClass:[SliderNode class]]) {
                    
                    selectedSlider = (SliderNode *)result.node.parentNode;
                    
                    if ([result.node.name compare:@"SliderBar"] == NSOrderedSame) {
                        
                        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue]) {
                            
                            NSLog(@"Local Coords: %f, %f, %f", result.localCoordinates.x, result.localCoordinates.y, result.localCoordinates.z);
                        }
                        
                        if ((result.localCoordinates.x > -0.5f) && (result.localCoordinates.x < 0.5f)) {
                            
                            [selectedSlider updatePosition:result.localCoordinates.x];
                        }
                    }
                } else {
                    
                    continue;
                }
            }
            
            if (nil == selectedSlider)
                return;
            
            // Get its material
            SCNMaterial *material = selectedSlider.geometry.firstMaterial;
            
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
            
        } else {
            
            selectedSlider = NULL;
        }
        
    } else if (gestureRecognize.state == UIGestureRecognizerStateChanged) {
        
        // TODO:
        
        // retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        
        // check what nodes are tapped
        CGPoint p = [gestureRecognize locationInView:scnView];
        NSArray *hitResults = [scnView hitTest:p options:nil];
        
        // check that we clicked on at least one object
        if ([hitResults count] > 0) {
            
            selectedSlider = nil;
            
            for (int i = 0; i < [hitResults count]; ++i) {
                
                SCNHitTestResult *result = [hitResults objectAtIndex:i];
                
                if ([result.node.parentNode isKindOfClass:[SliderNode class]]) {
                    
                    selectedSlider = (SliderNode *)result.node.parentNode;
                    
                    if ([result.node.name compare:@"SliderBar"] == NSOrderedSame) {
                        
                        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue]) {
                            
                            NSLog(@"Local Coords: %@, %f, %f, %f", result.node.name, result.localCoordinates.x, result.localCoordinates.y, result.localCoordinates.z);
                        }
                        
                        if ((result.localCoordinates.x > -0.5f) && (result.localCoordinates.x < 0.5f)) {
                            
                            [selectedSlider updatePosition:result.localCoordinates.x];
                        }
                    }
                } else {
                    
                    continue;
                }
            }
        }
        
    } else if (gestureRecognize.state == UIGestureRecognizerStateEnded) {
        
        if (NULL == selectedSlider)
            return;
        
        // TODO:
        
        selectedSlider = NULL;
    }
}

#pragma mark Slider Change Control

- (void)soundChanged:(NSNumber *)number {
    
    [self setSound:[number floatValue]];
}

- (void)musicChanged:(NSNumber *)number {
    
    [self setMusic:[number floatValue]];
}

#pragma mark Navigation

- (void)dismissSettings{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        // Retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        scnView.scene = nil;
        
        self.background = nil;
        
        settingsPanel = nil;
        
        headerText = nil;
        
        soundText = nil;
        soundSlider = nil;
        
        musicText = nil;
        musicSlider = nil;
        
        themeText = nil;
        themePanelManager = nil;
        
        closeButton = nil;
        
        selectedSlider = nil;
        selectedButton = nil;
    }];
}

@end
