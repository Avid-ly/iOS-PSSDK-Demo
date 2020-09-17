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

@end

