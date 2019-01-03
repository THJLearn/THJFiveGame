//
//  THJPacket.m
//  THJFiveGame
//
//  Created by tianhaojie on 2019/1/2.
//  Copyright © 2019 tianXiaotian. All rights reserved.
//
#import "THJPacket.h"

NSString * const THJPacketKeyData = @"data";
NSString * const THJPacketKeyType = @"type";
NSString * const THJPacketKeyAction = @"piece";

@implementation THJPacket

#pragma mark - Initializer
- (id)initWithTHJData:(id)data andType:(THJPacketType)type andAction:(THJPacketAction)action{
    self = [super init];
    
    if (self) {
        self.data = data;
        self.type = type;
        self.action = action;
    }
    return self;
}



#pragma mark - NSCoding Protocol

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.data forKey:THJPacketKeyData];
    [coder encodeInteger:self.type forKey:THJPacketKeyType];
    [coder encodeInteger:self.action forKey:THJPacketKeyAction];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        [self setData:[decoder decodeObjectForKey:THJPacketKeyData]];
        [self setType:[decoder decodeIntegerForKey:THJPacketKeyType]];
        [self setAction:[decoder decodeIntegerForKey:THJPacketKeyAction]];
    }
    
    return self;
}
@end
