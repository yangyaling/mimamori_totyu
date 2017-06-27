//
//  ZworksChartModel.m
//  Mimamori
//
//  Created by NISSAY IT on 16/6/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "ZworksChartModel.h"

@implementation ZworksChartModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_picpath forKey:@"picpath"];
    [aCoder encodeObject:_deviceid forKey:@"deviceid"];
    [aCoder encodeObject:_devicename forKey:@"devicename"];
    [aCoder encodeObject:_deviceunit forKey:@"deviceunit"];
    [aCoder encodeObject:_latestvalue forKey:@"latestvalue"];
    [aCoder encodeObject:_devicevalues forKey:@"devicevalues"];
    [aCoder encodeObject:_batterystatus forKey:@"batterystatus"];
//    [aCoder encodeObject:_subdeviceinfo forKey:@"subdeviceinfo"];
    
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        _picpath = [aDecoder decodeObjectForKey:@"picpath"];
        _deviceid = [aDecoder decodeObjectForKey:@"deviceid"];
        _devicename = [aDecoder decodeObjectForKey:@"devicename"];
        _deviceunit = [aDecoder decodeObjectForKey:@"deviceunit"];
        _latestvalue = [aDecoder decodeObjectForKey:@"latestvalue"];
        _devicevalues = [aDecoder decodeObjectForKey:@"devicevalues"];
        _batterystatus = [aDecoder decodeObjectForKey:@"batterystatus"];
//        _subdeviceinfo = [aDecoder decodeObjectForKey:@"subdeviceinfo"];
        
       
    }
    return self;
}

@end
