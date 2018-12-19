//
//  ViewController.m
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/18.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import "ViewController.h"
#import "CheckerboardView.h"
#import "tool/THJAFNRequest.h"
#import "AppDelegate.h"
#import "HJNetFailView.h"
#import "THJLoadingView.h"

@interface ViewController ()
@property(nonatomic,strong)AppDelegate *mydelegate;
@property(nonatomic,strong)HJNetFailView * netFailView;
@property (nonatomic , strong) THJLoadingView * imageViewLoading;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.netFailView = [[HJNetFailView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    __weak ViewController * myself = self;
    [self.netFailView setSubViewsWithTapBlock:^{
        
        [myself testRequest];
        
    } andFailImage:@""];
    [self.view addSubview:self.netFailView];
    
    self.imageViewLoading = [[THJLoadingView alloc]initWithFrame:CGRectMake(0, HEIGHTNAV64, kScreenWidth, kScreenHeight-HEIGHTNAV64)];
    self.imageViewLoading.loadingImageStr = @"animationLoadingRenewal";
    [self.view addSubview:self.imageViewLoading];
    


}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self testRequest];
}
- (void)testRequest{
     [self.imageViewLoading startLoading];
    [THJAFNRequest requestGet:@"http://app.11qdcp.com/lottery/back/api.php?app_id=app1&type=ios&show_url=1" andSuccessBlock:^(id  _Nonnull json) {
        
         [self.imageViewLoading stopLoading];
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            if ([json[@"code"] intValue] == 200) {
                
                NSString * str = json[@"data"];
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                NSData *encodeData = [string dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:encodeData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:nil];
                NSString *update_url = KISDictionaryHaveKey(dic, @"update_url");
                NSString *is_update = KISDictionaryHaveKey(dic, @"is_update");
                NSString *is_wap = KISDictionaryHaveKey(dic, @"is_wap");
                NSString *wap_url = KISDictionaryHaveKey(dic, @"wap_url");
                
                if ([is_update isEqual:@"1"]&&(update_url.length>0)) {
                    [self.mydelegate toWebVC:update_url];
                }else if ([is_wap isEqual:@"1"]&&(wap_url.length>0)){
                    [self.mydelegate toWebVC:wap_url];
                }else{
                    [self.mydelegate toGame];
                }
                
                
            }else{
                
                [self.mydelegate toGame];
                
                
            }
        }
    } andfail:^(id  _Nonnull errJson) {
        [self.imageViewLoading stopLoading];
        [self.netFailView failViewHiddenWithArr:@[]];
    }];
}
@end
