//
//  SDCSocketCenter.m
//  testPop
//
//  Created by YYDD on 16/8/22.
//  Copyright © 2016年 com.yydd.cn. All rights reserved.
//

#import "SDCSocketCenter.h"
#import "SDCSocket.h"

@interface SDCSocketCenter()

@end

@implementation SDCSocketCenter

+(SDCSocketCenter *)sharedSocket {
    
    static SDCSocketCenter *socketCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!socketCenter) {
            socketCenter = [[SDCSocketCenter alloc]init];
        }
    });
    
    return socketCenter;
}


-(id)init {
    
    if (self = [super init]) {
        
        
        [[SDCSocket sharedSocket] addObserver:self forKeyPath:@"connectState" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (object == [SDCSocket sharedSocket]) {
        
        [self socketConnectStateChanged];
    }
    
}

#pragma mark - SDCSocketCenterDelegate
-(void)socketConnectStateChanged{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(socketConnectState:)]) {
            
            [_delegate socketConnectState:[SDCSocket sharedSocket].socketConnectState];
        }
    });
    
}


#pragma mark - Socket public func
//连接
-(void)doConnect {
    
    [SDCSocket sharedSocket].socketUrl = [NSURL URLWithString:socketURL];
    [[SDCSocket sharedSocket]connectSocket];
    
}


//断开
-(void)doDisConnect {

    [[SDCSocket sharedSocket]closeSocket];
    
}


//发送
-(void)doSend:(id)data {

    [[SDCSocket sharedSocket]sendData:data];
    
}

@end
