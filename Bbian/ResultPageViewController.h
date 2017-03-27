//
//  ResultPageViewController.h
//  Bbian
//
//  Created by dengwt on 2017/3/14.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildSolidPageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "KCAnnotation.h"
#import "SendtoServer.h"

@interface ResultPageViewController : UIViewController
@property(strong,nonatomic)NSString *solidTitle;
@property(strong,nonatomic)NSString *solidDescibe;
@property(strong,nonatomic) UIImage* solidImage;

@property CLLocation * _location;
@property CLLocationCoordinate2D clocation;
@end
