//
//  MyPlayerViewController.m
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/7/20.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import "MyPlayerViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import <QNDnsManager.h>


@interface MyPlayerViewController ()<PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer *player;

//@property (nonatomic, strong) IJKFFMoviePlayerController *ijkPlayer;

@end

@implementation MyPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(pause)];
    
}


- (void)initPLPlayer {
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    [option setOptionValue:[QNDnsManager new] forKey:PLPlayerOptionKeyDNSManager];
    
    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:@"rtmp://pili-live-rtmp.www.jrzb88.com/jrzb88/hz_jrzb"] option:option];
    self.player.delegate = self;
    self.player.playerView.frame = CGRectMake(0, 70, self.view.frame.size.width, 300);
    [self.view addSubview:self.player.playerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pause {
    [self.player pause];
}

- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    NSLog(@"status>>>%ld", state);
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error {
    NSLog(@"error>>>%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
