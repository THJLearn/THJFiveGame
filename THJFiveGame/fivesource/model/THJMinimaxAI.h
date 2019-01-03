//
//  THJMinmaxAI.h
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import "THJGreedyAI.h"

NS_ASSUME_NONNULL_BEGIN

@interface THJMinimaxAI : THJGreedyAI
- (instancetype)initWithPlayer:(THJPlayerType)playerType;
- (void)setDepth:(int)depth;
@end

NS_ASSUME_NONNULL_END
