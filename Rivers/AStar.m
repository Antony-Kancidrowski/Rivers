//
//  AStar.m
//  Rivers
//
//  Created by Antony Kancidrowski on 18/09/2017.
//  Copyright © 2017 Cidrosoft. All rights reserved.
//

#import "AStar.h"

#import "MathHelper.h"
#import "Types.h"


#define MAP_WIDTH   40
#define MAP_HEIGHT  40
#define MAP_OFFSETX 20
#define MAP_OFFSETY 50

@interface AStar ()
{
    NSInteger mapArray[MAP_WIDTH][MAP_HEIGHT];
    NSInteger gArray[MAP_WIDTH][MAP_HEIGHT];
    
    NSMutableArray *listPoints;
    
    AStarPoint currentPoint;
    AStarPoint startPoint;
    AStarPoint endPoint;
    
    BOOL diagonalsAuthorized;
}

@end

@implementation AStar

- (instancetype)initWithSize:(CGSize)size {
    
    self = [super init];
    
    if (self != nil)
    {
        listPoints = [[NSMutableArray alloc] init];
        
        diagonalsAuthorized = NO;
        
        [self generateMap];
    }
    
    return self;
}

- (void)generateMap {
    
    startPoint.x = rand()%MAP_WIDTH;
    startPoint.y = rand()%MAP_HEIGHT;
    endPoint.x = rand()%MAP_WIDTH;
    endPoint.y = rand()%MAP_HEIGHT;
    
    for (int x = 0; x < MAP_WIDTH; x++) {
        
        for (int y = 0; y < MAP_HEIGHT; y++) {
            
            if(startPoint.x == x && startPoint.y == y)
            {
                mapArray[x][y] = ASTAR_MAP_START;
            }
            else if(endPoint.x == x && endPoint.y == y)
            {
                mapArray[x][y] = ASTAR_MAP_END;
            }
            else if (rand()%100 < 20)
            {
                mapArray[x][y] = ASTAR_MAP_BLOCK;
            }
            else
            {
                mapArray[x][y] = ASTAR_MAP_EMPTY;
            }
            gArray[x][y] = -1;
        }
    }
}

- (void)drawMap {
    
//    for (UIView *view in self.view.subviews) {
//        if(view.tag == 777)
//        {
//            [view removeFromSuperview];
//        }
//    }
//    
//    NSString *name = [[NSString alloc] init];
//    
//    for (int x = 0; x < MAP_WIDTH; x++) {
//        for (int y = 0; y < MAP_HEIGHT; y++) {
//            
//            switch (mapArray[x][y]) {
//                case MAP_START:
//                    name = @"start";
//                    break;
//                case MAP_END:
//                    name = @"end";
//                    break;
//                case MAP_BLOCK:
//                    name = @"invalid";
//                    break;
//                case MAP_EMPTY:
//                    name = @"valid";
//                    break;
//                default:
//                    break;
//            }
//            
//            UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]]];
//            [tmp setFrame:CGRectMake(x*7+MAP_OFFSETX, y*7+MAP_OFFSETY, 6, 6)];
//            tmp.tag = 777;
//            [self.view addSubview:tmp];
//        }
//    }
}

