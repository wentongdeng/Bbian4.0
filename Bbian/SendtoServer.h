//
//  SendtoServer.h
//  Bbian
//
//  Created by dengwt on 2017/3/16.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Networking/Networking.h"

@interface SendtoServer : NSObject
//应该把照片拍摄的时间加入进去，为了避免麻烦还是用系统时间好了，以后再根据需要改进
//类方法实现图片上传，附图片拍摄的地点，标题，描述等等

+(BOOL)sendMessage:(UIImage*)image title:(NSString*)title describe:(NSString*)describe url:(NSString*)url location:(CLLocation*)location;
@end
