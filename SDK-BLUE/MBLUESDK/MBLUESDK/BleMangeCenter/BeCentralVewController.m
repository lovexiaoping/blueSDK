//
//  BeCentraliewController.m
//  BleDemo
//
//  Created by ZTELiuyw on 15/9/7.
//  Copyright (c) 2015年 liuyanwei. All rights reserved.
//

/*
 00001000-E619-419B-BC43-821E71A409B7   连接uuid
 服务以下:
 1. 00001001-E619-419B-BC43-821E71A409B7   权限：写/广播
    uuid==1001时，写入B5A1，开启广播 ，则1001会收到C1AA的广播消息 则握手成功
 2. 00001002-E619-419B-BC43-821E71A409B7   权限：广播
    uuid==1002时，则开启广播模式，接收设备发送到广播消息

 
 
 
 按键复位:  a106808080800000000000000000000000000000
 
 上:a106808080800100000000000000000000000000
 下:a106808080800400000000000000000000000000
 左:a106808080800800000000000000000000000000
 右:a106808080800200000000000000000000000000
 
 
 A:a106808080801000000000000000000000000000
 B:a106808080802000000000000000000000000000
 X:a106808080804000000000000000000000000000
 Y:a106808080808000000000000000000000000000
 
 SELECT:a106808080800004000000000000000000000000
 START:  a106808080800008000000000000000000000000
 
 M: a106808080800f00000900000000000000000000
 L1:a106808080800001000000000000000000000000
 L2:a106808080800040ff0000000000000000000000
 R1:a106808080800002000000000000000000000000
 R2:a10680808080008000ff00000000000000000000
 
 
 红色为摇杆变化值
 左摇杆:a1069e0080800000000000000000000000000000
 右摇杆:a106808009380000000000000000000000000000
 
 */
#import "BeCentralVewController.h"
#import "MBCadeValueManage.h"


@interface BeCentralVewController (){
    CBCharacteristic* lockUnlockCharacteristic;
}
@property(nonatomic,strong)CBCentralManager *manager;
@property(nonatomic,strong)CBCharacteristic* lockUnlockCharacteristic;//characteristic
@property(nonatomic,strong)CBPeripheral* myPeripheral;
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,assign)BOOL isConnectB;
@end

@implementation BeCentralVewController

static BeCentralVewController *BlueToothGamepad;

+ (instancetype)sharedInstanceDLPBlueToothGamepad
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BlueToothGamepad = [[self alloc] init];
    });
    
    return BlueToothGamepad;
}



#define SERVICE_UUID @"00001000-E619-419B-BC43-821E71A409B7"
#define SERVICE1_UUID @"00001001-E619-419B-BC43-821E71A409B7"
#define SERVICE2_UUID @"00001002-E619-419B-BC43-821E71A409B7"
#define PERIPHERAL_NAME @"MOCUTE-054-PUBG"

-(void)startConnectBlueService{
    //初始化并设置委托和线程队列，最好一个线程的参数可以为nil，默认会就main线程
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    _manager.delegate = self;
    
    //检查该设备是否已经被连接  如果没有连接蓝牙打开后：PoweredOn 直接全部扫描，否则discover已经连上的外设服务
    _arr = [_manager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]]];
    _isConnectB = NO;
    if (_arr) {  if (_arr.count>0) {
        _isConnectB = YES;
    }
    }
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
            // 蓝牙可用，开始扫描外设
//        case CBCentralManagerStatePoweredOn: 10.0以下
        case CBManagerStatePoweredOn://IOS 10_0
        {
            //NSLog(@"蓝牙可用，开始扫描外设");
            if (_isConnectB) {
                [_manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
                [_arr enumerateObjectsUsingBlock:^(CBPeripheral *peripheral, NSUInteger idx, BOOL *stop) {
                    //NSLog(@"连接===%@ %lu   /n%@",peripheral,(unsigned long)idx,peripheral.services);
                    [self discoverANCS:peripheral];
                }];
                
            }else{
                [_manager scanForPeripheralsWithServices:nil options:nil];
            }
        }
            break;
        case CBCentralManagerStatePoweredOff://I
        {
            //NSLog(@"蓝牙没有打开");
            NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                //                if ([[[UIDevice currentDevice] systemVersion] floatValue]>=10.0) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    }];
                } else {
                    
                    [[UIApplication sharedApplication] openURL:url];
                    
                    // Fallback on earlier versions
                }
            }
                
        }
            break;
        default:
            break;
    }
}


- (void)discoverANCS:(CBPeripheral *)peripheral{
    [self centralManager:_manager
   didDiscoverPeripheral:peripheral
       advertisementData:[NSDictionary dictionary]
                    RSSI:@(0)];
}

