//
//  THJBoardController.h
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/23.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THJBoardView.h"
#import "THJPlayer.h"

typedef NS_ENUM(NSInteger, THJMode)
{
    THJModeSingle,
    THJModeDouble,
    THJModeLAN
};


NS_ASSUME_NONNULL_BEGIN

@interface THJBoardController : UIViewController<THJBoardViewDelegate>
@property (weak, nonatomic) IBOutlet THJBoardView *boardView;
@property (assign, nonatomic) enum THJMode gameMode;
@end

NS_ASSUME_NONNULL_END
