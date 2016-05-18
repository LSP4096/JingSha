//
//  locationTableViewCell.m
//  JingSha
//
//  Created by 周智勇 on 15/12/14.
//  Copyright © 2015年 bocweb. All rights reserved.
//

#import "locationTableViewCell.h"

@interface locationTableViewCell ()

@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)CLGeocoder * geocoder;
@end

@implementation locationTableViewCell

- (void)awakeFromNib {
    [self initializeLocationService];
    
}

/**
 *  定位
 */
- (void)initializeLocationService {
    // 初始化定位管理器
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    if (![CLLocationManager locationServicesEnabled]) {
        MyLog(@"没有打开定位服务");
        return;
    }
    if([[[UIDevice currentDevice]systemVersion]doubleValue]>8.0)
    {
        [_locationManager requestWhenInUseAuthorization];
    }

    MyLog(@"location status %zd", [CLLocationManager authorizationStatus]);
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied){//授权状态未定
        [_locationManager startUpdatingLocation];
    }
    if([CLLocationManager authorizationStatus]== kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager startUpdatingLocation];
    }
}
#pragma mark -- 定位获取城市名字显示到GPS定位的地方
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
//    MyLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
//        MyLog(@"详细信息:%@",placemark.addressDictionary);
        if (placemark.name != nil) {
            self.locationCityLable.text = placemark.locality;
//            if (self.delegate && [self.delegate respondsToSelector:@selector(getLocation:)]) {
//                [self.delegate getLocation:placemark.locality];
//            } 
        }else{
            self.locationCityLable.text = @"定位中";
        }
        if (self.myBlock) {
            self.myBlock(placemark.locality);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        MyLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        MyLog(@"无法获取位置信息");
    }
}
@end
