//
//  THJLoadingView.m
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/19.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import "THJLoadingView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface THJLoadingView()
{
    NSData * loadingData;
}
@property (nonatomic , strong) FLAnimatedImageView * imageViewLoading;

@end


@implementation THJLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageViewLoading = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        self.backgroundColor = UIColorFromRGBA(0xffffff, 1);
        self.imageViewLoading.centerX = self.centerX;
        self.imageViewLoading.centerY = self.height/2;
        [self addSubview:self.imageViewLoading];
    }
    return self;
}
-(void)startLoading{
    
    self.hidden = NO;
    self.imageViewLoading.animatedImage = [[FLAnimatedImage alloc]initWithAnimatedGIFData:loadingData];
}
-(void)stopLoading{
    self.hidden = YES;
    self.imageViewLoading.animatedImage = [[FLAnimatedImage alloc]initWithAnimatedGIFData:nil];
}
-(void)setLoadingImageStr:(NSString *)loadingImageStr{
    _loadingImageStr = loadingImageStr;
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:loadingImageStr
                                                          ofType:@"gif"];
    loadingData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:htmlPath] options:0 error:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
