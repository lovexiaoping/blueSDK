//
//  MBNumberHexTool.h
//  MBLUESDK
//
//  Created by dinglp on 2018/11/1.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBNumberHexTool : NSObject

// 16进制转10进制
+ (unsigned long long) numberHexString:(NSString *)HexString;

//十进制转二进制
+ (NSString *)toBinaryithDecimal:(NSInteger)decimal;

@end

NS_ASSUME_NONNULL_END
