//
//  THJGreedyAI.m
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import "THJGreedyAI.h"
typedef NS_ENUM(NSInteger, THJTupleType)
{
    THJTupleTypeBlank,
    THJTupleTypeB,
    THJTupleTypeBB,
    THJTupleTypeBBB,
    THJTupleTypeBBBB,
    THJTupleTypeW,
    THJTupleTypeWW,
    THJTupleTypeWWW,
    THJTupleTypeWWWW,
    THJTupleTypePolluted
};

@interface THJGreedyAI()
{
    THJPlayerType _playerType;
}

@end

@implementation THJGreedyAI

- (instancetype)initWithPlayer:(THJPlayerType)playerType {
    self = [super init];
    
    if (self) {
        _playerType = playerType;
    }
    
    return self;
}

- (THJMove *)getBestMove {
    int maxScore = 0;
    THJPoint bestPoint;
    
    int index = 0;
    THJPoint bestPoints[GRID_SIZE * GRID_SIZE];
    
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            if (_grid[i][j] == THJPieceTypeBlank) {
                THJPoint point;
                point.i = i;
                point.j = j;
                
                int score = [self getScoreWithPoint:point];
                if (score == maxScore) {
                    bestPoints[index] = point;
                    index++;
                } else if (score > maxScore) {
                    maxScore = score;
                    index = 0;
                    bestPoints[index] = point;
                    index++;
                }
            }
        }
    }
    
    bestPoint = bestPoints[arc4random_uniform(index)];
    
    THJMove *bestMove = [[THJMove alloc] initWithTHJPlayer:_playerType amdPoint:bestPoint];
    [self makeMove:bestMove];
    
    return bestMove;
}

- (int)getScoreWithPoint:(THJPoint)point {
    int score = 0;
    int i = point.i;
    int j = point.j;
    
    // Horizontal
    for (; i > point.i - 5; i--) {
        if (i >= 0 && i + 4 < GRID_SIZE) {
            int m = i;
            int n = j;
            int black = 0;
            int white = 0;
            for (; m < i + 5; m++) {
                if (_grid[m][n] == THJPieceTypeBlack) {
                    black++;
                }
                if (_grid[m][n] == THJPieceTypeWhite) {
                    white++;
                }
            }
            score += [self evaluateWithTuple:[self getTupleTypeWithBlackNum:black whiteNum:white]];
        }
    }
    
    // Vertical
    i = point.i;
    for (; j > point.j - 5; j--) {
        if (j >= 0 && j + 4 < GRID_SIZE) {
            int m = i;
            int n = j;
            int black = 0;
            int white = 0;
            for (; n < j + 5; n++) {
                if (_grid[m][n] == THJPieceTypeBlack) {
                    black++;
                }
                if (_grid[m][n] == THJPieceTypeWhite) {
                    white++;
                }
            }
            score += [self evaluateWithTuple:[self getTupleTypeWithBlackNum:black whiteNum:white]];
        }
    }
    
    // Oblique up
    i = point.i;
    j = point.j;
    for (; i > point.i - 5 && j > point.j - 5; i--, j--) {
        if (i >= 0 && j >= 0 && i + 4 < GRID_SIZE && j + 4 < GRID_SIZE) {
            int m = i;
            int n = j;
            int black = 0;
            int white = 0;
            for (; m < i + 5 && n < j + 5; m++, n++) {
                if (_grid[m][n] == THJPieceTypeBlack) {
                    black++;
                }
                if (_grid[m][n] == THJPieceTypeWhite) {
                    white++;
                }
            }
            score += [self evaluateWithTuple:[self getTupleTypeWithBlackNum:black whiteNum:white]];
        }
    }
    
    // Oblique down
    i = point.i;
    j = point.j;
    for (; i > point.i - 5 && j < point.j + 5; i--, j++) {
        if (i >= 0 && j < GRID_SIZE && i + 4 < GRID_SIZE && j - 4 >= 0) {
            int m = i;
            int n = j;
            int black = 0;
            int white = 0;
            for (; m < i + 5 && n > j - 5; m++, n--) {
                if (_grid[m][n] == THJPieceTypeBlack) {
                    black++;
                }
                if (_grid[m][n] == THJPieceTypeWhite) {
                    white++;
                }
            }
            score += [self evaluateWithTuple:[self getTupleTypeWithBlackNum:black whiteNum:white]];
        }
    }
    
    return score;
}

- (THJTupleType)getTupleTypeWithBlackNum:(int)black whiteNum:(int)white {
    if (black + white == 0) {
        return THJTupleTypeBlank;
    }
    if (black == 1 && white == 0) {
        return THJTupleTypeB;
    }
    if (black == 2 && white == 0) {
        return THJTupleTypeBB;
    }
    if (black == 3 && white == 0) {
        return THJTupleTypeBBB;
    }
    if (black == 4 && white == 0) {
        return THJTupleTypeBBBB;
    }
    if (black == 0 && white == 1) {
        return THJTupleTypeW;
    }
    if (black == 0 && white == 2) {
        return THJTupleTypeWW;
    }
    if (black == 0 && white == 3) {
        return THJTupleTypeWWW;
    }
    if (black == 0 && white == 4) {
        return THJTupleTypeWWWW;
    } else {
        return THJTupleTypePolluted;
    }
}

- (int)evaluateWithTuple:(THJTupleType)tupleType {
    if (_playerType == THJPlayerTypeBlack) {
        switch (tupleType) {
                case THJTupleTypeBlank:
                return 7;
                case THJTupleTypeB:
                return 35;
                case THJTupleTypeBB:
                return 800;
                case THJTupleTypeBBB:
                return 15000;
                case THJTupleTypeBBBB:
                return 800000;
                case THJTupleTypeW:
                return 15;
                case THJTupleTypeWW:
                return 400;
                case THJTupleTypeWWW:
                return 1800;
                case THJTupleTypeWWWW:
                return 100000;
                case THJTupleTypePolluted:
                return 0;
        }
    } else {
        switch (tupleType) {
                case THJTupleTypeBlank:
                return 7;
                case THJTupleTypeB:
                return 15;
                case THJTupleTypeBB:
                return 400;
                case THJTupleTypeBBB:
                return 1800;
                case THJTupleTypeBBBB:
                return 100000;
                case THJTupleTypeW:
                return 35;
                case THJTupleTypeWW:
                return 800;
                case THJTupleTypeWWW:
                return 15000;
                case THJTupleTypeWWWW:
                return 800000;
                case THJTupleTypePolluted:
                return 0;
        }
    }
}

@end
