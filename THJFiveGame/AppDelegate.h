//
//  AppDelegate.h
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/18.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THJLoadingView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)toWebVC:(NSString *)url;
- (void)toGame;

@end

