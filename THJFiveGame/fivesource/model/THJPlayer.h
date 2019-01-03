//
//  THJPlayer.h
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THJGreedyAI.h"
#import "THJMinimaxAI.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, THJDifficulty) {
    THJDifficultyEasy,
    THJDifficultyMedium,
    THJDifficultyHard
};

@interface THJPlayer : NSObject
- (instancetype)initWithPlayer:(THJPlayerType)playerType difficulty:(THJDifficulty)difficulty;
- (void)update:(THJMove *)move;
- (THJMove *)getMove;
- (void)regret:(THJMove *)move;
@end

NS_ASSUME_NONNULL_END
