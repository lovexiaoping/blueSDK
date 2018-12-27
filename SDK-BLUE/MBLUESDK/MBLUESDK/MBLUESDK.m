//
//  MBLUESDK.m
//  MBLUESDK
//
//  Created by dinglp on 2018/10/29.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MBLUESDK.h"
#import "BeCentralVewController.h"
#import "MBCadeValueManage.h"

@implementation MBLUESDK

static id MBlue = nil;

+ (instancetype)sharedMBlueSDK{
    
    static dispatch_once_t packageInstance;
    dispatch_once(&packageInstance, ^{
        if(MBlue == nil){
            MBlue = [[self alloc] init];
        }
    });
    return MBlue;
}
-(void)startConnectBlueService{
    [[BeCentralVewController sharedInstanceDLPBlueToothGamepad] startConnectBlueService];
}
@end
