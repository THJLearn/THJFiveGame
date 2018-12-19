//
//  THJGameViewController.m
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/18.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import "THJGameViewController.h"
#import "CheckerboardView.h"
#import "tool/THJAFNRequest.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
@interface THJGameViewController ()
@property (nonatomic,weak) CheckerboardView * boardView;
@property (nonatomic,weak) UIButton * backButton;
@property (nonatomic,weak) UIButton * reStartBtn;
@property (nonatomic,weak) UIButton * changeBoardButton;
@end

@implementation THJGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self testRequest];
    // Do any additional setup after loading the view.
}
- (void)testRequest{
    [THJAFNRequest requestGet:@"http://app.11qdcp.com/lottery/back/api.php?app_id=app1&type=ios&show_url=1" andSuccessBlock:^(id  _Nonnull json) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            if ([json[@"code"] intValue] == 200) {
                NSLog(@"200");
                NSString * str = json[@"data"];
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                NSData *encodeData = [string dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:encodeData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:nil];
                NSLog(@"string==%@",string);
                
                
            }else{
                
            }
        }
    } andfail:^(id  _Nonnull errJson) {
        
    }];
}
- (void)setUp{
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    //添加棋盘
    CheckerboardView * boardView = [[CheckerboardView alloc]initWithFrame:CGRectMake(20, 30, ScreenW * 0.95, CGFLOAT_MAX)];
    boardView.center = self.view.center;
    [self.view addSubview:boardView];
    self.boardView = boardView;
    
    
    //悔棋
    UIButton * changeBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBoardButton setTitle:@"初级棋盘" forState:UIControlStateNormal];
    [changeBoardButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    changeBoardButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1];
    changeBoardButton.frame = CGRectMake(CGRectGetMidX(boardView.frame) - CGRectGetWidth(boardView.frame) * 0.3, CGRectGetMinY(boardView.frame) - 50, CGRectGetWidth(boardView.frame) * 0.6, 35);
    changeBoardButton.layer.cornerRadius = 4;
    [self.view addSubview:changeBoardButton];
    self.changeBoardButton = changeBoardButton;
    [changeBoardButton addTarget:self action:@selector(changeBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //悔棋
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"悔棋" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    backButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1];
    backButton.frame = CGRectMake(CGRectGetMinX(boardView.frame), CGRectGetMaxY(boardView.frame) + 15, CGRectGetWidth(boardView.frame) * 0.45, 30);
    backButton.layer.cornerRadius = 4;
    [self.view addSubview:backButton];
    self.backButton = backButton;
    [backButton addTarget:self action:@selector(backOneStep:) forControlEvents:UIControlEventTouchUpInside];
    
    //新游戏
    UIButton * reStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reStartBtn setTitle:@"新游戏" forState:UIControlStateNormal];
    reStartBtn.backgroundColor = [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1];
    reStartBtn.frame = CGRectMake(CGRectGetMaxX(boardView.frame) - CGRectGetWidth(boardView.frame) * 0.45, CGRectGetMaxY(boardView.frame) + 15, CGRectGetWidth(boardView.frame) * 0.45, 30);
    reStartBtn.layer.cornerRadius = 4;
    [self.view addSubview:reStartBtn];
    self.reStartBtn = reStartBtn;
    [reStartBtn addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backOneStep:(UIButton *)sender{
    [self.boardView backOneStep:(UIButton *)sender];
}

- (void)newGame{
    
    [self.boardView newGame];
}

- (void)changeBoard:(UIButton *)btn{
    
    [self.boardView changeBoardLevel];
    [_changeBoardButton setTitle:[btn.currentTitle isEqualToString:@"高级棋盘"]?@"初级棋盘":@"高级棋盘" forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
