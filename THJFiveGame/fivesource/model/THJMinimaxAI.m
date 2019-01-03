//
//  THJMinmaxAI.m
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import "THJMinimaxAI.h"

typedef NS_ENUM(NSInteger, THJTupleType)
{
    THJTupleTypeLiveOne = 10,
    THJTupleTypeDeadOne = 1,
    THJTupleTypeLiveTwo = 100,
    THJTupleTypeDeadTwo = 10,
    THJTupleTypeLiveThree = 1000,
    THJTupleTypeDeadThree = 100,
    THJTupleTypeLiveFour = 10000,
    THJTupleTypeDeadFour = 1000,
    THJTupleTypeFive = 100000
};

typedef struct {
    THJPoint point;
    int score;
} THJPointHelper;

@interface THJMinimaxAI()
{
    THJPlayerType _playerType;
    THJMove *_bestMove;
    int _maxDepth;
}

@end

@implementation THJMinimaxAI

- (instancetype)initWithPlayer:(THJPlayerType)playerType {
    self = [super init];
    
    if (self) {
        _playerType = playerType;
    }
    
    return self;
}

- (void)setDepth:(int)depth {
    _maxDepth = depth;
}

- (THJMove *)getBestMove {
    int score;
    
    // iterative deepening
    for (int deep = 2; deep <= _maxDepth; deep += 2) {
        score = [self MinimaxWithDepth:deep who:1 alpha:-[self maxEvaluateValue] beta:[self maxEvaluateValue]];
        if (score >= THJTupleTypeLiveFour) {
            [self makeMove:_bestMove];
            return _bestMove;
        }
    }
    
    [self makeMove:_bestMove];
    return _bestMove;
}

- (int)MinimaxWithDepth:(int)depth who:(int)who alpha:(int)alpha beta:(int)beta {
    if (depth == 0 || [self finished]) {
        return who * [self evaluate];
    }
    
    int score;
    THJMove *bestMove;
    NSMutableArray *moves = [self getPossibleMoves];
    
    // moves are empty???
    
    if (who > 0) {
        for (THJMove *move in moves) {
            [self makeMove:move];
            [self switchPlayer];
            score = [self MinimaxWithDepth:depth - 1 who:-who alpha:alpha beta:beta];
            [self switchPlayer];
            [self undoMove:move];
            
            if (score > alpha) {
                alpha = score;
                bestMove = move;
                if (alpha >= beta) {
                    break;
                }
            }
        }
        
        _bestMove = bestMove;
        
        return alpha;
    } else {
        for (THJMove *move in moves) {
            [self makeMove:move];
            [self switchPlayer];
            score = [self MinimaxWithDepth:depth - 1 who:-who alpha:alpha beta:beta];
            [self switchPlayer];
            [self undoMove:move];
            
            if (score < beta) {
                beta = score;
                if (alpha >= beta) {
                    break;
                }
            }
        }
        
        return beta;
    }
}

- (NSMutableArray *)getPossibleMoves {
    NSMutableArray *moves = [NSMutableArray array];
    THJPointHelper points[GRID_SIZE * GRID_SIZE];
    int index = 0;
    
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            THJPoint point;
            point.i = i;
            point.j = j;
            
            if ([self isNeighbour:point]) {
                THJPointHelper pointHelper;
                pointHelper.point = point;
                pointHelper.score = [self getScoreWithPoint:point];
                points[index] = pointHelper;
                index++;
            }
        }
    }
    
    // sort the points
    for (int i = 1; i < index; i++) {
        int j = i - 1;
        THJPointHelper temp = points[i];
        while (j >= 0 && temp.score > points[j].score) {
            points[j + 1] = points[j];
            j--;
        }
        points[j + 1] = temp;
    }
    
    // only return the first 10 points
    for (int i = 0; i < 10; i++) {
         THJMove *move = [[THJMove alloc] initWithTHJPlayer:_playerType amdPoint:points[i].point];
        [moves addObject:move];
    }
    
    return moves;
}

