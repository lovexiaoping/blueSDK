//
//  MBCadeTempVar.h
//  MBLUESDK
//
//  Created by dinglp on 2018/11/1.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBLUESDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBCadeTempVar : NSObject

@property (nonatomic,assign) BOOL ShangPed;
@property (nonatomic,assign) BOOL XiaPed;
@property (nonatomic,assign) BOOL ZuoPed;
@property (nonatomic,assign) BOOL YouPed;

@property (nonatomic,assign) BOOL APressed;
@property (nonatomic,assign) BOOL BPressed;
@property (nonatomic,assign) BOOL XPressed;
@property (nonatomic,assign) BOOL YPressed;

//遥感临时坐标值
@property (nonatomic,assign) CGPoint leftPoint;
@property (nonatomic,assign) CGPoint rightPoint;

@property (nonatomic,assign) BOOL L1Pressed;
@property (nonatomic,assign) BOOL R1Pressed;
@property (nonatomic,assign) BOOL SELECTPressed;
@property (nonatomic,assign) BOOL STARTPressed;

@property (nonatomic,assign) BOOL L2Pressed;
@property (nonatomic,assign) BOOL R2Pressed;

+ (instancetype)shareJian;

-(void)jisuanABXY:(NSString*)v3;
@end

NS_ASSUME_NONNULL_END
