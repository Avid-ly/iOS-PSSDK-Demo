//
//  PSPrivacyAuthorizationModel.h
//  PSSDK
//
//  Created by steve on 2021/6/8.
//  Copyright © 2021 guojunliu.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 异常枚举
typedef NS_ENUM(NSUInteger, PSPrivacyAuthorizationError) {
    PSPrivacyAuthorizationErrorUnknow = 0,          // 未知
    PSPrivacyAuthorizationErrorProductId = 10001,   // ProductId异常
    PSPrivacyAuthorizationErrorNetwork = 10002,     // 网络异常
    PSPrivacyAuthorizationErrorRootVC = 10003,      // 根视图异常
    PSPrivacyAuthorizationErrorPlayerId = 10004,    // PlayerId异常
};

// 屏幕方向枚举
typedef NS_ENUM(NSUInteger, PSOrientationType) {
    PSOrientationTypeAuto = 0,                      // 自动
    PSOrientationTypePortrait = 1,                  // 竖屏
    PSOrientationTypeLandscape = 2,                 // 横屏
};

// 请求授权状态枚举
typedef NS_ENUM(NSUInteger, PSPrivacyAuthorizationStatus) {
    PSPrivacyAuthorizationStatusNotDetermined = 0,  // 未请求过授权
    PSPrivacyAuthorizationStatusDetermined = 1      // 已请求过授权
};

// 隐私政策枚举
typedef NS_ENUM(NSUInteger, PSPrivacyPolicyType) {
    PSPrivacyPolicyTypeUnknow = 0,                  // 未知
    PSPrivacyPolicyTypeCCPA = 1,                    // CCPA
    PSPrivacyPolicyTypeGDPR = 2,                    // GDPR
    PSPrivacyPolicyTypeLGPD = 3                     // LGPD
};

// 收集状态枚举
typedef NS_ENUM(NSUInteger, PSPrivacyCollectionStatus) {
    PSPrivacyCollectionStatusUnknow = 0,            // 未知
    PSPrivacyCollectionStatusDenied = 1,            // 不同意收集
    PSPrivacyCollectionStatusAuthorized = 2         // 同意收集
};

// 分享状态枚举
typedef NS_ENUM(NSUInteger, PSPrivacySharingStatus) {
    PSPrivacySharingStatusUnknow = 0,               // 未知
    PSPrivacySharingStatusDenied = 1,               // 不同意分享
    PSPrivacySharingStatusAuthorized = 2            // 同意分享
};

@interface PSPrivacyAuthorizationModel : NSObject

@property (nonatomic) PSPrivacyAuthorizationStatus authorizationStatus; // 授权状态
@property (nonatomic) PSPrivacyPolicyType privacyPolicyType;            // 隐私政策
@property (nonatomic) NSString *privacyPolicy;                          // 隐私政策字符
@property (nonatomic) PSPrivacyCollectionStatus collectionStatus;       // 收集状态
@property (nonatomic) PSPrivacySharingStatus sharingStatus;             // 分享状态

@end
