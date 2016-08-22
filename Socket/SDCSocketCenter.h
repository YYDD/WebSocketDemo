//
//  SDCSocketCenter.h
//  testPop
//
//  Created by YYDD on 16/8/22.
//  Copyright © 2016年 com.yydd.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCSocketConfig.h"

@protocol SDCSocketCenterDelegate <NSObject>

-(void)socketConnectState:(SocketConnectState)state;

@end


@interface SDCSocketCenter : NSObject

+(SDCSocketCenter *)sharedSocket;

@property(nonatomic,weak)id <SDCSocketCenterDelegate>delegate;


/**
 *  连接socket
 */
-(void)doConnect;

/**
 *  断开socket
 */
-(void)doDisConnect;

/**
 *  发送data
 *
 *  @param data nsdata or nsstring
 */
-(void)doSend:(id)data;


@end
