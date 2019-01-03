//
//  THJPacket.h
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const THJPacketKeyData;
extern NSString * const THJPacketKeyType;
extern NSString * const THJPacketKeyAction;

typedef NS_ENUM(NSInteger, THJPacketType) {
    THJPacketTypeUnknown,
    THJPacketTypeMove,
    THJPacketTypeReset,
    THJPacketTypeUndo
};

typedef NS_ENUM(NSInteger, THJPacketAction) {
    THJPacketActionUnknown,
    THJPacketActionResetRequest,
    THJPacketActionResetAgree,
    THJPacketActionResetReject,
    THJPacketActionUndoRequest,
    THJPacketActionUndoAgree,
    THJPacketActionUndoReject
};


@interface THJPacket : NSObject
@property (strong, nonatomic) id data;
@property (assign, nonatomic) THJPacketType type;
@property (assign, nonatomic) THJPacketAction action;
- (id)initWithTHJData:(id)data andType:(THJPacketType)type andAction:(THJPacketAction)action;
@end


NS_ASSUME_NONNULL_END