/** 扫描到外设 发现符合要求的外设，回调 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSString *localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    //NSLog(@"当扫描到设备:%@/%@,UUID:%@",localName,peripheral.name,peripheral.identifier.UUIDString);
    //筛选连接蓝牙设备
    if ([peripheral.name hasPrefix:PERIPHERAL_NAME]){
        _myPeripheral = peripheral;
        _myPeripheral.delegate = self;
        // 连接外设
        [_manager connectPeripheral:peripheral options:nil];
    }
}

#pragma mark --- 连接状态协议
/** 连接失败的回调 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

/** 断开连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
//    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    NSDictionary *device = @{@"deviceName":peripheral.name};
    // 断开连接可以设置重新连接
    [central connectPeripheral:peripheral options:nil];
    if ([MBLUESDK sharedMBlueSDK].delegate && [[MBLUESDK sharedMBlueSDK].delegate respondsToSelector:@selector(didControllerConnected:)]){
        [[MBLUESDK sharedMBlueSDK].delegate didControllerDisconnected:device];
    }
    
}
/** 连接成功 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//    NSLog(@"连接成功 设备:%@",peripheral.name);
    NSDictionary *device = @{@"deviceName":peripheral.name};
    if ([MBLUESDK sharedMBlueSDK].delegate && [[MBLUESDK sharedMBlueSDK].delegate respondsToSelector:@selector(didControllerConnected:)]){
        [[MBLUESDK sharedMBlueSDK].delegate didControllerConnected:device];
    }
    
    //停止扫描动作
    [_manager stopScan];
    // 设置外设的代理
    [_myPeripheral setDelegate:self];
    // 根据UUID来寻找服务
    [_myPeripheral discoverServices:nil];//传nil代表不过滤，一次性读出外设的所有服务
   
}

//7、获取外围设备服务和特征
/** 发现服务 扫描到Services */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    // 遍历出外设中所有的服务
    for (CBService *service in peripheral.services) {
         //NSLog(@"DiscoverServices所有的服务：service:%@  service.UUID:%@ ",service,service.UUID);
         [peripheral discoverCharacteristics:nil forService:service];
    }
    
}
//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    for (CBCharacteristic *characteristic in service.characteristics){
         //NSLog(@"特征 UUID: %@ (%@)", characteristic.UUID.data, characteristic.UUID);
        if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:SERVICE1_UUID]]){
          //NSLog(@"找到可写特征: %@", characteristic);
          [peripheral setNotifyValue:YES forCharacteristic:characteristic];
          self.lockUnlockCharacteristic = characteristic;
          if (characteristic.properties & CBCharacteristicPropertyWrite){
                [self sendDataToBle];
            }
         }if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:SERVICE2_UUID]]){
             [peripheral setNotifyValue:YES forCharacteristic:characteristic];
         }
//        NSData* data = characteristic.value;
//        NSString* value = [self hexadecimalString:data];
//        NSLog(@"service:%@ 的 Characteristic: %@  %@",service.UUID,characteristic.UUID,value);
    }
}
//8、从外围设备读取数据
/** 接收到数据回调 */
//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    //NSLog(@"characteristic uuid:%@  value:%@",characteristic.UUID,[self hexadecimalString:characteristic.value]);
    if ([[characteristic UUID].UUIDString containsString:@"821E71A409B7"]){
        NSData *data = characteristic.value;
        NSString *value = [self hexadecimalString:data];
        //a106 80808080200000000000   0000000000000000
        if (value.length>16) {
           
            [[MBCadeValueManage sharedMBCadeValueManage] ReceivedBluHexValTest:value];            
          
        }
        
        
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    [peripheral readValueForCharacteristic:characteristic]; //12.23新增
    [peripheral discoverDescriptorsForCharacteristic:characteristic];
    
}


//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    for (CBDescriptor *d in characteristic.descriptors) {
//        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
    
}
//获取到Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
   // NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],[self hexadecimalString:descriptor.value]);
//    [peripheral readValueForDescriptor:descriptor]; //12.23新增
    [self notifyCharacteristic:peripheral characteristic:self.lockUnlockCharacteristic];

}
// 9、向外围设备发送（写入）数据
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    //NSLog(@"didWriteValueForCharacteristic:%@",[characteristic.UUID UUIDString]);
    if (!error) {
        //NSLog(@"写入成功%@",characteristic);
    }
    [self notifyCharacteristic:peripheral characteristic:characteristic];
}

//设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    
}

//取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

//停止扫描并断开连接
-(void)disconnectPeripheral:(CBCentralManager *)centralManager
                 peripheral:(CBPeripheral *)peripheral{
    //停止扫描
    [centralManager stopScan];
    //断开连接
    [centralManager cancelPeripheralConnection:peripheral];
}
-(void)sendDataToBle{
    //NSLog(@"执行方法:sendDataToBle");
    NSData* lockValue = [self convertHexStrToData:@"B5A1"];
    if (self.lockUnlockCharacteristic) {
        //NSLog(@"写数据 Peripheral writeValue = %@",lockValue);
        [_myPeripheral writeValue:lockValue forCharacteristic:self.lockUnlockCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}
// 16进制转NSData
- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
         return nil;
    }
    NSUInteger dataLength = [data length];
         NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
       }
    result = [NSString stringWithString:hexString];
    

    return result;
}


//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
