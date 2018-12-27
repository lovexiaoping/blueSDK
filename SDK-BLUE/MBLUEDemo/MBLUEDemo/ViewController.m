//
//  ViewController.m
//  MBLUEDemo
//
//  Created by dinglp on 2018/10/29.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<MBlueSDKManagerDelegate>
{
   
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBLUESDK sharedMBlueSDK].delegate = self;
    [[MBLUESDK sharedMBlueSDK] startConnectBlueService];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)UpdateMBMocutCadeEvent:(MBMocutCadeEvent*)event{
    
    NSLog(@"按键编号:%ld --- 按下/起来:%d",event.keyType,event.pressed);
    
//    [self sendGamePadcodeMB:event.keyType Pressed:event.pressed];

}
/*

-(void)sendGamePadcodeMB:(MBMocutCadeType)Code Pressed:(BOOL)isPressed{
    
    iCadeState button = iCadeJoystickNone;
    switch (Code) {
        case MBMocutCade_A:
            button = iCadeButtonB;
            break;
        case MBMocutCade_B:
            button = iCadeButtonC;
            break;
        case MBMocutCade_X:
            button = iCadeButtonA;
            break;
        case MBMocutCade_Y:
            button = iCadeButtonD;
            break;
        case MBMocutCade_UP:
            button = iCadeDpadUp;
            break;
        case MBMocutCade_DOWN:
            button = iCadeDpadDown;
            break;
        case MBMocutCade_LEFT:
            button = iCadeDpadLeft;
            break;
        case MBMocutCade_RIGHT:
            button = iCadeDpadRight;
            break;
        case MBMocutCade_SELECT:
            button = iCadeButtonG;
            break;
        case MBMocutCade_START:
            button = iCadeButtonH;
            break;
        case MBMocutCade_L2:
            button = iCadeButtonL2;
            break;
        case MBMocutCade_L1:
            button = iCadeButtonE;
            break;
        case MBMocutCade_R2:
            button = iCadeButtonR2;
            break;
        case MBMocutCade_R1:
            button = iCadeButtonF;
            break;
        default:
            break;
    }
    
    [self sendIcadeStateToGame:button isDown:isPressed];
    
}
*/
- (void)UpdateMBMocutStickEvent:(MBMocutStickEvent*)event{
    if (event.stickType == MBLEFT_STICK) {
        NSLog(@"左遥感 X:%ld Y:%ld 中心:%d",event.x,event.y,event.isCenter);
        
    }
    if (event.stickType == MBRIGHT_STICK) {
        NSLog(@"右遥感 X:%ld Y:%ld 中心:%d",event.x,event.y,event.isCenter);
    }

}

















-(void)skdjfksdj:(NSString*)hh{
    NSLog(@"=======111=========");
    
    u_int16_t keydata,key_down;
    u_int16_t shiftdata;
    u_int8_t i,keydir;
    
    //    NSString* ss = @"a106 8080 8080 0100 000000000000000000000000";
    
    //    NSString *v3 = [value2 substringWithRange:NSMakeRange(8, 4)];
    
    /*
     
     Byte keybuf[20] ;
     for (int j=0; j<20; j++) {
     keybuf[j]=[ss characterAtIndex:j];
     }
     */
    
    Byte keybuf[10] ;
    
    keybuf[0] = 0xb1;
    keybuf[1] = 0x06;
    
    keybuf[2] = 0x80;
    keybuf[3] = 0x80;
    
    keybuf[4] = 0x80;
    keybuf[5] = 0x80;
    
    keybuf[6] = 0x05;
    keybuf[7] = 0x00;
    
    keybuf[8] = 0x00;
    keybuf[9] = 0x00;
    
 
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

@end
