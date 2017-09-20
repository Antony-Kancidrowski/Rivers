//
//  MainMenuViewController.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameCenterManager.h"
#import "MainMenuNode.h"

#import "RiversViewController.h"

@interface MainMenuViewController : RiversViewController <GKGameCenterControllerDelegate, MainMenuDelegate>

@end
