//
//  THJLoadingView.h
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/19.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THJLoadingView : UIView
@property (nonatomic , copy)NSString * loadingImageStr;
-(void)startLoading;
-(void)stopLoading;
@end

NS_ASSUME_NONNULL_END
