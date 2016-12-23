//
//  DownloadTaskViewController.m
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/7/22.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import "DownloadTaskViewController.h"
#import <AFNetworking.h>

@interface DownloadTaskViewController ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation DownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(session) userInfo:nil repeats:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self downloadFile2];
}

/**
 *  简单的下载
 */
- (void)downloadFile1 {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://183.57.151.208/download/videos/537006603/2016/7/22/1_1469179264_1469179864.mp4?client_token=536970139_0_1471773245_1e0a52211cd7f70a04b2bfce6c22de09"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
    
    [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"progress>>>%@", downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"path:%@---response:%@", targetPath, response);
        NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"filePath>>>>>>%@", filePath);
        NSURL *url = [NSURL fileURLWithPath:filePath];
        return url;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"error>>>%@", error.localizedDescription);
    }] resume];
}

- (void)downloadFile2 {
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://183.57.151.208/download/videos/537006603/2016/7/22/1_1469179264_1469179864.mp4?client_token=536970139_0_1471773245_1e0a52211cd7f70a04b2bfce6c22de09"]];
    [[self.session downloadTaskWithRequest:request] resume];
}

#pragma mark - sessionDownload delegate method
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSLog(@">>>filePath:%@", filePath);
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager copyItemAtPath:location.path toPath:filePath error:nil];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"progress>>>%f", progress);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@">>>fileOffset:%lld---expectedTotalBytes:%lld", fileOffset, expectedTotalBytes);
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}

@end
