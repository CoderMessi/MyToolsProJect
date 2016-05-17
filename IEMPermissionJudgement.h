//
//  IEMPermissionJudgement.h
//  IermuV2
//
//  Created by 宋瑞航 on 16/2/2.
//  Copyright © 2016年 iermu-xiaoqi.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IEMPermissionJudgement : NSObject

/**
 *  检测是否有访问麦克风的权限
 *
 *  @param Result 返回结果的block
 */
+ (void)checkMicrophoneAuthorizationStatusWithResultBlock:(void (^)(BOOL supported))result;

/**
 *  检测应用是否有访问相册的权限
 *
 *  @return YES or No
 */
+ (BOOL)checkPhotoAuthorizationStatus;

/**
 *  检测应用是否有定位权限
 *
 *  @return 
 */
+ (BOOL)checkLocationAuthorizationStatus;

/**
 *  是否有获取通讯录的权限
 *
 *  @return 
 */
+ (BOOL)checkAddressBookAuthorizationStatus;

/**
 *  检测应用是否开启了通知
 *
 *  @return
 */
+ (BOOL)checkIsAppRegisterRemoteNotification;

/**
 *  是否注册了iermu推送服务
 *
 *  @return 
 */
+ (BOOL)checkIsRegisteredIermuRemoteNotification;

@end
