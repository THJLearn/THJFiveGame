//
//  THJPlayer.m
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import "THJPlayer.h"
#import "THJMove.h"

@interface THJPlayer ()
{
    THJPlayerType _playerType;
    THJBoard *_board;
}

@end

@implementation THJPlayer

- (instancetype)initWithPlayer:(THJPlayerType)playerType difficulty:(THJDifficulty)difficulty {
    self = [super init];
    
    if (self) {
        _playerType = playerType;
        
        switch (difficulty) {
                case THJDifficultyEasy:
                _board = [[THJGreedyAI alloc] initWithPlayer:playerType];
                break;
                case THJDifficultyMedium:
                _board = [[THJMinimaxAI alloc] initWithPlayer:playerType];
                [(THJMinimaxAI *)_board setDepth:6];
                break;
                case THJDifficultyHard:
                _board = [[THJMinimaxAI alloc] initWithPlayer:playerType];
                [(THJMinimaxAI *)_board setDepth:8];
                break;
        }
    }
    
    return self;
}

- (void)update:(THJMove *)move {
    if (move != nil) {
        [_board makeMove:move];
    }
}

- (void)regret:(THJMove *)move {
    if (move != nil) {
        [_board undoMove:move];
    }
}

- (THJMove *)getMove {
    if ([_board isEmpty]) {
        THJPoint point;
        point.i = 7;
        point.j = 7;
         THJMove *move = [[THJMove alloc] initWithTHJPlayer:_playerType amdPoint:point];
        [self update:move];
        return move;
    } else {
        THJMove *move = [_board getBestMove];
        return move;
    }
}
@end
