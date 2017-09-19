//
//  SoundManager.m
//  GrandMasterBlocks
//
//  Created by Antony Kancidrowski on 26/11/2016.
//  Copyright © 2016 Cidrosoft. All rights reserved.
//

#import "SoundManager.h"

#import "Configuration.h"
#import "DebugOptions.h"

#import "Types.h"

@interface SoundManager()

@property (nonatomic) NSMutableDictionary *soundsDictionary;
@property (nonatomic) NSMutableArray *audioPlayersCache;

@property (nonatomic) dispatch_queue_t audioPlayersCacheQueue;

@property (nonatomic) AVAudioPlayer *musicPlayer;

@property (nonatomic) BOOL playingMusic;
@property (nonatomic) BOOL playing;

@end


@implementation SoundManager

#pragma mark Sounds

+ (void)preloadHomePanel {
    
    [[SoundManager sharedSoundManager] preloadSoundFromFilename:@"home_panel.wav" withKey:@"home_panel_sound"];
}

+ (SCNAction *)homePanelSoundActionWithWaitForCompletion:(BOOL)wait {
    
    return [[SoundManager sharedSoundManager] soundActionForKey:@"home_panel_sound" waitForCompletion:wait];
}

+ (void)preloadMenuSelection {
    
    [[SoundManager sharedSoundManager] preloadSoundFromFilename:@"menu_selection.wav" withKey:@"menu_selection_sound"];
}

+ (SCNAction *)menuselectionSoundActionWithWaitForCompletion:(BOOL)wait {
    
    return [[SoundManager sharedSoundManager] soundActionForKey:@"menu_selection_sound" waitForCompletion:wait];
}

+ (void)preloadSelectionSlide {
    
    [[SoundManager sharedSoundManager] preloadSoundFromFilename:@"selection_slide.wav" withKey:@"selection_slide_sound"];
}

+ (SCNAction *)selectionSlideSoundActionWithWaitForCompletion:(BOOL)wait {
    
    return [[SoundManager sharedSoundManager] soundActionForKey:@"selection_slide_sound" waitForCompletion:wait];
}

#pragma mark Music

+ (void)preloadMainMenuMusic {
    
    [[SoundManager sharedSoundManager] preloadSoundFromFilename:@"main_menu.m4a" withKey:@"main_menu_music"];
}

+ (void)mainmenuMusicAction:(SCNNode *)node {
    
    [node runAction:[[SoundManager sharedSoundManager] musicActionForKey:@"main_menu_music" loop:-1 autostart:NO]];
}

#pragma mark Shared Sound Manager

+ (SoundManager *)sharedSoundManager {
    
    static SoundManager *sharedSoundManager;
    
    @synchronized(self) {
        
        if (!sharedSoundManager)
            sharedSoundManager = [SoundManager new];
    }
    
    return sharedSoundManager;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil) {
        
        _soundsDictionary = [NSMutableDictionary new];
        _audioPlayersCache = [NSMutableArray new];
        
        _audioPlayersCacheQueue = dispatch_queue_create("com.cidrosoft.flytheflag.SoundManager.Queue", DISPATCH_QUEUE_SERIAL);
        
        _playingMusic = FALSE;
        _playing = FALSE;
    }
    
    return self;
}

-(void)dealloc {
    
    [_soundsDictionary removeAllObjects];
    _soundsDictionary = nil;
    
    for (AVAudioPlayer *player in _audioPlayersCache) {
        
        [player stop];
    }
    
    [_audioPlayersCache removeAllObjects];
    _audioPlayersCache = nil;
}

#pragma mark Play sounds

- (void)preloadSoundFromFilename:(NSString *)filename withKey:(id)key {
    
    if ([_soundsDictionary objectForKey:key] == nil) {
        
        NSData *data = [self audioDataFromSoundFileNamed:filename];
        [_soundsDictionary setObject:data forKey:key];
    }
}

- (SCNAction *)soundActionForKey:(id)key waitForCompletion:(BOOL)wait {
    
    return [self audioPlaySound:key waitForCompletion:wait];
}

#pragma mark Play music

- (SCNAction *)musicActionForKey:(id)key loop:(NSInteger)loops autostart:(BOOL)autostart {
    
    return [self audioPlayMusic:key loop:loops autostart:autostart];
}

#pragma mark Internal

- (NSData *)audioDataFromSoundFileNamed:(NSString *)fileNameWithExtention {
    
    if (fileNameWithExtention == nil) return nil;
    
    NSData *soundData = nil;
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:fileNameWithExtention ofType:nil];
    
    NSAssert(soundFile, @"No such file in mainBundle: %@", fileNameWithExtention);
    soundData = [[NSData alloc] initWithContentsOfFile:soundFile];
    
    return soundData;
}

