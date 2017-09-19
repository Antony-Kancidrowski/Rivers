//
//  ThemePanelManagerNode.h
//  Rivers
//
//  Created by Antony Kancidrowski on 19/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "ActorNode.h"

@interface ThemePanelManagerNode : ActorNode

- (instancetype)init;

- (void)activate;
- (void)deactivate;

- (void)showFirst;

- (void)moveToCurrentTheme;

@end
