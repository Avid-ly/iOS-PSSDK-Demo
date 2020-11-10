//
//  PSSDK.h
//  PSSDK
//
//  Created by steve on 2020/9/7.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPrivacyModel.h"
#import "PSUserRegionModel.h"

@interface PSSDK : NSObject

#pragma mark - Init

/**
 初始化SDK
 
 @param productId 产品Id
 @param accountId 渠道Id
 */
+ (void)initWithProductId:(NSString *)productId accountId:(NSString *)accountId;

#pragma mark - Region

/**
 获取用户归属地信息
 请不要频繁调用，30s内只能调用一次
 
 @param completionBlock 回调中model参数表示户归属地信息
 */
+ (void)getUserRegion:(void (^)(PSUserRegionModel *model))completionBlock;

#pragma mark - Authorization

/**
 获取用户隐私政策信息
 请不要频繁调用，30s内只能调用一次
 
 @param completionBlock 回调中model参数表示用户隐私政策信息
 */
+ (void)getAuthorization:(void (^)(PSPrivacyModel *model))completionBlock;

/**
 更新访问隐私信息授权
 请不要频繁调用，30s内只能调用一次
 
 @param authorization 是否授权
 @param completionBlock 回调
 */
+ (void)updateAuthorization:(BOOL)authorization privacyPolicy:(NSString *)privacyPolicy completion:(void (^)(BOOL succeed))completionBlock;

#pragma mark - Privacy Policy Alert

/**
 获取隐私弹窗信息
 请不要频繁调用，30s内只能调用一次
 
 @param completionBlock 回调中model参数表示用户隐私政策信息
 */
+ (void)getPrivacyPolicyAlertInfo:(void (^)(PSPrivacyModel *model))completionBlock;

/**
 使用弹窗向用户请求访问隐私信息授权
 请不要频繁调用，30s内只能调用一次
 
 @param viewController 当前视图控制器
 @param completionBlock 回调，其中model.authorization为YES表示用户同意使用隐私信息，为NO表示用户不同意使用隐私信息
 */
+ (void)showPrivacyPolicyAlert:(UIViewController *)viewController completion:(void (^)(PSPrivacyModel *model))completionBlock;

/**
 使用弹窗向用户请求访问隐私信息授权
 请不要频繁调用，30s内只能调用一次
 
 @param viewController 当前视图控制器
 @param orientation 当前展示视图的方向（0未知，1竖屏，2横屏）
 @param completionBlock 回调，其中model.authorization为YES表示用户同意使用隐私信息，为NO表示用户不同意使用隐私信息
 */
+ (void)showPrivacyPolicyAlert:(UIViewController *)viewController orientation:(int)orientation completion:(void (^)(PSPrivacyModel *model))completionBlock;

@end