- (SCNAction *)audioPlaySound:(id)key waitForCompletion:(BOOL)complete {
    
    __block AVAudioPlayer *audioPlayer = nil;
    __block gsUDWORD created = 0;
    
    NSData *soundData = [_soundsDictionary objectForKey:key];
    
    // Lookup cached player based on sound data hash
    NSArray *players = [_audioPlayersCache filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AVAudioPlayer *player, NSDictionary *bindings) {
        
        if ([[player data] length] == [soundData length]) {
            
            created += 1;
            
            return ([player currentTime] == 0);
            
        } else {
            
            return FALSE;
        }
    }]];
    
    // Do we need to create a player to play this type?
    if ([players count] == 0) {
        
        if (created > 6) { // || (([key containsString:@"ship_"]) && created > 1)) {
            
            return nil;
        }
        
        __block NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        
        if (error) {
            
            return nil;
        }
        
        // Lazy cache audio player
        dispatch_barrier_async(_audioPlayersCacheQueue, ^{
            
            NSAssert((audioPlayer != nil), @"We need an audioPlayer.");
            [_audioPlayersCache addObject:audioPlayer];
        });
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Audio Players - %lu - %@", (unsigned long)[_audioPlayersCache count], key);
        
        [audioPlayer setDelegate:self];
        [audioPlayer prepareToPlay];
    } else {
        
        audioPlayer = [players firstObject];
    }
    
    __block double delay = [audioPlayer duration] + 0.1;
    
    // Create playSoundAction which starts on concurrent queue to gain speed
    SCNAction *playAction = [SCNAction runBlock:^(SCNNode * _Nonnull node) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        audioPlayer.numberOfLoops = 0;
        audioPlayer.volume = [defaults floatForKey:kSoundPreference];;
        
        @try {
            
            [audioPlayer play];
            
            _playing = TRUE;
        }
        @catch (NSException *exception) {
            
            NSLog(@"Audio Player - %@", [exception description]);
        }
        
        //        NSLog(@"%s  Added: %@ withError: %@, Cache: %lu", __PRETTY_FUNCTION__, audioPlayer, error, (unsigned long)[sAVAudioPlayersCache count]);
    } queue:_audioPlayersCacheQueue];
    
    
    SCNAction *delayAction = (complete) ? [SCNAction waitForDuration:delay] : [SCNAction waitForDuration:0];
    
    SCNAction *action = [SCNAction sequence:@[playAction, delayAction]];
    return action;
}

- (SCNAction *)audioPlayMusic:(id)key loop:(NSInteger)loops autostart:(BOOL)autostart {
    
    NSData *soundData = [_soundsDictionary objectForKey:key];
    
    __block NSError *error;
    _musicPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
    
    if (error) {
        
        return nil;
    }
    
    [_musicPlayer setDelegate:self];
    
    if (!autostart) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [_musicPlayer setVolume:[defaults floatForKey:kMusicPreference]];
    } else {
        
        [_musicPlayer setVolume:0];
    }
    
    [_musicPlayer prepareToPlay];
    
    // Create playSoundAction which starts on concurrent queue to gain speed
    SCNAction *playAction = [SCNAction runBlock:^(SCNNode * _Nonnull node) {
        
        _musicPlayer.numberOfLoops = loops;
        
        @try {
            
            if (autostart) {
                
                [self playMusic];
            }
        }
        @catch (NSException *exception) {
            
            NSLog(@"Music Player - %@", [exception description]);
        }
        
        //        NSLog(@"%s  Added: %@ withError: %@, Cache: %lu", __PRETTY_FUNCTION__, audioPlayer, error, (unsigned long)[sAVAudioPlayersCache count]);
    } queue:_audioPlayersCacheQueue];
    
    return playAction;
}

- (SCNAction *)rampUpMusic:(CGFloat)duration {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    __block CGFloat target = [defaults floatForKey:kMusicPreference];
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Audio Player - target %f", target);

    return [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode * _Nonnull node, CGFloat elapsedTime) {
        
        CGFloat volume = (target * (elapsedTime / duration));
        [_musicPlayer setVolume:volume];
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Audio Player Ramp Up - %f", volume);
    }];
}

- (SCNAction *)rampDownMusic:(CGFloat)duration {
    
    return [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode * _Nonnull node, CGFloat elapsedTime) {
        
        CGFloat volume = ([_musicPlayer volume] - ([_musicPlayer volume] * (elapsedTime / duration)));
        [_musicPlayer setVolume:volume];
        
        if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
            NSLog(@"Audio Player Ramp Down - %f", volume);
    }];
}

- (void)playMusic {
    
    [_musicPlayer play];
    
    _playingMusic = TRUE;
}

- (void)stopMusic {
    
    _playingMusic = FALSE;
    
    [_musicPlayer stop];
}

- (void)setCurrentMusicTime:(NSTimeInterval)time {
    
    [_musicPlayer setCurrentTime:time];
}

- (BOOL)isMusicPlaying {
    
    return _playingMusic;
}

- (void)setMusicVolume:(CGFloat)volume {
    
    [_musicPlayer setVolume:volume];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    //NSLog(@"Player audioPlayerDidFinishPlaying.");
    
    [player stop];
    [player setCurrentTime:0];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Player audioPlayerBeginInterruption.");
    
    [player stop];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Player audioPlayerEndInterruption.");
    
    [player play];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
    if ([[DebugOptions optionForKey:@"EnableLog"] boolValue])
        NSLog(@"Player audioPlayerDecodeErrorDidOccur.");
}

@end
