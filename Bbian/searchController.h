//
//  searchController.h
//  Bbian
//
//  Created by dengwt on 2017/4/3.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentViewModel.h"
#import "Moments.h"
#import "MomentsTableViewCell.h"
#import "MJRefresh.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ReceivefromServer.h"
#import "KCAnnotation.h"

@interface searchController : UIViewController

@property (strong,nonatomic) NSString* url;
@property CLLocationCoordinate2D clocation;

@end
