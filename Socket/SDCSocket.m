//
//  SDCSocket.m
//  testPop
//
//  Created by YYDD on 16/8/22.
//  Copyright © 2016年 com.yydd.cn. All rights reserved.
//

#import "SDCSocket.h"
#import <SocketRocket/SRWebSocket.h>
#import "SDCSocketConfig.h"


@interface SDCSocket()<SRWebSocketDelegate>

@property(nonatomic,strong)SRWebSocket *webSocket;
@property(nonatomic,strong)dispatch_source_t reConnectTimer;

@property(nonatomic,assign)SocketConnectState connectState;


@end

@implementation SDCSocket


+(SDCSocket *)sharedSocket {
    
    static SDCSocket *sdcSocket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdcSocket = [[SDCSocket alloc]init];
    });
    
    return sdcSocket;
}


-(id)init {
    
    if(self = [super init]) {
        
    }
    return self;
}

-(void)createWebSocket {

    NSLog(@"%s",__func__);
    if (!_webSocket) {
        static dispatch_queue_t socketQueue = NULL;
        if( !socketQueue )
        {
            socketQueue = dispatch_queue_create("com.treehole.vagina", NULL);//调度队列
        }
        _webSocket = [[SRWebSocket alloc]initWithURL:self.socketUrl protocols:self.socketProtocol];
        _webSocket.delegate = self;
        [_webSocket setDelegateDispatchQueue:socketQueue];
    }

}

//连接长连接
-(void)connectSocket {
    
    NSLog(@"%s",__func__);
    [self closeSocket];
    [self createWebSocket];
    [self.webSocket open];

}

//断开长连接
-(void)closeSocket {
    
    NSLog(@"%s",__func__);
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}


//发数据
-(void)sendData:(id)data {

    NSLog(@"%s",__func__);
    [self.webSocket send:data];
}

#pragma mark - connect state func
//状态值
-(void)connectStateWithSuccess {

    self.connectState = SDCConnectSuccess;
}

-(void)connectStateWithFalied {
    
    self.connectState = SDCConnectFailed;
}

-(void)connectStateWithDoing {

    self.connectState = SDCConnecting;
}

-(void)connectStateWithReDoing {
    
    self.connectState = SDCConnectReConnect;
}



#pragma mark - connect result func
-(void)connectSuccess {

    NSLog(@"连接成功...");
    [self endReConnect];
    [self connectStateWithSuccess];
}

-(void)connectFinalFailed {

    NSLog(@"连接失败...");
    [self endReConnect];
    [self connectStateWithFalied];
}

-(void)connectFailed {
    
    NSLog(@"重联中...");
    [self beginReConnect];
    [self connectStateWithReDoing];
}



#pragma mark - reconnect func

-(void)beginReConnect {
    //开始重连
    
    if (!_reConnectTimer) {
        [self createReConnectTimer];
        dispatch_resume(self.reConnectTimer);
    }
}


-(void)endReConnect {
    //结束重连
    if (_reConnectTimer) {
        NSLog(@"%@",self.reConnectTimer);
        dispatch_cancel(self.reConnectTimer);
        _reConnectTimer = nil;
    }
}

//重连
-(void)reConnectSocket {
    
    static NSInteger reConnectCount = 0;
    static NSInteger maxConnectCount = 10;
    if (reConnectCount > maxConnectCount) {
        //如果超过重连最大次数
        reConnectCount = 0;
        [self connectFinalFailed];
        return;
    }
    
    reConnectCount ++ ;
    [self connectSocket];

}


-(void)createReConnectTimer {

    if (!_reConnectTimer) {
        NSTimeInterval time = 3.0f;
        self.reConnectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(self.reConnectTimer, DISPATCH_TIME_NOW, time * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.reConnectTimer, ^{
            
            [self reConnectSocket];
        });
    }

}





#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSLog(@"%s",__func__);
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {

    NSLog(@"%s",__func__);
    [self connectSuccess];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
    NSLog(@"%s",__func__);
    [self connectFailed];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {

    NSLog(@"%s",__func__);
    [self connectFailed];
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {

    NSLog(@"%s",__func__);
}


#pragma mark - public 

- (SocketConnectState)socketConnectState {
    
    return self.connectState;
}



@end


