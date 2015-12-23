//
//  GHBLocationManager.h
//  GHBLocationManager
//
//  Created by 123 on 15/12/22.
//  Copyright © 2015年 haibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define  GHBLastLongitude @"GHBLastLongitude"
#define  GHBLastLatitude  @"GHBLastLatitude"
#define  GHBLastCity      @"GHBLastCity"
#define  GHBLastAddress   @"GHBLastAddress"

typedef void (^LocationBlock) (CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void (^NSStringBlock) (NSString *cityString);
typedef void (^NSStringBlock) (NSString *addressString);


@interface GHBLocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic, strong) NSString *lastCity;
@property (nonatomic, strong) NSString *lastAddress;

@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

+ (GHBLocationManager *)shareLocation;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void)getLocationCoordinate:(LocationBlock) locationtBlock;

/**
 *  获取坐标和详细地址
 *
 *  @param locaiontBlock locaiontBlock description
 *  @param addressBlock  addressBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locationtBlock WithAddress:(NSStringBlock)addressBlock;

/**
 *  获取详细地址
 *
 *  @param addressBlock addressBlock description
 */
- (void)getAddress:(NSStringBlock)addressBlock;

/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock;

@end
