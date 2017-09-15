//
//  Types.h
//  Rivers
//
//  Created by Antony Kancidrowski on 13/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef Rivers_Types_h
#define Rivers_Types_h

typedef unsigned char	gsUBYTE;
typedef signed char		gsBYTE;

typedef unsigned short	gsUWORD;
typedef signed short	gsWORD;

typedef unsigned int	gsUDWORD;
typedef signed int		gsDWORD;

//-------------------------------------------------------------

typedef NS_ENUM(gsUDWORD, NodeDirection) {
    
    MOVES_LEFT = 1,           // 1
    MOVES_RIGHT = 2,          // 2
    MOVES_UP = 4,             // 4
    MOVES_DOWN = 8,           // 8
};

//-------------------------------------------------------------

#ifdef __BLOCKS__
typedef void (^dispatch_block_float_t)(CGFloat value);
#endif

#define RANDOM_SEED() srandom((unsigned int)time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__ + 1) - (__MIN__)))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

#define DEG_TO_RAD(__DEG__) (__DEG__ * M_PI / 180)

#define kFrameInterval 1

#endif /* Rivers_Types_h */
