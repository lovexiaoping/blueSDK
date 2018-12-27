//
//  MocuteCadeState.h
//  MBLUESDK
//
//  Created by dinglp on 2018/10/29.
//  Copyright © 2018年 leo. All rights reserved.
//

#ifndef MocuteCadeState_h
#define MocuteCadeState_h

/*
 握手协议
 APP->手柄 UUID(1001) B5A1 请求连接
 手柄->APP UUID(1001) C1AA 连接成功
 
键值
 
BYTE  VALUE  DES
 0     0*A1  ID-HEAD 标识
 1     0*06  ID-HEAD 标识
 2     0-255 左摇杆X，中间值128
 3     0-255 左摇杆Y，中间值128
 4     0-255 右摇杆X，中间值128
 5     0-255 右摇杆Y，中间值128
 6     bit：0-3四方向键 空0 1上 2右上 3右 4右下 5下 6左下 7左 8左上
       bit：4-7， bit4：A bit5:B bit6：X bit7：Y
 7     0-7 bit0:L1  bit1:R1  bit2:SELECT bit3:START
 8     L2      按下255 抬起0
 9     R2      按下255 抬起0
 
 
 
 判断摇杆归中：要X,Y同时为128才为松开，为了保证归中，手柄发至少发3-5次归中值。
 
*/




#endif /* MocuteCadeState_h */
