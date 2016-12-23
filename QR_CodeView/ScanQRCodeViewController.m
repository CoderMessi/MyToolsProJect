//
//  ScanQRCodeViewController.m
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/7/13.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kQRViewY        100.0
#define kQRViewWidth    200.0
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, strong) UIView *scanContainerView;
@property (nonatomic, strong) UIImageView *scanCodeLine;
@property (nonatomic, strong) CABasicAnimation *scanAnimation;

@property (nonatomic, strong) UIView * topShadowView;
@property (nonatomic, strong) UIView * leftShadowView;
@property (nonatomic, strong) UIView * bottomShadowView;
@property (nonatomic, strong) UIView * rightShadowView;

@property (nonatomic, strong) AVCaptureSession *captureSession;

//判断扫码的线是上还是下
@property (nonatomic, assign) int num;
@property (nonatomic, assign) BOOL upOrdown;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleClick)];
    
    [self.view addSubview:self.scanContainerView];
    [self.scanContainerView addSubview:self.scanCodeLine];
    [self.view addSubview:self.topShadowView];
    [self.view addSubview:self.leftShadowView];
    [self.view addSubview:self.bottomShadowView];
    [self.view addSubview:self.rightShadowView];
    
    [self layoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!_captureSession) {
        [self.captureSession startRunning];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startLineAnimation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_captureSession) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像机访问权限" delegate:nil cancelButtonTitle:@"造了" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopLineAnimation];
}

- (void)dealloc {
    NSLog(@"scanCodeView dealloc");
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count) {
        AVMetadataMachineReadableCodeObject *codeObject = metadataObjects[0];
        NSLog(@">>>%@", codeObject);
        NSString *codeInfo = codeObject.stringValue;
        NSLog(@"二维码信息>>>%@", codeInfo);
        if (codeInfo) {
            [self.captureSession stopRunning];
            [self.scanCodeLine.layer removeAllAnimations];
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:self.webView];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:codeInfo]]];
        }
    }
}

#pragma mark - Layout SubViews
- (void)layoutSubviews {
    CGFloat leftShadowWidth = (kScreenWidth - kQRViewWidth) / 2;
    CGFloat bottomShadowY = kQRViewY + kQRViewWidth;
    CGFloat bottomShadowHeight = kScreenHeight - bottomShadowY;
    CGFloat rightShadowX = kScreenWidth - leftShadowWidth;
    
    self.scanContainerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.scanCodeLine.frame = CGRectMake(leftShadowWidth, kQRViewY, kQRViewWidth, 5);
    self.topShadowView.frame = CGRectMake(0, 0, kScreenWidth, kQRViewY);
    self.leftShadowView.frame = CGRectMake(0, kQRViewY, leftShadowWidth, kQRViewWidth);
    self.bottomShadowView.frame = CGRectMake(0, bottomShadowY, kScreenWidth, bottomShadowHeight);
    self.rightShadowView.frame = CGRectMake(rightShadowX, kQRViewY, leftShadowWidth, kQRViewWidth);
}

#pragma mark - Private Methods
- (void)startLineAnimation {
    [self.scanCodeLine.layer addAnimation:self.scanAnimation forKey:nil];
}

- (void)stopLineAnimation {
    [self.scanCodeLine.layer removeAllAnimations];
}

- (void)cancleClick {
    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView = nil;
        [self.captureSession startRunning];
        [self.scanCodeLine.layer addAnimation:self.scanAnimation forKey:nil];
    }
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setters And Getters
- (UIView *)scanContainerView {
    if (!_scanContainerView) {
        _scanContainerView = [UIView new];
        _scanContainerView.backgroundColor = [UIColor blackColor];
    }
    
    return _scanContainerView;
}

- (UIImageView *)scanCodeLine {
    if (!_scanCodeLine) {
        _scanCodeLine = [UIImageView new];
        _scanCodeLine.image = [UIImage imageNamed:@"add_scancode_line"];
    }
    
    return _scanCodeLine;
}

- (CABasicAnimation *)scanAnimation {
    if (!_scanAnimation) {
        _scanAnimation = [CABasicAnimation animation];
        _scanAnimation.keyPath = @"transform.translation.y";
        _scanAnimation.byValue = @(kQRViewWidth);
        _scanAnimation.duration = 2.0;
        _scanAnimation.repeatCount = MAXFLOAT;
    }
    return _scanAnimation;
}

- (UIView *)topShadowView {
    if (!_topShadowView) {
        _topShadowView = [UIView new];
        _topShadowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    }
    return _topShadowView;
}

- (UIView *)leftShadowView {
    if (!_leftShadowView) {
        _leftShadowView = [UIView new];
        _leftShadowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    }
    return _leftShadowView;
}

- (UIView *)bottomShadowView {
    if (!_bottomShadowView) {
        _bottomShadowView = [UIView new];
        _bottomShadowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    }
    return _bottomShadowView;
}

- (UIView *)rightShadowView {
    if (!_rightShadowView) {
        _rightShadowView = [UIView new];
        _rightShadowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    }
    return _rightShadowView;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //有效扫描区域的frame是反着的，右上角为（0，0）点，向下是x轴正方向，向左是y轴正方向，并且宽高是整个previewLayer的比例
        [output setRectOfInterest:CGRectMake(kQRViewY / kScreenHeight, (kScreenWidth - kQRViewWidth)/2/kScreenWidth, kQRViewWidth / kScreenHeight, kQRViewWidth / kScreenWidth)];
        
        if (!input) {
            return nil;
        }
        
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [_captureSession addInput:input];
        [_captureSession addOutput:output];
        
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.frame = self.view.bounds;
        NSLog(@"%f---%f", previewLayer.frame.size.height, kScreenHeight);
        [self.scanContainerView.layer insertSublayer:previewLayer atIndex:0];
    }
    
    return _captureSession;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"ScanCodeView receive memory warning");
}

@end
