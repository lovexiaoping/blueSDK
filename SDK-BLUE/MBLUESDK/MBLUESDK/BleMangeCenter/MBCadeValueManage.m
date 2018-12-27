//
//  MBCadeValueManage.m
//  MBLUESDK
//
//  Created by dinglp on 2018/10/29.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MBCadeValueManage.h"
#import "MBCadeTempVar.h"


@implementation MBCadeValueManage

static MBCadeValueManage *StatueCodeValue;

//左摇杆:a106 9e00 8080 0000 0000 0000 0000 0000 0000 0000


#define NORMALVALUE @"8080"

#define ZEROVALUE @"0000"
#define SHA_VALUE @"0100"
#define YOU_VALUE @"0200"
#define XIA_VALUE @"0400"
#define ZUO_VALUE @"0800"

#define A_VALUE @"1000"
#define B_VALUE @"2000"
#define X_VALUE @"4000"
#define Y_VALUE @"8000"


#define SELECT_VALUE @"0004"
#define START_VALUE  @"0008"

#define L1_VALUE  @"0001"
#define R1_VALUE  @"0002"
#define R2_VALUE  @"0080"
#define L2_VALUE  @"0040"

#define L2_VALUE2  @"ff00"
#define R2_VALUE2  @"00ff"

#define R2_LONGVALUE  255

+ (instancetype)sharedMBCadeValueManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StatueCodeValue = [[self alloc] init];
    });
    return StatueCodeValue;
}
// 16进制转10进制

