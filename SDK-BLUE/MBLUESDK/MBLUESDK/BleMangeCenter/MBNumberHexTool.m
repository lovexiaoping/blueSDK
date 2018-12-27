//
//  MBNumberHexTool.m
//  MBLUESDK
//
//  Created by dinglp on 2018/11/1.
//  Copyright © 2018年 leo. All rights reserved.
//
#import "MBNumberHexTool.h"
@implementation MBNumberHexTool
// 16进制转10进制
+ (unsigned long long) numberHexString:(NSString *)HexString{
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:HexString];
    [scanner scanHexLongLong:&result];
    
    return result;
}
//十进制转二进制
+ (NSString *)toBinaryithDecimal:(NSInteger)decimal{
    
    NSInteger num = decimal;
    NSInteger remainder = 0;
    NSInteger divisor = 0;
    NSString * prepare = @"";
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",remainder];
        if (divisor == 0)
        {
            break;
        }
    }
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --){
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    return result;
}

// 二进制转十进制
+ (NSString *)convertDecimalSystemFromBinarySystem:(NSString *)binary{
    
    NSInteger ll = 0 ;
    NSInteger  temp = 0 ;
    for (NSInteger i = 0; i < binary.length; i ++){
        
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%ld",ll];
    
    return result;
}


@end
