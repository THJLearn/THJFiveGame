//
//  THJBoard.h
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THJMove.h"


NS_ASSUME_NONNULL_BEGIN
static int const GRID_SIZE = 15;

typedef NS_ENUM(NSInteger, THJPieceType) {
    THJPieceTypeBlank,
    THJPieceTypeBlack,
    THJPieceTypeWhite
};

@interface THJBoard : NSObject
{
@protected
    THJPieceType _grid[GRID_SIZE][GRID_SIZE];
}

- (instancetype)init;
- (void)initBoard;
- (BOOL)isEmpty;
- (BOOL)canMoveAtPoint:(THJPoint)point;
- (void)makeMove:(THJMove *)move;
- (void)undoMove:(THJMove *)move;
- (BOOL)checkWinAtPoint:(THJPoint)point;

- (THJMove *)getBestMove;

@end

NS_ASSUME_NONNULL_END
