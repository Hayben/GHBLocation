//
//  ViewController.m
//  GHBLocationManager
//
//  Created by 123 on 15/12/22.
//  Copyright © 2015年 haibin. All rights reserved.
//

/*集成说明：
 
 1、在plist添加
 NSLocationAlwaysUsageDescription ＝ YES
 NSLocationWhenInUseUsageDescription ＝ YES
 2、导入CCLocationManager.h头文件
 3、通过block回调获取经纬度、地理位置等
 
 */

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#import "ViewController.h"
#import "GHBLocationManager.h"

@interface ViewController ()<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationManager = [[CLLocationManager alloc]init];
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        locationManager.delegate = self;
    }
}
- (IBAction)getLat:(id)sender {
    __block __weak ViewController *wself = self;
    if (IS_IOS8) {
        [[GHBLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            [wself setLabelText:[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]];
        }];
    }
}
- (IBAction)getCity:(id)sender {
    __block __weak ViewController *wself = self;
    if (IS_IOS8) {
        [[GHBLocationManager shareLocation]getCity:^(NSString *cityString) {
            [wself setLabelText:cityString];
        }];
    }
}
- (IBAction)getAllInfo:(id)sender {
    __block NSString *string;
    __block __weak ViewController *wself = self;
    if (IS_IOS8) {
        [[GHBLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        } WithAddress:^(NSString *addressString) {
            string = [NSString stringWithFormat:@"%@\n%@",string,addressString];
            [wself setLabelText:string];
        }];
    }
}
- (void)setLabelText:(NSString *)info{
    _textLabel.text = info;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
