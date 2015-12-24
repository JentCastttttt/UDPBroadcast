//
//  ViewController.m
//  UDPSocket
//
//  Created by JianRongCao on 15/12/17.
//  Copyright © 2015年 JianRongCao. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"

@interface ViewController ()<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *scoket;
    NSInteger count;
    NSMutableString *param;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    scoket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self
                                        delegateQueue:dispatch_get_global_queue(0, 0)];
    NSError *error = nil;
    [scoket enableBroadcast:YES error:&error];
    if (error) {
        return ;
    }
    
    NSString *portString = @"1985";
    UInt16 port = [portString intValue];
    [scoket bindToPort:port error:&error];
    if (error) {
        return ;
    }
    
    [scoket beginReceiving:&error];
    if (error) {
        return ;
    }

    count = 1;
    BOOL success = [scoket joinMulticastGroup:@"224.0.0.1" error:&error];
    if (success) {
        NSLog(@"连接成功");
        //全网发广播255.255.255.255   单独发：某个IP
        [scoket sendData:[self requestData:count] toHost:@"255.255.255.255" port:1985 withTimeout:-1 tag:1001];
        
    } else {
        NSLog(@"%@",error);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    count ++ ;
    [scoket sendData:[self requestData:count] toHost:@"255.255.255.255" port:1985 withTimeout:-1 tag:1001];
}

- (NSData *)requestData:(NSInteger)requestCount
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:requestCount] forKey:@"stepNum"];
    while (requestCount) {
        NSString *value = [NSString stringWithFormat:@"000%ld",requestCount];
        NSString *key = [NSString stringWithFormat:@"%ldth",requestCount - 1];
        [dic setValue:value forKey:key];
        --requestCount;
    }
    NSData *sendData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return sendData;
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection is successful.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSLog(@"%@",address);
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    NSLog(@"%@",error);
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"%@",sock);
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%@",error);
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"address %@",[GCDAsyncUdpSocket hostFromAddress:address]);
    NSLog(@"data is %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
