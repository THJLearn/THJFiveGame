//
//  THJBoard.m
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import "THJBoard.h"

@implementation THJBoard
- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self initBoard];
    }
    
    return self;
}

- (void)initBoard {
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            _grid[i][j] = THJPieceTypeBlank;
        }
    }
}

- (BOOL)isEmpty {
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            if (_grid[i][j] != THJPieceTypeBlank) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)canMoveAtPoint:(THJPoint)point {
    return _grid[point.i][point.j] == THJPieceTypeBlank;
}

- (void)makeMove:(THJMove *)move {
    THJPoint point = move.point;
    if ([self canMoveAtPoint:point]) {
        if (move.playerType == THJPlayerTypeBlack) {
            _grid[point.i][point.j] = THJPieceTypeBlack;
        } else {
            _grid[point.i][point.j] = THJPieceTypeWhite;
        }
    }
}

- (void)undoMove:(THJMove *)move {
    THJPoint point = move.point;
    _grid[point.i][point.j] = THJPieceTypeBlank;
}

- (BOOL)checkWinAtPoint:(THJPoint)point {
    int count = 1;
    int i = point.i;
    int j = point.j;
    
    // Horizontal
    for (j++; j < GRID_SIZE; j++) {
        if (_grid[i][j] == _grid[point.i][point.j]) {
            count++;
        } else {
            break;
        }
    }
    j = point.j;
    for (j--; j >= 0; j--) {
        if (_grid[i][j] == _grid[point.i][point.j]) {
            count++;
        } else {
            break;
        }
    }
    if (count >= 5) {
        return YES;
    } else {
        count = 1;
    }
    
    // Vertical
    i = point.i;
    j = point.j;
    for (i++; i < GRID_SIZE; i++) {
        if (_grid[i][j] == _grid[point.i][point.j]) {
            count++;
        } else {
            break;
        }
    }
    i = point.i;
    for (i--; i >= 0; i--) {
        if (_grid[i][j] == _grid[point.i][point.j]) {
            count++;
        } else {
            break;
        }
    }
    if (count >= 5) {
        return YES;
    } else {
        count = 1;
    }
    
    // Oblique up
    i = point.i + 1;
    j = point.j + 1;
    for (; i < GRID_SIZE && j < GRID_SIZE; i++, j++) {
        if (_grid[i][j] == _grid[point.i][point.j]) {
            count++;
        } else {
            break;
        }
    }
    i = point.i - 1;
    j = point.j - 1;
    for (; i >= 0 && j >= 0; i--, j--) {
        if (_grid[i][j] == _grid[point.i][point.j]) {
            count++;
        } else {
            break;
        }
    }
    if (count >= 5) {
        return YES;
    } else {
        count = 1;
    }
    
    // Oblique down
    i = point.i + 1;
    j = point.j - 1;
    for (; i < GRID_SIZE && j >= 0; i++, j--) {
        if (_grid[i][j] == _grid[point.i][point.j]) {
            count++;
        } else {
            break;
        }
    }
    i = point.i - 1;
    j = point.j + 1;
    for (; i >= 0 && j < GRID_SIZE; i--, j++) {
        if (_grid[i][j] == _grid[point.i][point.j]) {
            count++;
        } else {
            break;
        }
    }
    if (count >= 5) {
        return YES;
    } else {
        return NO;
    }
}

- (THJMove *)getBestMove{
    return nil;
}
@end
