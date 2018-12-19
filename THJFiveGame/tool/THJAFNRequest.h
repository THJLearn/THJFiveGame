//
//  THJAFNRequest.h
//  THJFiveGame
//
//  Created by tianhaojie on 2018/12/18.
//  Copyright © 2018 tianXiaotian. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@interface THJAFNRequest : NSObject

+ (void)requestGet:(NSString *)url andSuccessBlock:(void (^)(id json))success andfail:(void(^)(id json))fail;
@end

NS_ASSUME_NONNULL_END
