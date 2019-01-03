//
//  THJSettingsViewController.m
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/23.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import "THJSettingsViewController.h"
#import "THJMenuContoller.h"
@interface THJSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentDifficulty;
@property (weak, nonatomic) IBOutlet UISwitch *thjswitchSound_setting;
@property (weak, nonatomic) IBOutlet UISwitch *thjswitchMusic_setting;
@end

@implementation THJSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [_segmentDifficulty setSelectedSegmentIndex:[defaults integerForKey:@"difficulty"]];
    [_thjswitchSound_setting setOn:[defaults integerForKey:@"sound"]];
    [_thjswitchMusic_setting setOn:[defaults integerForKey:@"musicfive"]];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)segementDifficulty_ValueChanged:(UISegmentedControl *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sender.selectedSegmentIndex forKey:@"difficulty"];
    [defaults synchronize];
}

- (IBAction)thjswitchMusic_settingthj_faiveValueChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:@(sender.on).integerValue forKey:@"musicfive"];
    [defaults synchronize];
    
    THJMenuContoller *menuController = (THJMenuContoller *)self.presentingViewController;
    
    if (sender.on) {
        [menuController.musicPlayer play];
    } else {
        [menuController.musicPlayer pause];
        menuController.musicPlayer.currentTime = 0;
    }
}


- (IBAction)thjSwitchsound_settingValueChange:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:@(sender.on).integerValue forKey:@"sound"];
    [defaults synchronize];
    
    THJMenuContoller *menuController = (THJMenuContoller *)self.presentingViewController;
    
    if (sender.on) {
        menuController.moveSoundPlayer.volume = 1;
    } else {
        menuController.moveSoundPlayer.volume = 0;
    }
    
}


- (IBAction)btnBack_TouchUp:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
