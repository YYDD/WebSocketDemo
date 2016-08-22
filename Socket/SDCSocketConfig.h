//
//  SDCSocketConfig.h
//  testPop
//
//  Created by YYDD on 16/8/22.
//  Copyright © 2016年 com.yydd.cn. All rights reserved.
//

#ifndef SDCSocketConfig_h
#define SDCSocketConfig_h

typedef enum SocketConnectState : NSInteger {
    
    SDCConnecting = 1,  /**< 连接中 >*/
    SDCConnectSuccess = 2, /**< 连接成功 >*/
    SDCConnectFailed = 3, /**< 连接失败 >*/
    SDCConnectReConnect = 4, /**< 重连中 >*/
    
    
}SocketConnectState;




static NSString *socketURL = @"wss://echo.websocket.org";



#endif /* SDCSocketConfig_h */
