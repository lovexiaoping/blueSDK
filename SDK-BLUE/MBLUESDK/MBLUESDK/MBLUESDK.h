//
//  MBLUESDK.h
//  MBLUESDK
//
//  Created by dinglp on 2018/10/29.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBMocutCadeEvent.h"
#import "MBMocutStickEvent.h"

@protocol MBlueSDKManagerDelegate <NSObject>

@optional
/**
 当设备有按键值变化时，通过此方法接收
 
 @param event 设备事件
 */
- (void)UpdateMBMocutCadeEvent:(MBMocutCadeEvent*)event;


/**
 当设备有摇杆值变化时，通过此方法接收
 
 @param event 设备事件
 */
- (void)UpdateMBMocutStickEvent:(MBMocutStickEvent*)event;
/**
 当设备连接上时，回调此函数
 
 @param controllerInfo 设备信息
 */
- (void)didControllerConnected:(NSDictionary*)controllerInfo;

/**
 当设备断开连接，回调此函数
 
 @param controllerInfo 设备信息
 */
- (void)didControllerDisconnected:(NSDictionary*)controllerInfo;

@end


@interface MBLUESDK : NSObject

@property (nonatomic,assign)    id<MBlueSDKManagerDelegate>delegate;

-(void)startConnectBlueService;

+ (instancetype)sharedMBlueSDK;

@end
