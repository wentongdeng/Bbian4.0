//
//  TrendsPageViewController.m
//  Bbian
//
//  Created by dengwt on 2017/3/14.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "TrendsPageViewController.h"

@interface TrendsPageViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *convenientButton;
@property (strong, nonatomic) IBOutlet UIButton *maintenanceButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSArray* content;
@property (strong,nonatomic) NSString* url;
@property (strong,nonatomic) CLLocationManager* locationManager;
@end

@implementation TrendsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    _mapView.delegate=self;
    if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    [self setData];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUI{
    if(_content!=NULL){
        _content=self.content;
        [self addAnnotation:_content];
    }
}
-(void)setData{
    _url=@"localhost";
    NSString* extendUrl=[NSString stringWithFormat:@"?latitude=%f&longitude=%f",_clocation.latitude,_clocation.longitude];
    _url=[_url stringByAppendingString:extendUrl];
}
//将地址输入到请求里面

-(void)addAnnotation:(NSArray*)content{
    for (KCAnnotation *annotation in content) {
        [_mapView addAnnotation:annotation];
    }
}
-(NSArray*)content{
//    NSArray *dicArray=[[[ReceivefromServer alloc]init]reveicefromServer:_url];
    NSMutableArray *arr = [NSMutableArray array];
//    for (NSDictionary *dic in dicArray) {
//        KCAnnotation *annotation=[[KCAnnotation alloc]init];
//        [annotation setValuesForKeysWithDictionary:dic];
//        [arr addObject:annotation];
//    }
    return arr;
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[KCAnnotation class]]) {
        static NSString* key=@"Annotation";
        MKAnnotationView* annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key];
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key];
            annotationView.canShowCallout=YES;
            annotationView.calloutOffset=CGPointMake(0, 1);
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apple_filled-25.png"]];
        }
        annotationView.annotation=annotation;
        annotationView.image=((KCAnnotation*)annotation).image;
        return annotationView;
    }else{
        return nil;
    }
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

//根据不同按钮赋不同的值
-(IBAction)trendsButton:(UIButton*)sender{
    if (sender.tag==0) {
        
    }else if (sender.tag==1){
        searchController *searchPage=[[searchController alloc]init];
        searchPage.url=@"localhost";
//        [self.navigationController pushViewController:searchPage animated:YES];
    }else if (sender.tag==2){
        searchController *searchPage=[[searchController alloc]init];
        searchPage.url=@"localhost";
//        [self.navigationController pushViewController:searchPage animated:YES];
    }else if (sender.tag==3){
        searchController *searchPage=[[searchController alloc]init];
        searchPage.url=@"localhost";
//        [self.navigationController pushViewController:searchPage animated:YES];
    }else if (sender.tag==4){
        searchController *searchPage=[[searchController alloc]init];
        searchPage.url=@"localhost";
        [self.navigationController pushViewController:searchPage animated:YES];
    }else if (sender.tag==5){
        searchController *searchPage=[[searchController alloc]init];
        searchPage.url=@"localhost";
        [self.navigationController pushViewController:searchPage animated:YES];
    }
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
