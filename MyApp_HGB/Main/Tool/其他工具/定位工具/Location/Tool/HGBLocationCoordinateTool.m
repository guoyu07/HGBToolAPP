//
//  HGBLocationCoordinateTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBLocationCoordinateTool.h"

@implementation HGBLocationCoordinateTool
#pragma mark map纠错
#pragma mark 地理位置坐标转换距离

+(double)distanceBetweenOrderByCurrentLocationLatitude:(double)lat1 Longitude:(double)lng1 andWithOtherLocationLatitude:(double)lat2 Longitude:(double)lng2{
    CLLocationCoordinate2D currnetCoordinate=CLLocationCoordinate2DMake(lat1, lng1);
    currnetCoordinate=[HGBLocationCoordinateTool transformFromGCJToWGS:currnetCoordinate];
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:currnetCoordinate.latitude longitude:currnetCoordinate.longitude];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}
//地理位置转换
+(double)distanceBetweenOrderByCurrentCoordinate2D:(CLLocationCoordinate2D)curCoordinate ToOtherCoordinate2D:(CLLocationCoordinate2D)otherCoordinate{
    return [HGBLocationCoordinateTool distanceBetweenOrderByCurrentLocationLatitude:curCoordinate.latitude Longitude:curCoordinate.longitude andWithOtherLocationLatitude:otherCoordinate.latitude Longitude:otherCoordinate.longitude];
}
#pragma mark 地理位置纠错
static const double a = 6378245.0;

static const double ee = 0.00669342162296594323;

static const double pi = 3.14159265358979324;

static const double xPi = M_PI * 3000.0 / 180.0;

+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc

{

    CLLocationCoordinate2D adjustLoc;

    if([HGBLocationCoordinateTool isLocationOutOfChina:wgsLoc])

    {

        adjustLoc = wgsLoc;

    }

    else

    {

        double adjustLat = [HGBLocationCoordinateTool transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];

        double adjustLon = [HGBLocationCoordinateTool transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];

        long double radLat = wgsLoc.latitude / 180.0 * pi;

        long double magic = sin(radLat);

        magic = 1 - ee * magic * magic;

        long double sqrtMagic = sqrt(magic);

        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);

        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);

        adjustLoc.latitude = wgsLoc.latitude + adjustLat;

        adjustLoc.longitude = wgsLoc.longitude + adjustLon;

    }

    return adjustLoc;

}

+ (double)transformLatWithX:(double)x withY:(double)y

{

    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));

    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;

    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;

    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;

    return lat;

}

+ (double)transformLonWithX:(double)x withY:(double)y

{

    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));

    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;

    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;

    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;

    return lon;

}

+(CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p

{

    long double z = sqrt(p.longitude * p.longitude + p.latitude * p.latitude) + 0.00002 * sqrt(p.latitude * pi);

    long double theta = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * pi);

    CLLocationCoordinate2D geoPoint;

    geoPoint.latitude= (z * sin(theta) + 0.006);

    geoPoint.longitude = (z * cos(theta) + 0.0065);

    return geoPoint;

}

+(CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p

{

    double x = p.longitude - 0.0065, y = p.latitude - 0.006;

    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);

    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);

    CLLocationCoordinate2D geoPoint;

    geoPoint.latitude = z * sin(theta);

    geoPoint.longitude = z * cos(theta);

    return geoPoint;

}

+(CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p

{

    double threshold = 0.00001;

    // The boundary

    double minLat = p.latitude - 0.5;

    double maxLat = p.latitude + 0.5;

    double minLng = p.longitude - 0.5;

    double maxLng = p.longitude + 0.5;

    double delta = 1;

    int maxIteration = 30;

    // Binary search

    while(1)

    {

        CLLocationCoordinate2D leftBottom= [HGBLocationCoordinateTool transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude=minLng}];

        CLLocationCoordinate2D rightBottom = [HGBLocationCoordinateTool transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = maxLng}];

        CLLocationCoordinate2D leftUp= [HGBLocationCoordinateTool transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = maxLat,.longitude = minLng}];

        CLLocationCoordinate2D midPoint= [HGBLocationCoordinateTool transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2),.longitude = ((minLng + maxLng) / 2)}];

        delta = fabs(midPoint.latitude - p.latitude) + fabs(midPoint.longitude - p.longitude);

        if(maxIteration-- <= 0 || delta <= threshold)

        {

            return (CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2),.longitude = ((minLng + maxLng) / 2)};

        }

        if(isContains(p, leftBottom, midPoint))

        {

            maxLat = (minLat + maxLat) / 2;

            maxLng = (minLng + maxLng) / 2;

        }

        else if(isContains(p, rightBottom, midPoint))

        {

            maxLat = (minLat + maxLat) / 2;

            minLng = (minLng + maxLng) / 2;

        }

        else if(isContains(p, leftUp, midPoint))

        {

            minLat = (minLat + maxLat) / 2;

            maxLng = (minLng + maxLng) / 2;

        }

        else

        {

            minLat = (minLat + maxLat) / 2;

            minLng = (minLng + maxLng) / 2;

        }

    }

}

static bool isContains(CLLocationCoordinate2D point, CLLocationCoordinate2D p1, CLLocationCoordinate2D p2)

{

    return (point.latitude >= MIN(p1.latitude, p2.latitude) && point.latitude <= MAX(p1.latitude, p2.latitude)) && (point.longitude >= MIN(p1.longitude,p2.longitude) && point.longitude <= MAX(p1.longitude, p2.longitude));

}

/**

 *  判断是不是在中国

 */

+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location

{

    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)

        return YES;

    return NO;

}
@end
