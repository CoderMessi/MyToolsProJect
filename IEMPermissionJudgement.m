//
//  IEMPermissionJudgement.m
//  IermuV2
//
//  Created by 宋瑞航 on 16/2/2.
//  Copyright © 2016年 iermu-xiaoqi.zhang. All rights reserved.
//

#import "IEMPermissionJudgement.h"

@import AVFoundation;
@import CoreLocation;
@import AssetsLibrary;
@import AddressBook;

@implementation IEMPermissionJudgement

+ (void)checkMicrophoneAuthorizationStatusWithResultBlock:(void (^)(BOOL supported))result
{
    AVAudioSession * session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session requestRecordPermission:^(BOOL granted) {
            if (result) {
                result(granted);
            }
        }];
    }
}

+ (BOOL)checkPhotoAuthorizationStatus
{
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
        return NO;
    }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

+ (BOOL)checkLocationAuthorizationStatus
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return NO;
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkAddressBookAuthorizationStatus
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if(status == kABAuthorizationStatusRestricted) {
        return NO;
    } else if (status == kABAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkIsAppRegisterRemoteNotification;
{
    UIApplication *shareApplication = [UIApplication sharedApplication];
    if ([[UIDevice currentDevice].systemVersion intValue] <= 8.0) {
        UIRemoteNotificationType types = shareApplication.enabledRemoteNotificationTypes;
        return (types & UIRemoteNotificationTypeAlert);
    } else {
        return shareApplication.isRegisteredForRemoteNotifications;
    }
}

+ (BOOL)checkIsRegisteredIermuRemoteNotification
{
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSNumber *object = [userDefault objectForKey:kIsRegisteredIermuRemoteNotification];
    return object.intValue == 1 ? YES : NO;
}


@end
