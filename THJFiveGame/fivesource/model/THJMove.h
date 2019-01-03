//
//  THJMove.h
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, THJPlayerType) {
    THJPlayerTypeBlack,
    THJPlayerTypeWhite
};

typedef struct {
    int i;
    int j;
} THJPoint;

@interface THJMove : NSObject
@property (nonatomic, readonly) THJPlayerType playerType;
@property (nonatomic, readonly) THJPoint point;
- (instancetype)initWithTHJPlayer:(THJPlayerType)playerType amdPoint:(THJPoint)point;

@end

NS_ASSUME_NONNULL_END
