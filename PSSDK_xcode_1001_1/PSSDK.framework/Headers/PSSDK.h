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

/**
 获取用户归属地信息
 
 @param completionBlock 回调中model参数表示户归属地信息
 */
+ (void)getUserRegion:(void (^)(PSUserRegionModel *model))completionBlock;

/**
 获取用户隐私政策信息
 
 @param productId 产品Id
 @param accountId 渠道Id
 @param completionBlock 回调中model参数表示用户隐私政策信息
 */
+ (void)getPrivacyInfoWithProductId:(NSString *)productId accountId:(NSString *)accountId completion:(void (^)(PSPrivacyModel *model))completionBlock;

/**
 使用弹窗向用户请求访问隐私信息授权
 
 @param viewController 当前视图控制器
 @param completionBlock 回调，其中model.authorization为YES表示用户同意使用隐私信息，为NO表示用户不同意使用隐私信息
 */
+ (void)requestAuthorizationWithAlert:(UIViewController *)viewController completion:(void (^)(PSPrivacyModel *model))completionBlock;

/**
 更新访问隐私信息授权
 @param authorization 是否授权
 @param completionBlock 回调
 */
+ (void)updateAuthorization:(BOOL)authorization completion:(void (^)(PSPrivacyModel *model))completionBlock;
@end
