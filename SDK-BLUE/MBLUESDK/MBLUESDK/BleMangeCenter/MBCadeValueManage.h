//
//  MBCadeValueManage.h
//  MBLUESDK
//
//  Created by dinglp on 2018/10/29.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBLUESDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBCadeValueManage : NSObject

+ (instancetype)sharedMBCadeValueManage;

-(void)ReceivedBluHexValTest:(NSString*)HexValue;

@end

NS_ASSUME_NONNULL_END
