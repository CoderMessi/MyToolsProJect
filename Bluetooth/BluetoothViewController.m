//
//  BluetoothViewController.m
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/7/21.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import "BluetoothViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BluetoothViewController ()<MCSessionDelegate, MCAdvertiserAssistantDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:@"Leaf_Advertiser"];
    _session = [[MCSession alloc] initWithPeer:peerID];
    _session.delegate = self;
    
    //创建广播
    _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"cmj-stream" discoveryInfo:nil session:_session];
    _advertiserAssistant.delegate = self;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 100)];
    [self.view addSubview:_imageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择照片" style:UIBarButtonItemStyleDone target:self action:@selector(selectImageClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送广播" style:UIBarButtonItemStylePlain target:self action:@selector(advertiserClick)];
}

- (void)selectImageClick {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)advertiserClick {
    [self.advertiserAssistant start];
}

#pragma mark - MCSession 代理方法
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"didChangeState");
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"连接成功.");
            break;
        case MCSessionStateConnecting:
            NSLog(@"正在连接...");
            break;
        default:
            NSLog(@"连接失败.");
            break;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"开始接收数据...");
    UIImage *image=[UIImage imageWithData:data];
    [self.imageView setImage:image];
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

#pragma mark - MCAdvertiserAssistant代理方法


#pragma mark -  UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageView setImage:image];
    
    //发送数据给所有已连接设备
    NSError *error=nil;
    [self.session sendData:UIImagePNGRepresentation(image) toPeers:[self.session connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    NSLog(@"开始发送数据...");
    if (error) {
        NSLog(@"发送数据过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