- (unsigned long long) numberHexString:(NSString *)HexString{
    unsigned long long result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:HexString];
    [scanner scanHexLongLong:&result];
    
    return result;
}
-(void)ReceivedBluHexValTest1:(NSString*)HexValue{
    
    NSString *value = HexValue;
    value = [value substringWithRange:NSMakeRange(0, value.length-16)];
    
    
}
-(void)ReceivedBluHexValTest:(NSString*)HexValue{
    
    NSString *value = HexValue;
    value = [value substringWithRange:NSMakeRange(0, value.length-16)];
    
    
    NSString *value2 = [value substringWithRange:NSMakeRange(4, value.length-4)];
    if ([value2 isEqual:@"00000000000000000000"]) {
        return;
    }
//    NSLog(@"charac value : %@",value2);

    NSString *v1 = [value2 substringWithRange:NSMakeRange(0, 4)];
    NSString *v2 = [value2 substringWithRange:NSMakeRange(4, 4)];
    NSString *v3 = [value2 substringWithRange:NSMakeRange(8, 4)];
    NSString *v4 = [value2 substringWithRange:NSMakeRange(12, 4)];
    
    
    //左摇杆: 9e00 8080 0000 0000 0000 0000000000000000
    //右摇杆: 8080 0938 0000 0000 0000 0000000000000000
    // 0-127, 128, 129-255 128为归中值

    
    if (![v1 isEqual:ZEROVALUE]) {
        NSString *vx = [v1 substringWithRange:NSMakeRange(0, 2)];
        NSString *vy = [v1 substringWithRange:NSMakeRange(2, 2)];
        unsigned long long  vx1 = [MBNumberHexTool numberHexString:vx];
        unsigned long long  vy1 = [MBNumberHexTool numberHexString:vy];
//        NSLog(@"左摇杆 x = %lld , y = %lld",vx1,vy1);
        //x y变动则更新
        if (vx1!=[MBCadeTempVar shareJian].leftPoint.x ||
            vy1!=[MBCadeTempVar shareJian].leftPoint.y) {
            MBMocutStickEvent *MocutStick =  [[MBMocutStickEvent alloc]init];
            MocutStick.stickType = MBLEFT_STICK;
            MocutStick.x = vx1;
            MocutStick.y = vy1;
            if (vy1==128 && vx1==128) {
                MocutStick.isCenter = YES;
            }
            [self valueUpdateMBMocutStickEvent:MocutStick];
            [MBCadeTempVar shareJian].leftPoint = CGPointMake(vx1, vy1);

        }
        
    }
    
    if (![v2 isEqual:ZEROVALUE]) {
        //右摇杆
        //NSLog(@"右摇杆 %@",v2);
        NSString *vx = [v2 substringWithRange:NSMakeRange(0, 2)];
        NSString *vy = [v2 substringWithRange:NSMakeRange(2, 2)];
        unsigned long long  vx1 = [MBNumberHexTool numberHexString:vx];
        unsigned long long  vy1 = [MBNumberHexTool numberHexString:vy];
        //NSLog(@"右摇杆 x = %lld , y = %lld",vx1,vy1);
        
        //x y变动则更新
        if (vx1!=[MBCadeTempVar shareJian].rightPoint.x ||
            vy1!=[MBCadeTempVar shareJian].rightPoint.y) {
            MBMocutStickEvent *MocutStick =  [[MBMocutStickEvent alloc]init];
            MocutStick.stickType = MBRIGHT_STICK;
            MocutStick.x = vx1;
            MocutStick.y = vy1;
            if (vy1==128 && vx1==128) {
                MocutStick.isCenter = YES;
            }
            [self valueUpdateMBMocutStickEvent:MocutStick];
            [MBCadeTempVar shareJian].rightPoint = CGPointMake(vx1, vy1);
            
        }

    }
    if (v3) {
        //上下左右    空0 1上 2右上 3右 4右下 5下 6左下 7左 8左上
        
        NSString *v31 = [v3 substringWithRange:NSMakeRange(0, 2)];

        //[0 1] 0 为ABXY
        NSString *v31_1 = [v3 substringWithRange:NSMakeRange(0, 1)];
        //1 为方向键
        NSString *v31_2 = [v3 substringWithRange:NSMakeRange(1, 1)];
        
//        unsigned long long  vlong31 = [MBNumberHexTool numberHexString:v31];
        unsigned long long  vlong31_1 = [MBNumberHexTool numberHexString:v31_1];
        unsigned long long  vlong31_2 = [MBNumberHexTool numberHexString:v31_2];

//        NSLog(@"ABXY:%llu",vlong31_1);
//        NSLog(@"方向键:%llu",vlong31_2);
//

        BOOL isV1 = [MBCadeTempVar shareJian].ShangPed;
        BOOL isV2 =  [MBCadeTempVar shareJian].YouPed;
        BOOL isV3 = [MBCadeTempVar shareJian].XiaPed;
        BOOL isV4 = [MBCadeTempVar shareJian].ZuoPed;
//        NSLog(@"(上一次) 上下左右  =  %d %d %d %d",isV1,isV2,isV3,isV4);

        //ABXY
         if (vlong31_1!=0){
             [self jisuanABXY:vlong31_1];

         }else{
             [self ABXYvalueToZore];

         }
        //方向键
        if (vlong31_2!=0){
            //方向键
            if (vlong31_2==1) {//返回1 上键值
                if (isV1) {
                    if (isV2) { //右 起来
                        [MBCadeTempVar shareJian].YouPed = NO;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:NO];//notify
                    }else if (isV4) {
                        [MBCadeTempVar shareJian].ZuoPed = NO;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:NO];//notify
                    }
                }else{
                    [MBCadeTempVar shareJian].ShangPed = YES;
                    //                        NSLog(@"上");
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];//notify
                }
            }if (vlong31_2==3) {//返回3 右键值
                if (isV2) { //上一次右键Press
                    if (isV1) { //右 up
                        [MBCadeTempVar shareJian].ShangPed = NO;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:NO];//notify
                    }else if (isV3) {
                        [MBCadeTempVar shareJian].XiaPed = NO;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:NO];//notify
                    }
                }else{//上一次右键unPress
                    [MBCadeTempVar shareJian].YouPed=YES;
                    //                        NSLog(@"右");
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                }
                
            }if (vlong31_2==5) {
                if (isV3) { //上一次xia键Press
                    if (isV2) {
                        [MBCadeTempVar shareJian].YouPed = NO;//右 up
                        //notify
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:NO];//notify
                    }else if (isV4) {
                        [MBCadeTempVar shareJian].ZuoPed = NO;
                        //notify
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:NO];//notify
                    }
                }else{//上一次xia键unPress
                    [MBCadeTempVar shareJian].XiaPed=YES;
                    //                        NSLog(@"下");
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];//notify
                }
            }if (vlong31_2==7) {
                if (isV4) { //上一次zuo键Press
                    if (isV3) {
                        [MBCadeTempVar shareJian].XiaPed = NO;//右 up
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:NO];//notify
                    }else if (isV1) {
                        [MBCadeTempVar shareJian].ShangPed = NO;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:NO];//notify
                    }
                }else{//上一次zuo键unPress
                    [MBCadeTempVar shareJian].ZuoPed=YES;
                    //NSLog(@"左");
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];//notify
                }
            }if (vlong31_2==2) {//上右值
                if (isV1 && !isV2) {
                    [MBCadeTempVar shareJian].YouPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                }else if (isV2 && !isV1) {
                    [MBCadeTempVar shareJian].ShangPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];//notify
                }else if (!isV1 && !isV2){
                    [MBCadeTempVar shareJian].YouPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                    [MBCadeTempVar shareJian].ShangPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];//notify
                }
                //NSLog(@"上右");
            }if (vlong31_2==4) {
                if (isV2 && !isV3) {
                    [MBCadeTempVar shareJian].XiaPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];//notify
                }else if (isV3 && !isV2) {
                    [MBCadeTempVar shareJian].YouPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                }else if (!isV2 && !isV3){
                    [MBCadeTempVar shareJian].XiaPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];//notify
                    [MBCadeTempVar shareJian].YouPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                }
                //NSLog(@"右下");
            }if (vlong31_2==6) {
                if (isV3 && !isV4) {
                    [MBCadeTempVar shareJian].ZuoPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];
                }else if (isV4 && !isV3) {
                    [MBCadeTempVar shareJian].XiaPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];
                }else if (!isV3 && !isV4){
                    [MBCadeTempVar shareJian].ZuoPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];
                    [MBCadeTempVar shareJian].XiaPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];
                }
                // NSLog(@"左下");
            }if (vlong31_2==8) {
                if (isV4 && !isV1) {
                    [MBCadeTempVar shareJian].ZuoPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];
                }else if (isV1 && !isV4) {
                    [MBCadeTempVar shareJian].ShangPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];
                }else if (!isV1 && !isV4){
                    [MBCadeTempVar shareJian].ZuoPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];
                    [MBCadeTempVar shareJian].ShangPed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];
                }
                //NSLog(@"左上");
            }
            
        }else{  //v31 = 00
            
            if (isV1) {
                [MBCadeTempVar shareJian].ShangPed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:NO];
            }if (isV2) {
                [MBCadeTempVar shareJian].YouPed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:NO];
            }if (isV3) {
                [MBCadeTempVar shareJian].XiaPed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:NO];
            }if (isV4) {
                [MBCadeTempVar shareJian].ZuoPed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:NO];
            }
        }
        
        
        
        
        
        
        
        /*
        
        if (vlong31!=0){
            
            if(vlong31 >= 16){
                //ABXY
                [self jisuanABXY:v31];
            }else{
                //ABXY to zore
                [self ABXYvalueToZore];
                
                //方向键
                if (vlong31==1) {//返回1 上键值
                    if (isV1) {
                        if (isV2) { //右 起来
                            [MBCadeTempVar shareJian].YouPed = NO;
                            [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:NO];//notify
                        }else if (isV4) {
                            [MBCadeTempVar shareJian].ZuoPed = NO;
                            [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:NO];//notify
                        }
                    }else{
                        [MBCadeTempVar shareJian].ShangPed = YES;
//                        NSLog(@"上");
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];//notify
                    }
                }if (vlong31==3) {//返回3 右键值
                    if (isV2) { //上一次右键Press
                        if (isV1) { //右 up
                            [MBCadeTempVar shareJian].ShangPed = NO;
                            [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:NO];//notify
                        }else if (isV3) {
                            [MBCadeTempVar shareJian].XiaPed = NO;
                            [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:NO];//notify
                        }
                    }else{//上一次右键unPress
                        [MBCadeTempVar shareJian].YouPed=YES;
//                        NSLog(@"右");
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                    }
                    
                }if (vlong31==5) {
                    if (isV3) { //上一次xia键Press
                        if (isV2) {
                            [MBCadeTempVar shareJian].YouPed = NO;//右 up
                            //notify
                            [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:NO];//notify
                        }else if (isV4) {
                            [MBCadeTempVar shareJian].ZuoPed = NO;
                            //notify
                            [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:NO];//notify
                        }
                    }else{//上一次xia键unPress
                        [MBCadeTempVar shareJian].XiaPed=YES;
//                        NSLog(@"下");
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];//notify
                    }
                }if (vlong31==7) {
                    if (isV4) { //上一次zuo键Press
                        if (isV3) {
                            [MBCadeTempVar shareJian].XiaPed = NO;//右 up
                            [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:NO];//notify
                        }else if (isV1) {
                            [MBCadeTempVar shareJian].ShangPed = NO;
                            [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:NO];//notify
                        }
                    }else{//上一次zuo键unPress
                        [MBCadeTempVar shareJian].ZuoPed=YES;
                        //NSLog(@"左");
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];//notify
                    }
                }if (vlong31==2) {//上右值
                    if (isV1 && !isV2) {
                        [MBCadeTempVar shareJian].YouPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                    }else if (isV2 && !isV1) {
                        [MBCadeTempVar shareJian].ShangPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];//notify
                    }else if (!isV1 && !isV2){
                        [MBCadeTempVar shareJian].YouPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                        [MBCadeTempVar shareJian].ShangPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];//notify
                    }
                    //NSLog(@"上右");
                }if (vlong31==4) {
                    if (isV2 && !isV3) {
                        [MBCadeTempVar shareJian].XiaPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];//notify
                    }else if (isV3 && !isV2) {
                        [MBCadeTempVar shareJian].YouPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                    }else if (!isV2 && !isV3){
                        [MBCadeTempVar shareJian].XiaPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];//notify
                        [MBCadeTempVar shareJian].YouPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:YES];//notify
                    }
                    //NSLog(@"右下");
                }if (vlong31==6) {
                    if (isV3 && !isV4) {
                        [MBCadeTempVar shareJian].ZuoPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];
                    }else if (isV4 && !isV3) {
                        [MBCadeTempVar shareJian].XiaPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];
                    }else if (!isV3 && !isV4){
                        [MBCadeTempVar shareJian].ZuoPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];
                        [MBCadeTempVar shareJian].XiaPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:YES];
                    }
                   // NSLog(@"左下");
                }if (vlong31==8) {
                    if (isV4 && !isV1) {
                        [MBCadeTempVar shareJian].ZuoPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];
                    }else if (isV1 && !isV4) {
                        [MBCadeTempVar shareJian].ShangPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];
                    }else if (!isV1 && !isV4){
                        [MBCadeTempVar shareJian].ZuoPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:YES];
                        [MBCadeTempVar shareJian].ShangPed = YES;
                        [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:YES];
                    }
                    //NSLog(@"左上");
                }
            }
            
        }else{  //v31 = 00
            
        
            if (isV1) {
                [MBCadeTempVar shareJian].ShangPed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_UP CadePressed:NO];
            }if (isV2) {
                [MBCadeTempVar shareJian].YouPed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_RIGHT CadePressed:NO];
            }if (isV3) {
                [MBCadeTempVar shareJian].XiaPed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_DOWN CadePressed:NO];
            }if (isV4) {
                [MBCadeTempVar shareJian].ZuoPed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_LEFT CadePressed:NO];
            }
            [self ABXYvalueToZore];
        }
         */
        
