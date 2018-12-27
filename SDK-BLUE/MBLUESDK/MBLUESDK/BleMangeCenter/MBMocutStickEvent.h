//
//  MBMocutStickEvent.h
//  MBLUESDK
//
//  Created by dinglp on 2018/11/1.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#define STICK_COUNT 2

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,MBMocutStickType){
    MBLEFT_STICK = 0,
    MBRIGHT_STICK,
    
};
@interface MBMocutStickEvent : NSObject

@property (nonatomic,assign) MBMocutStickType stickType;
@property (nonatomic,assign) long x;
@property (nonatomic,assign) long y;
@property (nonatomic,assign) BOOL isCenter;

@end

NS_ASSUME_NONNULL_END
