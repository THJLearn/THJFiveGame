//
//  HJNetFailView.m
//  NewInsurance
//
//  Created by tianhj on 16/1/19.
//  Copyright © 2016年 ligx. All rights reserved.
//

#import "HJNetFailView.h"
@interface HJNetFailView ()
@property(nonatomic , strong)UIImageView * bgImageView ;
@end

@implementation HJNetFailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        bgImageView.image = [UIImage imageNamed:@"beijing"];
        bgImageView.backgroundColor = TBackGroundColor;
        bgImageView.userInteractionEnabled = YES;
        [self addSubview:bgImageView];
        _bgImageView = bgImageView;
    }
    return self;
}
-(void)setSubViewsWithTapBlock:(void(^)(void))tapBlock andFailImage:(NSString *)failImageStr{
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.bgImageView addGestureRecognizer:tapGes];
    self.tapBlock = tapBlock;
    
    UIImageView * bqImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 185 , 200)];
    bqImageView.image = [UIImage imageNamed:@"failOutTime"];
    bqImageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, kScreenHeight/2 -64);
    [self.bgImageView addSubview:bqImageView];
    self.hidden = YES;
    
}
- (void)tapAction:(UITapGestureRecognizer *)tapGes
{
    self.tapBlock();
}

- (void)failViewHiddenWithArr:(NSArray *)dataArr
{
    if (dataArr.count == 0) {
        self.hidden = NO;
    }else{
        self.hidden = YES;
    }
}


@end
