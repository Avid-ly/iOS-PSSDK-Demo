//
//  PSSDKBest.h
//  PSSDK
//
//  Created by steve on 2021/6/4.
//  Copyright © 2021 guojunliu.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPrivacyAuthorizationModel.h"
#import "PSSDKVersion.h"

@interface PSSDK : NSObject

/// 请求授权
/// @param productId        产品ID
/// @param playerId         玩家ID
/// @param vc               根视图
/// @param orientation      屏幕方向
/// @param succeedCallback  成功回调
/// @param errorCallback    失败回调
+ (void)requestPrivacyAuthorizationWithProductId:(NSString *)productId
                                        playerId:(NSString *)playerId
                                              vc:(UIViewController *)vc
                                     orientation:(PSOrientationType)orientation
                                         succeed:(void(^)(PSPrivacyAuthorizationModel *model))succeedCallback
                                           error:(void(^)(NSError *error))errorCallback;

@end