#pragma mark --  L1 R1 SELECT START
        NSString *v32 = [v3 substringWithRange:NSMakeRange(2, 2)];
        unsigned long long  vlong32 = [MBNumberHexTool numberHexString:v32];
//        NSLog(@"--  %llu",vlong32);
        if (vlong32!=0) {
            if (vlong32==1) {
                if (![MBCadeTempVar shareJian].L1Pressed) {
                    [MBCadeTempVar shareJian].L1Pressed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_L1 CadePressed:YES];
                }
            }if (vlong32==2) {
                if (![MBCadeTempVar shareJian].R1Pressed) {
                    [MBCadeTempVar shareJian].R1Pressed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_R1 CadePressed:YES];
                }
            }if (vlong32==4) {
                if (![MBCadeTempVar shareJian].SELECTPressed) {
                    [MBCadeTempVar shareJian].SELECTPressed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_SELECT CadePressed:YES];
                }
            }if (vlong32==8) {
                if (![MBCadeTempVar shareJian].STARTPressed) {
                    [MBCadeTempVar shareJian].STARTPressed = YES;
                    [self valueUpdateMBMocutCadeEvent:MBMocutCade_START CadePressed:YES];
                }
            }
        }else{
            
            
            if ([MBCadeTempVar shareJian].L1Pressed) {
                [MBCadeTempVar shareJian].L1Pressed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_L1 CadePressed:NO];
            }
            if ([MBCadeTempVar shareJian].R1Pressed) {
                [MBCadeTempVar shareJian].R1Pressed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_R1 CadePressed:NO];
            }
            if ([MBCadeTempVar shareJian].SELECTPressed) {
                [MBCadeTempVar shareJian].SELECTPressed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_SELECT CadePressed:NO];
            }
            if ([MBCadeTempVar shareJian].STARTPressed) {
                [MBCadeTempVar shareJian].STARTPressed = NO;
                [self valueUpdateMBMocutCadeEvent:MBMocutCade_START CadePressed:NO];
            }
        }
        
    }
    
