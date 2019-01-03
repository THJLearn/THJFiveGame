//
//  THJBoardView.h
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THJMove.h"
#import "THJPlayer.h"
NS_ASSUME_NONNULL_BEGIN



@protocol THJBoardViewDelegate;

@interface THJBoardView : UIView

@property (nonatomic, strong) id <THJBoardViewDelegate> delegate;

- (THJPoint)findPointWithLocation:(CGPoint)location;
- (void)insertPieceAtPoint:(THJPoint)point playerType:(THJPlayerType)playerType;
- (void)reset;
- (void)removeImageWithCount:(int)count;

@end

@protocol THJBoardViewDelegate <NSObject>

- (void)THJboardView:(THJBoardView *)boardView didTapOnPoint:(THJPoint)point;

@end

NS_ASSUME_NONNULL_END
