//
//  MyNetworkManager.m
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/6/30.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import "MyNetworkManager.h"
#import <SDVersion/SDVersion.h>

@interface MyNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation MyNetworkManager

+ (instancetype)sharedInstance {
    static MyNetworkManager *networkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[self alloc] init];
    });
    return networkManager;
}

#pragma mark - request
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *, id))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSURLSessionDataTask *dataTask = [self.httpSessionManager GET:URLString
                                                       parameters:parameters
                                                         progress:nil
                                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                              if (success) {
                                                                  success(task, responseObject);
                                                              }
                                                          }
                                                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                              if (failure) {
                                                                  failure(task, error);
                                                              }
                                                          }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSURLSessionDataTask *dataTask = [self.httpSessionManager POST:URLString
                                                        parameters:parameters
                                                          progress:nil
                                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    }
                                                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                     fileParam:(NSDictionary *)fileParam
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSURLSessionDataTask *dataTask = [self.httpSessionManager POST:URLString
                                                        parameters:parameters
                                         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *keys = [fileParam allKeys];
        for (NSString * key in keys) {
            [formData appendPartWithFileData:[fileParam objectForKey:key]
                                        name:key
                                    fileName:@"xxx.jpg"
                                    mimeType:@"image/jpeg"];
        }
    }
                                                          progress:nil
                                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    }
                                                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
    return dataTask;
}

#pragma mark - User Agent
- (NSString *)userAgent {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *platform = DeviceVersionNames[[SDVersion deviceVersion]];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *userAgent =
    [NSString stringWithFormat:@"%@/%@(%@;iOS %@)", appName, appVersion, platform, systemVersion];
    
    return userAgent;
}

#pragma mark - getter and setter
- (AFHTTPSessionManager *)httpSessionManager {
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        
        //请求超时时间
        _httpSessionManager.requestSerializer.timeoutInterval = 30.0;
        
        //请求的设备信息
        [_httpSessionManager.requestSerializer setValue:[self userAgent] forKey:@"User-Agent"];
        
        //响应数据类型（还可以设置更多的响应类型）
        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        
        //同一时间请求队列的最大个数
        _httpSessionManager.operationQueue.maxConcurrentOperationCount = 5;
        
    }
    
    return _httpSessionManager;
}

@end