- (void)calculateBestPath {
    
    currentPoint.x = startPoint.x;
    currentPoint.y = startPoint.y;
    currentPoint.g = 0;
    currentPoint.f = 0;
    
    gArray[currentPoint.x][currentPoint.y] = 0;
    
    while (currentPoint.x != endPoint.x ||
           currentPoint.y != endPoint.y
           ) {
        
        if(currentPoint.g <= gArray[currentPoint.x][currentPoint.y])
        {
            AStarPoint neighbour;
            
            if (diagonalsAuthorized) {
                // déplacement sur x
                for(int i = -1; i < 2; i++) {
                    // déplacement sur y
                    for(int j = -1; j < 2; j++) {
                        // on ne fait pas sur le même point
                        if(i != 0 || j != 0) {
                            neighbour.x = currentPoint.x+i;
                            neighbour.y = currentPoint.y+j;
                            // bords de la map
                            if( neighbour.x >= 0 && neighbour.x < MAP_WIDTH &&
                               neighbour.y >= 0 && neighbour.y < MAP_HEIGHT &&
                               // obstacle
                               mapArray[neighbour.x][neighbour.y] != ASTAR_MAP_BLOCK) {
                                neighbour.f = currentPoint.g + 1 + Manhattan(neighbour, endPoint);
                                if (gArray[neighbour.x][neighbour.y] == -1 ||
                                    gArray[neighbour.x][neighbour.y] > (currentPoint.g + 1)
                                    ) {
                                    gArray[neighbour.x][neighbour.y] = currentPoint.g + 1;
                                    neighbour.g = currentPoint.g + 1;
                                    
                                    [listPoints addObject:[NSValue value:&neighbour withObjCType:@encode(AStarPoint)]];
                                }
                            }
                        }
                    }
                }
            } else {
                // déplacement sur x
                for(int i = -1; i < 2; i++) {
                    // déplacement sur y
                    for(int j = -1; j < 2; j++) {
                        // on ne fait pas sur le même point
                        if((i != 0 || j != 0) &&
                           (i != -1 || j != -1) &&
                           (i != -1 || j != 1) &&
                           (i != 1 || j != -1) &&
                           (i != 1 || j != 1)) {
                            neighbour.x = currentPoint.x+i;
                            neighbour.y = currentPoint.y+j;
                            // bords de la map
                            if( neighbour.x >= 0 && neighbour.x < MAP_WIDTH &&
                               neighbour.y >= 0 && neighbour.y < MAP_HEIGHT &&
                               // obstacle
                               mapArray[neighbour.x][neighbour.y] != ASTAR_MAP_BLOCK) {
                                neighbour.f = currentPoint.g + 1 + Manhattan(neighbour, endPoint);
                                if (gArray[neighbour.x][neighbour.y] == -1 ||
                                    gArray[neighbour.x][neighbour.y] > (currentPoint.g + 1)
                                    ) {
                                    gArray[neighbour.x][neighbour.y] = currentPoint.g + 1;
                                    neighbour.g = currentPoint.g + 1;
                                    
                                    [listPoints addObject:[NSValue value:&neighbour withObjCType:@encode(AStarPoint)]];
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if([listPoints count] > 0) {
            AStarPoint point;
            
            [[listPoints objectAtIndex:0] getValue:&point];
            currentPoint = point;
            
            for (int index = 0; index < [listPoints count]; index++) {
                AStarPoint tmpPoint;
                [[listPoints objectAtIndex:index] getValue:&tmpPoint];
                
                if(currentPoint.f > tmpPoint.f)
                {
                    currentPoint = tmpPoint;
                }
            }
            
            [listPoints removeObject:[NSValue value:&currentPoint withObjCType:@encode(AStarPoint)]];
        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Can't find a way here, sorry !" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
//            [alert show];
            return;
        }
    }
    
//    [calculate setEnabled:NO];
//    [calculate setAlpha:0.5];
//    [diagonalsAuthorized setEnabled:NO];
//    [calculate setAlpha:0.5];
//    [result setText:[NSString stringWithFormat:@"The shortest path between G and B measures %ld.", (long)gArray[endPoint.x][endPoint.y]]];
    
    [self drawPathOnMap];
}

- (void)drawPathOnMap {
    
    AStarPoint current;
    AStarPoint neighbour;
    BOOL next;
    
    current = endPoint;
    
    for (int g = (int)gArray[endPoint.x][endPoint.y]; g > 0; g--) {
        
        next = NO;
        // déplacement sur x
        for(int i = -1; i < 2; i++) {
            // déplacement sur y
            for(int j = -1; j < 2; j++) {
                // on ne fait pas sur le même point
                if((i != 0 || j != 0) && !next) {
                    neighbour.x = current.x+i;
                    neighbour.y = current.y+j;
                    neighbour.g = (int)gArray[current.x+i][current.y+j];
                    if( neighbour.g == g-1 )
                    {
//                        UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"going.png"]];
//                        [tmp setFrame:CGRectMake(voisin.x*7+MAP_OFFSETX, voisin.y*7+MAP_OFFSETY, 6, 6)];
//                        tmp.tag = 777;
//                        [self.view addSubview:tmp];
                        current = neighbour;
                        next = YES;
                    }
                }
            }
        }
    }
    
//    UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start.png"]];
//    [tmp setFrame:CGRectMake(startPoint.x*7+MAP_OFFSETX, startPoint.y*7+MAP_OFFSETY, 6, 6)];
//    tmp.tag = 777;
//    [self.view addSubview:tmp];
//    
//    tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"end.png"]];
//    [tmp setFrame:CGRectMake(endPoint.x*7+MAP_OFFSETX, endPoint.y*7+MAP_OFFSETY, 6, 6)];
//    tmp.tag = 777;
//    [self.view addSubview:tmp];
}

@end