#pragma mark ---L2 R2
    NSString *v41 = [v4 substringWithRange:NSMakeRange(0, 2)];
    unsigned long long  vlong41 = [MBNumberHexTool numberHexString:v41];

    NSString *v42 = [v4 substringWithRange:NSMakeRange(2, 2)];
    unsigned long long  vlong42 = [MBNumberHexTool numberHexString:v42];
//        NSLog(@"%llu",vlong41);
    if (vlong41==R2_LONGVALUE) {
        //255
        if (![MBCadeTempVar shareJian].L2Pressed) {
            [MBCadeTempVar shareJian].L2Pressed = YES;
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_L2 CadePressed:YES];
        }
    }else{
        //0
        if ([MBCadeTempVar shareJian].L2Pressed) {
            [MBCadeTempVar shareJian].L2Pressed = NO;
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_L2 CadePressed:NO];
        }
    }
    if (vlong42==R2_LONGVALUE) {
        //255
        if (![MBCadeTempVar shareJian].R2Pressed) {
            [MBCadeTempVar shareJian].R2Pressed = YES;
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_R2 CadePressed:YES];
        }
    }else{
        //0
        if ([MBCadeTempVar shareJian].R2Pressed) {
            [MBCadeTempVar shareJian].R2Pressed = NO;
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_R2 CadePressed:NO];
        }
    }
    
}
-(void)DireCadevalueToZore{

    
    
    
}
//只要小于16 ABXY 起来
-(void)ABXYvalueToZore{
    
    BOOL isAp =  [MBCadeTempVar shareJian].APressed;
    BOOL isBp = [MBCadeTempVar shareJian].BPressed;
    BOOL isXp = [MBCadeTempVar shareJian].XPressed;
    BOOL isYp = [MBCadeTempVar shareJian].YPressed;
    if (isAp) {
        [self valueUpdateMBMocutCadeEvent:MBMocutCade_A CadePressed:NO];
        [MBCadeTempVar shareJian].APressed = NO;
    }if (isBp) {
        [self valueUpdateMBMocutCadeEvent:MBMocutCade_B CadePressed:NO];
        [MBCadeTempVar shareJian].BPressed = NO;
    }if (isXp) {
        [self valueUpdateMBMocutCadeEvent:MBMocutCade_X CadePressed:NO];
        [MBCadeTempVar shareJian].XPressed = NO;
    }if (isYp) {
        [self valueUpdateMBMocutCadeEvent:MBMocutCade_Y CadePressed:NO];
        [MBCadeTempVar shareJian].YPressed = NO;
        
    }
}

