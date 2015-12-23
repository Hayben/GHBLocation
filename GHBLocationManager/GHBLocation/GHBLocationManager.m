//
//  GHBLocationManager.m
//  GHBLocationManager
//
//  Created by 123 on 15/12/22.
//  Copyright © 2015年 haibin. All rights reserved.
//

#import "GHBLocationManager.h"
#import "CLLocation+GHBLocation.h"

@interface GHBLocationManager (){
    CLLocationManager *_manager;
}

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end

@implementation GHBLocationManager

+ (CLLocationManager *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _shareObject = nil;
    dispatch_once(&pred, ^{
        _shareObject = [[self alloc]init];
    });
    return _shareObject;
}
- (id)init{
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:GHBLastLongitude];
        float latitude = [standard floatForKey:GHBLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude, latitude);
        self.lastCity = [standard objectForKey:GHBLastCity];
        self.lastAddress=[standard objectForKey:GHBLastAddress];
    }
    return self;
}

//获取经纬度
- (void)getLocationCoordinate:(LocationBlock)locationtBlock{
    self.locationBlock = [locationtBlock copy];
    [self startLocation];
    
}
- (void)getLocationCoordinate:(LocationBlock)locationtBlock WithAddress:(NSStringBlock)addressBlock{
    self.locationBlock = [locationtBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}
- (void)getAddress:(NSStringBlock)addressBlock{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}
//获取省市
- (void)getCity:(NSStringBlock)cityBlock{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

#pragma mark ---- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    CLLocation *marsLoction = [location locationMarsFromEarth];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:marsLoction completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            _lastCity = placemark.locality;
            [standard setObject:_lastCity forKey:GHBLastCity];//省市地址
            NSLog(@"______%@",_lastCity);
            _lastAddress = placemark.name;
            NSLog(@"______%@",_lastAddress);
        }
        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }
        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
    }];
    _lastCoordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude, marsLoction.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock (_lastCoordinate);
        _locationBlock = nil;
    }
    [standard setObject:@(marsLoction.coordinate.latitude) forKey:GHBLastLatitude];
    [standard setObject:@(marsLoction.coordinate.longitude) forKey:GHBLastLongitude];
    
    [manager stopUpdatingLocation];
}

- (void)startLocation{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] !=kCLAuthorizationStatusDenied) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager requestAlwaysAuthorization];
        _manager.distanceFilter=10;
        [_manager startUpdatingLocation];
    }else{
        UIAlertView *alverView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alverView show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error{
    [self stopLocation];
}


- (void)stopLocation{
    _manager = nil;
}



@end
