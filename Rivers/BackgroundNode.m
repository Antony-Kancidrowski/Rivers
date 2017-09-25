//
//  BackgroundNode.m
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "BackgroundNode.h"

#import "DebugOptions.h"

@interface BackgroundNode ()
{
    
}
@end


@implementation BackgroundNode

- (void)activate {
    
    NSNumber *show = [DebugOptions optionForKey:@"ShowBackgroundLayer"];
    
    [self setHidden:(!show.boolValue)];
    
    [super activate];
}

- (void)deactivate {
    
    [super deactivate];
}

@end
