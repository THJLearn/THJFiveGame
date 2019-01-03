//
//  THJGreedyAI.h
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import "THJBoard.h"

NS_ASSUME_NONNULL_BEGIN

@interface THJGreedyAI : THJBoard
- (instancetype)initWithPlayer:(THJPlayerType)playerType;
- (int)getScoreWithPoint:(THJPoint)point;
@end

NS_ASSUME_NONNULL_END
