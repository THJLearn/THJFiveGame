//
//  HJNetFailView.h
//  NewInsurance
//
//  Created by tianhj on 16/1/19.
//  Copyright © 2016年 ligx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJNetFailView : UIView
@property (nonatomic ,copy) void(^tapBlock)(void);

-(void)setSubViewsWithTapBlock:(void(^)(void))tapBlock andFailImage:(NSString *)failImageStr;
- (void)failViewHiddenWithArr:(NSArray *)dataArr;
@end
