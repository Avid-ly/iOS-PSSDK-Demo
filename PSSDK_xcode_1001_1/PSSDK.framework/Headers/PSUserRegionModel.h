//
//  PSUserRegionModel.h
//  PSSDK
//
//  Created by steve on 2020/9/16.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PSUserRegionModel : NSObject

@property (nonatomic, copy) NSString *country;      // 国家
@property (nonatomic, copy) NSString *province;     // 州省
@property (nonatomic, copy) NSString *city;         // 城市

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
