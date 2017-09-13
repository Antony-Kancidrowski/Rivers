//
//  ButtonNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ButtonNode.h"

#import "ImageNode.h"
#import "LabelNode.h"

#import "Configuration.h"

@interface ButtonNode ()
{
    NSMutableArray *selectorsArray;
    
    SCNAction *pressSoundAction;
    
    SCNVector3  scale;
    
    BOOL buttonEnabled;
}
@end

@implementation ButtonNode

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil)
    {
        buttonEnabled = TRUE;
        
        pressSoundAction = nil;
        
        selectorsArray = [NSMutableArray new];
    }
    
    return self;
}

- (void)EnableButton:(BOOL)enable {
    
    buttonEnabled = enable;
}

- (BOOL)isButtonEnabled {
    
    return buttonEnabled;
}

- (void)addPressSoundAction:(SCNAction *)action {
    
    pressSoundAction = action;
}

- (void)pressButton {
    
    if (!buttonEnabled) {
        
        return;
    }
    
    static const NSTimeInterval duration = 0.05;
    
    [self enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        
        // Get its material
        SCNMaterial *material = child.geometry.firstMaterial;
        
        material.specular.intensity = material.diffuse.intensity;
        
        // Unhighlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:duration];
        
        material.diffuse.intensity = 0.5f;
        
        [SCNTransaction commit];
    }];
    
    if (pressSoundAction) {
        
        [self runAction:pressSoundAction];
    }
    
    [self runAction:[SCNAction scaleBy:kScaleDown duration:duration]];
    
    [self controlEventOccured:ButtonNodeControlEventTouchDown];
}

- (void)releaseButton {
    
    if (!buttonEnabled) {
        
        return;
    }

    static const NSTimeInterval duration = 0.10;
    
    [self enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        
        // Get its material
        SCNMaterial *material = child.geometry.firstMaterial;
        
        // Unhighlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:duration];
        
        material.diffuse.intensity = material.specular.intensity;
        
        [SCNTransaction commit];
    }];
    
    [self runAction:[SCNAction scaleBy:kScaleUp duration:duration]];
    
    [self controlEventOccured:ButtonNodeControlEventTouchUp];
    [self controlEventOccured:ButtonNodeControlEventTouchUpInside];
}

- (void)cancelButton {
    
    if (!buttonEnabled) {
        
        return;
    }
    
    static const NSTimeInterval duration = 0.10;

    [self enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        
        // Get its material
        SCNMaterial *material = child.geometry.firstMaterial;
        
        // Unhighlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:duration];
        
        material.diffuse.intensity = material.specular.intensity;
        
        [SCNTransaction commit];
    }];
    
    [self runAction:[SCNAction scaleBy:kScaleUp duration:duration]];
    
    [self controlEventOccured:ButtonNodeControlEventTouchUp];
}

#pragma mark - TARGET/SELECTOR HANDLING

- (void)addTarget:(id)target action:(SEL)selector forControlEvent:(ButtonNodeControlEvent)controlEvent {
    
    [self addTarget:target action:selector withObject:nil forControlEvent:controlEvent];
}

- (void)addTarget:(id)target action:(SEL)selector withObject:(id)object forControlEvent:(ButtonNodeControlEvent)controlEvent {
    
    //check whether selector is already saved, otherwise it will get called twice
    
    NSMutableDictionary *selectorDictionary = [NSMutableDictionary new];
    
    [selectorDictionary setObject:target forKey:@"target"];
    [selectorDictionary setObject:[NSValue valueWithPointer:selector] forKey:@"selector"];

    if (object) {
        
        [selectorDictionary setObject:object forKey:@"object"];
    }
    
    [selectorDictionary setObject:[NSNumber numberWithInt:controlEvent] forKey:@"controlEvent"];
    
    [selectorsArray addObject:selectorDictionary];
}

- (void)controlEventOccured:(ButtonNodeControlEvent)controlEvent {
    
    for (NSDictionary *selectorDictionary in selectorsArray) {
        
        if ([[selectorDictionary objectForKey:@"controlEvent"] intValue] == controlEvent) {
            
            id target = [selectorDictionary objectForKey:@"target"];
            
            SEL selector = [[selectorDictionary objectForKey:@"selector"] pointerValue];
            
            id object = [selectorDictionary objectForKey:@"object"];
            
            IMP imp = [target methodForSelector:selector];
            
            if (object) {
                
                void (*func)(id, SEL, id) = (void*)imp;
                func (target, selector, object);
            } else {
                
                void (*func)(id, SEL) = (void *)imp;
                func(target, selector);
            }
        }
    }
}

@end
