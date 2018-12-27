//
//  MBCadeTempVar.m
//  MBLUESDK
//
//  Created by dinglp on 2018/11/1.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "MBCadeTempVar.h"

#define SHA 1
#define YOU 3
#define XIA 5
#define ZUO 7

#define YOUSHA 2
#define YOUXIA 4
#define ZUOXIA 6
#define ZUOSHA 7


#define AJIAN 16
#define BJIAN 32
#define XJIAN 64
#define YJIAN 128



static MBCadeTempVar *MBCadeTempVarcode;

@implementation MBCadeTempVar

+ (instancetype)shareJian{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MBCadeTempVarcode = [[self alloc] init];
    });
    return MBCadeTempVarcode;
}
- (instancetype)init
{
    self = [super init];
    if (self) {        
        _leftPoint = CGPointMake(128, 128);
    }
    return self;
}





















#pragma mark --- 废弃逻辑

/*
-(void)skdjfksdj:(NSString*)hh{
    //    NSString* ss = @"a106 8080 8080 0100 000000000000000000000000";
    //    NSString *v3 = [value2 substringWithRange:NSMakeRange(8, 4)];
 
     
     Byte keybuf[20] ;
     for (int j=0; j<20; j++) {
     keybuf[j]=[ss characterAtIndex:j];
     }
 
    
    Byte keybuf[10] ;
    
    keybuf[0] = 0xb1;
    keybuf[1] = 0x06;
    
    keybuf[2] = 0x80;
    keybuf[3] = 0x80;
    
    keybuf[4] = 0x80;
    keybuf[5] = 0x80;
    
    keybuf[6] = 0x08;
    keybuf[7] = 0x00;
    
    keybuf[8] = 0x00;
    keybuf[9] = 0x00;
    
    u_int16_t keydata,key_down;
    u_int16_t shiftdata;
    u_int8_t i,keydir;
    keydata = ((u_int16_t)keybuf[7]<<8)|keybuf[6];
    keydir = keybuf[6]&0x0f;
    NSLog(@"%d keydir",keydir);
    
    if (keydir==0) {
        //NO
    }else if (keydir==1){
        NSLog(@"UP");
        
        //UP
    }else if (keydir==2){
        //RIGHT+UP
        NSLog(@"RIGHT+UP");
        
    }else if (keydir==3){
        NSLog(@"RIGHT");
        
        //RIGHT
    }else if (keydir==4){
        //RIGHT+DOWN
        NSLog(@"RIGHT+DOWN");
        
    }else if (keydir==5){
        //DOWN
        NSLog(@"DOWN");
        
    }else if (keydir==6){
        //LEFT+DOWN
        NSLog(@"LEFT+DOWN");
        
    }else if (keydir==7){
        //LEFT
        NSLog(@"LEFT");
        
    }else if (keydir==8){
        //LEFT+UP
        NSLog(@"LEFT+UP");
        
    }
    //const u_int8_t KEY_DEF[]={A,B,X,Y,L1,R1,SELECT,START,L3,R3,L2,R2};
    
    for(i=4; i<16;i++){
        
        shiftdata=(0x01<<i);
        if(keydata&shiftdata)   //KEYDOWN
        {
            //KEY_DEF[i-4]      ====key_code is.
            NSLog(@"%d KEYDOWN",(i-4));
            key_down|=shiftdata;
        }else{
            if(key_down&=shiftdata)//KEYUP
            {
                //KEY_DEF[i-4]      ====key_code is.
                NSLog(@"%d KEYUP",(i-4));
                
                key_down&=(~shiftdata);
            }
        }
    }
}
 */
@end
