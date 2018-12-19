//
//  THJGameHeader.h
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/19.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#ifndef THJGameHeader_h
#define THJGameHeader_h

#import "UIView+Utils.h"
#define KISDictionaryHaveKey(dict,key) [[dict allKeys] containsObject:key] && ([dict objectForKey:key] != (NSString*)[NSNull null]) ? [dict objectForKey:key] : @""
//当前系统版本版本
#define KDeviceVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)//屏幕宽度
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)//屏幕高度

#define kIsiPhoneX (kScreenHeight == (812) ? YES : NO)

#define kiPhoneXStateHeight (kIsiPhoneX?24:0)

#define kiPhoneXTabBarH (kIsiPhoneX?83:49)

#define HEIGHTNAV64 (64 + kiPhoneXStateHeight)

//颜色值
#define kColorWithRGB(r, g, b, a)\
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define TBackGroundColor  UIColorFromRGBA(0xf5f5f5, 1)


#endif /* THJGameHeader_h */