-(void)jisuanABXY:(unsigned long long)v3{
//-(void)jisuanABXY:(NSString*)v3{

    //    NSString *v31 = [v3 substringWithRange:NSMakeRange(0, 2)];
//    unsigned long long  vlong31 = [MBNumberHexTool numberHexString:v31];
    unsigned long long  vlong31 = v3;
    //记录上一次的值
    NSString *v31222 =  [MBNumberHexTool toBinaryithDecimal:vlong31];
    NSMutableString *valueN = [NSMutableString stringWithString:@""];
    if (v31222.length<8) {
        NSMutableString *startZoreStr = [NSMutableString stringWithCapacity:1];
        int cha = (8 - v31222.length);
        for (int i=0; i<cha; i++) {
            [startZoreStr appendString:@"0"];
        }
        [valueN appendString:startZoreStr];
    }
    [valueN appendString:v31222];
    
    
    BOOL isAPressedt = [[valueN substringWithRange:NSMakeRange(3+4, 1)] isEqual:@"1"]?YES:NO;
    BOOL isBPressedt = [[valueN substringWithRange:NSMakeRange(2+4, 1)] isEqual:@"1"]?YES:NO;
    BOOL isXPressedt = [[valueN substringWithRange:NSMakeRange(1+4, 1)] isEqual:@"1"]?YES:NO;
    BOOL isYPressedt = [[valueN substringWithRange:NSMakeRange(0+4, 1)] isEqual:@"1"]?YES:NO;
    
    if ([MBCadeTempVar shareJian].APressed != isAPressedt) {
        if (isAPressedt) {
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_A CadePressed:YES];
        }else{
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_A CadePressed:NO];
        }
    }
    if ([MBCadeTempVar shareJian].BPressed != isBPressedt) {
        if (isBPressedt) {
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_B CadePressed:YES];
        }else{
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_B CadePressed:NO];
        }
    }
    if ([MBCadeTempVar shareJian].XPressed != isXPressedt) {
        if (isXPressedt) {
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_X CadePressed:YES];
        }else{
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_X CadePressed:NO];
        }
    }
    if ([MBCadeTempVar shareJian].YPressed != isYPressedt) {
        if (isYPressedt) {
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_Y CadePressed:YES];
        }else{
            [self valueUpdateMBMocutCadeEvent:MBMocutCade_Y CadePressed:NO];
        }
    }
    [MBCadeTempVar shareJian].APressed = isAPressedt;
    [MBCadeTempVar shareJian].BPressed = isBPressedt;
    [MBCadeTempVar shareJian].XPressed = isXPressedt;
    [MBCadeTempVar shareJian].YPressed = isYPressedt;
}

-(void)valueUpdateMBMocutCadeEvent:(MBMocutCadeType)event CadePressed:(BOOL)IsPressed{
    MBMocutCadeEvent *Cade = [[MBMocutCadeEvent alloc]init];
    Cade.pressed = IsPressed;
    Cade.keyType = event;
    if ([MBLUESDK sharedMBlueSDK].delegate && [[MBLUESDK sharedMBlueSDK].delegate respondsToSelector:@selector(UpdateMBMocutCadeEvent:)]){
        [[MBLUESDK sharedMBlueSDK].delegate UpdateMBMocutCadeEvent:Cade];
    }
}

-(void)valueUpdateMBMocutStickEvent:(MBMocutStickEvent*)event1{
    if ([MBLUESDK sharedMBlueSDK].delegate && [[MBLUESDK sharedMBlueSDK].delegate respondsToSelector:@selector(UpdateMBMocutStickEvent:)]){
        [[MBLUESDK sharedMBlueSDK].delegate UpdateMBMocutStickEvent:event1];
        
    }
}

@end
