//
//  THJMenuContoller.m
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/23.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import "THJMenuContoller.h"
#import "THJBoardController.h"
#import "GGPlayer.h"
#import "THJSettingsViewController.h"
NSString * const MUSIC_NAME = @"music.mp3";
NSString * const MOVE_SOUND_NAME = @"move.wav";

@interface THJMenuContoller ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)btnSinglePlayer_TouchUp:(UIButton *)sender;
- (IBAction)btnDoublePlayer_TouchUp:(UIButton *)sender;
- (IBAction)btnSetting_TouchUp:(UIButton *)sender;
@end

@implementation THJMenuContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackgroundImage];
    [self initPlayers];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)initPlayers {
    _musicPlayer = [self playerWithFile:MUSIC_NAME];
    _musicPlayer.numberOfLoops = -1;
    
    _moveSoundPlayer = [self playerWithFile:MOVE_SOUND_NAME];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"music"] == 1) {
        [_musicPlayer play];
    }
}

- (AVAudioPlayer *)playerWithFile:(NSString *)file {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player prepareToPlay];
    
    return player;
}

- (void)setupBackgroundImage {
    self.backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImage.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.backgroundImage.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.backgroundImage.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.backgroundImage.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
}


- (IBAction)btnSinglePlayer_TouchUp:(UIButton *)sender {
    
    THJBoardController *boardController = [[THJBoardController alloc]init];
    boardController.gameMode = GGModeSingle;
    [self presentViewController:boardController animated:YES completion:^{
        
    }];
//    [self performSegueWithIdentifier:@"startGame" sender:sender];
}

- (IBAction)btnDoublePlayer_TouchUp:(UIButton *)sender {
    THJBoardController *boardController = [[THJBoardController alloc]init];
    boardController.gameMode = GGModeDouble;
    [self presentViewController:boardController animated:YES completion:^{
        
    }];
//    [self performSegueWithIdentifier:@"startGame" sender:sender];
}
- (IBAction)btnSetting_TouchUp:(UIButton *)sender {
    THJSettingsViewController * setting = [[THJSettingsViewController alloc]init];
    [self presentViewController:setting animated:YES completion:^{
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"startGame"]) {
        UIButton *button = sender;
        NSLog(@"%@", button.titleLabel.text);
        THJBoardController *boardController = segue.destinationViewController;
        if ([button.titleLabel.text isEqual: @"单人游戏"]) {
            boardController.gameMode = GGModeSingle;
        } else if ([button.titleLabel.text isEqual: @"双人游戏"]) {
            boardController.gameMode = GGModeDouble;
        } else if ([button.titleLabel.text isEqual: @"联机游戏"]) {
            boardController.gameMode = GGModeLAN;
        }
    }
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
