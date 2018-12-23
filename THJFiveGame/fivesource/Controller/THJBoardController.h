//
//  THJBoardController.h
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/23.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBoardView.h"
#import "GGPlayer.h"

typedef NS_ENUM(NSInteger, GGMode)
{
    GGModeSingle,
    GGModeDouble,
    GGModeLAN
};


NS_ASSUME_NONNULL_BEGIN

@interface THJBoardController : UIViewController<GGBoardViewDelegate>
@property (weak, nonatomic) IBOutlet GGBoardView *boardView;
@property (assign, nonatomic) enum GGMode gameMode;
@end

NS_ASSUME_NONNULL_END
