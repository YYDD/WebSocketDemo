//
//  ViewController.m
//  WebSocketDemo
//
//  Created by YYDD on 16/8/22.
//  Copyright © 2016年 com.yydd.cn. All rights reserved.
//

#import "ViewController.h"
#import "SDCSocketCenter.h"

@interface ViewController ()<SDCSocketCenterDelegate>

@property(nonatomic,weak)UILabel *contentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initUI];
}

-(void)initUI {
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击连接长连接" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, screenSize.height/2 - 30 , screenSize.width, 30);
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.frame = CGRectMake(0, 20, screenSize.width, 50);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:contentLabel];
    _contentLabel = contentLabel;
}



-(void)btnClick {

    [SDCSocketCenter sharedSocket].delegate = self;
    [[SDCSocketCenter sharedSocket]doConnect];
    
    
}


#pragma mark - SDCSocketCenterDelegate

-(void)socketConnectState:(SocketConnectState)state {

    NSString *stateStr = @"";
    
    switch (state) {
        case SDCConnecting:
            stateStr = @"****连接中****";
            break;
        case SDCConnectReConnect:
            stateStr = @"****重连中****";
            break;
        case SDCConnectSuccess:
            stateStr = @"****连接成功****";
            break;
        case SDCConnectFailed:
            stateStr = @"****连接失败****";
            break;
        default:
            break;
    }

    [_contentLabel setText:stateStr];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
