//
//  HorizontalViewController.m
//  AsyncThread
//
//  Created by JianRongCao on 15/12/9.
//  Copyright © 2015年 JianRongCao. All rights reserved.
//

#import "HorizontalViewController.h"

@interface HorizontalViewController ()
{
    UILabel *name;
}
@end

@implementation HorizontalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    name = [[UILabel alloc] init];
    name.frame = CGRectMake(0, 100, 100, 20);
    name.textColor = [UIColor redColor];
    name.text = @"第二个页面";
    [self.view addSubview:name];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(changeOrientation:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
    
}

- (BOOL)shouldAutorotate
{
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

//- (void)changeOrientation:(NSNotification *)noti
//{
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
//        NSLog(@"很胖");
//        
//        name.transform = CGAffineTransformMakeRotation( - M_PI_2);
//        
//    }
//    NSLog(@"%.2f-%.2f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSLog(@"layout %.2f-%.2f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    NSLog(@"%d",[[UIDevice currentDevice] orientation]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
