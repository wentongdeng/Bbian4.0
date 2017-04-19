//
//  searchController.m
//  Bbian
//
//  Created by dengwt on 2017/4/3.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "searchController.h"

@interface searchController ()<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSArray* content;
@property (strong,nonatomic) CLLocationManager* locationManager;


@end

@implementation searchController
@synthesize url;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
    _mapView.delegate=self;
    [self setData];
    [self setUI];
    // Do any additional setup after loading the view.
}
-(NSArray*)content{
//    NSArray* con=[[[ReceivefromServer alloc]init] reveicefromServer:url];
    NSMutableArray* arr=[[NSMutableArray alloc]init];
//    for(NSDictionary* dic in con){
//        KCAnnotation *annotation=[[KCAnnotation alloc]init];
//        [annotation setValuesForKeysWithDictionary:dic];
//        [arr addObject:annotation];
//    }
    return arr;
}
-(void)setUI{
    [self addAnnotation:self.content];
}

-(void)addAnnotation:(NSArray*)array{
    for(KCAnnotation * annotation in array){
        [_mapView addAnnotation:annotation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@",userLocation);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //    [_mapView setRegion:region animated:true];
    _clocation=[userLocation coordinate];
    //    if ((_clocation.longitude=0.0000000)||(_clocation.latitude=0.0000000)) {
    //        NSLog(@"经纬度再次获取失败");
    //    }
//    [self addAnnotation];
//    NSLog(@"%f and %f",_clocation.latitude,_clocation.longitude);
}
-(void)setData{
    NSString* extendUrl=[NSString stringWithFormat:@"?latitude=%f&longitude=%f",_clocation.latitude,_clocation.longitude];
    url=[url stringByAppendingString:extendUrl];
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
