//
//  SDCSocket.h
//  testPop
//
//  Created by YYDD on 16/8/22.
//  Copyright © 2016年 com.yydd.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCSocketConfig.h"

@interface SDCSocket : NSObject


+(SDCSocket *)sharedSocket;

@property(nonatomic,strong)NSURL *socketUrl;
@property(nonatomic,strong)NSArray *socketProtocol;

@property(nonatomic,assign,readonly)SocketConnectState socketConnectState;

-(void)connectSocket;//连接
-(void)closeSocket;//断开
-(void)sendData:(id)data;//发送




@end
