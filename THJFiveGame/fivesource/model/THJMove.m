//
//  THJMove.m
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import "THJMove.h"

@implementation THJMove
- (instancetype)initWithTHJPlayer:(THJPlayerType)playerType amdPoint:(THJPoint)point {
    self = [super init];
    
    if (self) {
        _playerType = playerType;
        _point = point;
    }
    
    return self;
}
@end
