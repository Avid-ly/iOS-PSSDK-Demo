//
//  PSPrivacyModel.h
//  PSSDK
//
//  Created by steve on 2020/9/7.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSPrivacyModel : NSObject

@property (nonatomic, copy) NSString *privacyPolicy;        // 隐私政策类型
@property (nonatomic) BOOL authorization;                   // 是否授权

@property (nonatomic) BOOL ignore;                          // 是否可忽略
@property (nonatomic) int type;                             // 弹窗类型 1 默认同意弹窗 ，2 主动授权弹窗，3 不弹窗

@end