- (BOOL)isNeighbour:(THJPoint)point {
    int i = point.i;
    int j = point.j;
    
    if (_grid[i][j] == THJPieceTypeBlank) {
        for (int m = i - 2; m <= i + 2; m++) {
            for (int n = j - 2; n <= j + 2; n++) {
                if (m >= 0 && m < GRID_SIZE && n >= 0 && n < GRID_SIZE) {
                    if (_grid[m][n] != THJPieceTypeBlank) {
                        return YES;
                    }
                }
            }
        }
    }
    
    return NO;
}

- (BOOL)finished {
    int blackScore = [self evaluateWithPieceType:THJPieceTypeBlack];
    int whiteScore = [self evaluateWithPieceType:THJPieceTypeWhite];
    
    if (blackScore >= THJTupleTypeFive || whiteScore >= THJTupleTypeFive) {
        return YES;
    }
    
    return NO;
}

- (int)evaluate {
    int blackScore = [self evaluateWithPieceType:THJPieceTypeBlack];
    int whiteScore = [self evaluateWithPieceType:THJPieceTypeWhite];
    
    if (_playerType == THJPlayerTypeBlack) {
        return blackScore - whiteScore;
    } else {
        return whiteScore - blackScore;
    }
}

- (int)evaluateWithPieceType:(THJPieceType)pieceType {
    int score = 0;
    
    // Horizontal
    for (int line = 0; line < GRID_SIZE; line++) {
        for (int index = 0; index < GRID_SIZE; index++) {
            if (_grid[line][index] == pieceType) {
                int block = 0;
                int piece = 1;
                
                // left
                if (index == 0 || _grid[line][index - 1] != THJPieceTypeBlank) {
                    block++;
                }
                
                // pieceNum
                for (index++; index < GRID_SIZE && _grid[line][index] == pieceType; index++) {
                    piece++;
                }
                
                // right
                if (index == GRID_SIZE || _grid[line][index] != THJPieceTypeBlank) {
                    block++;
                }
                
                score += [self evaluateWithBlock:block pieceNum:piece];
            }
        }
    }
    
    // Vertical
    for (int line = 0; line < GRID_SIZE; line++) {
        for (int index = 0; index < GRID_SIZE; index++) {
            if (_grid[index][line] == pieceType) {
                int block = 0;
                int piece = 1;
                
                // left
                if (index == 0 || _grid[index - 1][line] != THJPieceTypeBlank) {
                    block++;
                }
                
                // pieceNum
                for (index++; index < GRID_SIZE && _grid[index][line] == pieceType; index++) {
                    piece++;
                }
                
                // right
                if (index == GRID_SIZE || _grid[index][line] != THJPieceTypeBlank) {
                    block++;
                }
                
                score += [self evaluateWithBlock:block pieceNum:piece];
            }
        }
    }
    
    // Oblique up
    for (int line = 0; line < 21; line++) {
        int lineLength = GRID_SIZE - abs(line - 10);
        
        if (line <= 10) {
            for (int index = 0; index < lineLength; index++) {
                if (_grid[index][GRID_SIZE - lineLength + index] == pieceType) {
                    int block = 0;
                    int piece = 1;
                    
                    // left
                    if (index == 0 || _grid[index - 1][GRID_SIZE - lineLength + index - 1] != THJPieceTypeBlank) {
                        block++;
                    }
                    
                    // pieceNum
                    for (index++; index < lineLength && _grid[index][GRID_SIZE - lineLength + index] == pieceType; index++) {
                        piece++;
                    }
                    
                    // right
                    if (index == lineLength || _grid[index][GRID_SIZE - lineLength + index] != THJPieceTypeBlank) {
                        block++;
                    }
                    
                    score += [self evaluateWithBlock:block pieceNum:piece];
                }
            }
        } else {
            for (int index = 0; index < lineLength; index++) {
                if (_grid[GRID_SIZE - lineLength + index][index] == pieceType) {
                    int block = 0;
                    int piece = 1;
                    
                    // left
                    if (index == 0 || _grid[GRID_SIZE - lineLength + index - 1][index - 1] != THJPieceTypeBlank) {
                        block++;
                    }
                    
                    // pieceNum
                    for (index++; index < lineLength && _grid[GRID_SIZE - lineLength + index][index] == pieceType; index++) {
                        piece++;
                    }
                    
                    // right
                    if (index == lineLength || _grid[GRID_SIZE - lineLength + index][index] != THJPieceTypeBlank) {
                        block++;
                    }
                    
                    score += [self evaluateWithBlock:block pieceNum:piece];
                }
            }
        }
    }
    
    // Oblique down
    for (int line = 0; line < 21; line++) {
        int lineLength = GRID_SIZE - abs(line - 10);
        
        if (line <= 10) {
            for (int index = 0; index < lineLength; index++) {
                if (_grid[index][lineLength - 1 - index] == pieceType) {
                    int block = 0;
                    int piece = 1;
                    
                    // left
                    if (index == 0 || _grid[index - 1][lineLength - 1 - (index - 1)] != THJPieceTypeBlank) {
                        block++;
                    }
                    
                    // pieceNum
                    for (index++; index < lineLength && _grid[index][lineLength - 1 - index] == pieceType; index++) {
                        piece++;
                    }
                    
                    // right
                    if (index == lineLength || _grid[index][lineLength - 1 - index] != THJPieceTypeBlank) {
                        block++;
                    }
                    
                    score += [self evaluateWithBlock:block pieceNum:piece];
                }
            }
        } else {
            for (int index = 0; index < lineLength; index++) {
                if (_grid[GRID_SIZE - lineLength + index][GRID_SIZE - 1 - index] == pieceType) {
                    int block = 0;
                    int piece = 1;
                    
                    // left
                    if (index == 0 || _grid[GRID_SIZE - lineLength + index - 1][GRID_SIZE - 1 - (index - 1)] != THJPieceTypeBlank) {
                        block++;
                    }
                    
                    // pieceNum
                    for (index++; index < lineLength && _grid[GRID_SIZE - lineLength + index][GRID_SIZE - 1 - index] == pieceType; index++) {
                        piece++;
                    }
                    
                    // right
                    if (index == lineLength || _grid[GRID_SIZE - lineLength + index][GRID_SIZE - 1 - index] != THJPieceTypeBlank) {
                        block++;
                    }
                    
                    score += [self evaluateWithBlock:block pieceNum:piece];
                }
            }
        }
    }
    
    return score;
}

- (int)evaluateWithBlock:(int)block pieceNum:(int)piece {
    if (block == 0) {
        switch (piece) {
                case 1:
                return THJTupleTypeLiveOne;
                case 2:
                return THJTupleTypeLiveTwo;
                case 3:
                return THJTupleTypeLiveThree;
                case 4:
                return THJTupleTypeLiveFour;
            default:
                return THJTupleTypeFive;
        }
    } else if (block == 1) {
        switch (piece) {
                case 1:
                return THJTupleTypeDeadOne;
                case 2:
                return THJTupleTypeDeadTwo;
                case 3:
                return THJTupleTypeDeadThree;
                case 4:
                return THJTupleTypeDeadFour;
            default:
                return THJTupleTypeFive;
        }
    } else {
        if (piece >= 5) {
            return THJTupleTypeFive;
        } else {
            return 0;
        }
    }
}

- (int)maxEvaluateValue {
    return INT_MAX;
}

- (void)switchPlayer {
    if (_playerType == THJPlayerTypeBlack) {
        _playerType = THJPlayerTypeWhite;
    } else {
        _playerType = THJPlayerTypeBlack;
    }
}

@end

