//
//  MBMocutCadeEvent.h
//  MBLUESDK
//
//  Created by dinglp on 2018/10/30.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//按键类型
typedef NS_ENUM(NSInteger,MBMocutCadeType){
    //标准手柄的十字按键
    MBMocutCade_UP = 0,
    MBMocutCade_RIGHT = 1,
    MBMocutCade_DOWN = 2,
    MBMocutCade_LEFT = 3,
    
    //标准手柄的abxy
    MBMocutCade_A = 4,
    MBMocutCade_B = 5,
    MBMocutCade_X = 6,
    MBMocutCade_Y = 7,
    
    //标准手柄的LR
    MBMocutCade_L1 = 8,
    MBMocutCade_L2 = 9,
    MBMocutCade_R1 = 10,
    MBMocutCade_R2 = 11,
    
    //标准手柄的SELECT START
    MBMocutCade_START = 14,
    MBMocutCade_SELECT = 15,
    
};

@interface MBMocutCadeEvent : NSObject

@property (nonatomic,assign) BOOL pressed;
@property (nonatomic,assign) MBMocutCadeType keyType;

@end

NS_ASSUME_NONNULL_END
