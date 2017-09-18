//
//  SoundManager.h
//  GrandMasterBlocks
//
//  Created by Antony Kancidrowski on 26/11/2016.
//  Copyright © 2016 Cidrosoft. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject <AVAudioPlayerDelegate>

+ (SoundManager *)sharedSoundManager;

+ (void)preloadHomePanel;
+ (void)preloadMenuSelection;

+ (void)preloadMainMenuMusic;


+ (SCNAction *)homePanelSoundActionWithWaitForCompletion:(BOOL)wait;
+ (SCNAction *)menuselectionSoundActionWithWaitForCompletion:(BOOL)wait;


- (void)preloadSoundFromFilename:(NSString *)filename withKey:(id)key;

- (SCNAction *)soundActionForKey:(id)key waitForCompletion:(BOOL)wait;
- (SCNAction *)musicActionForKey:(id)key loop:(NSInteger)loops autostart:(BOOL)autostart;

- (void)playMusic;
- (void)stopMusic;

- (SCNAction *)rampUpMusic:(CGFloat)duration;
- (SCNAction *)rampDownMusic:(CGFloat)duration;

- (void)setCurrentMusicTime:(NSTimeInterval)time;
- (BOOL)isMusicPlaying;

- (void)setMusicVolume:(CGFloat)volume;

@end

