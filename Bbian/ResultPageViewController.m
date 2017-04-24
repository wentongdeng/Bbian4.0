//
//  ResultPageViewController.m
//  Bbian
//
//  Created by dengwt on 2017/3/14.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "ResultPageViewController.h"
//I don't know whether the UINavigationControllerDelegate is in neeed
@interface ResultPageViewController ()<UINavigationControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    }

@property NSInteger count;
@end

@implementation ResultPageViewController
@synthesize _location;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    _count=1;
    [self initGUI];
}

#pragma mark 添加地图控件
-(void)initGUI{
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
    [_locationManager startUpdatingLocation];

    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    //添加大头针
}

#pragma mark 添加大头针
-(void)addAnnotation{
    
    KCAnnotation *annotation1=[[KCAnnotation alloc]init];
    annotation1.title=_solidTitle;
    annotation1.subtitle=_solidDescibe;
    annotation1.coordinate=_clocation;
    NSLog(@"到了这边地址是%@",_location);
    annotation1.image=[UIImage imageNamed:@"barber_brush_filled-25.png"];
    [_mapView addAnnotation:annotation1];
    
    
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
   if (annotation == mapView.userLocation){
        return nil;
    }
    if ([annotation isKindOfClass:[KCAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apple_filled-25.png"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((KCAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else {
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
    if (_count<2) {
        [self addAnnotation];
        [SendtoServer sendMessage:_solidImage title:_solidTitle describe:_solidDescibe url:@"http://localhost:8080/Bian04/listExtendMassage" location:_location];
        [_locationManager stopUpdatingLocation];
    }
    _count=_count+1;
    
    NSLog(@"%f and %f",_clocation.latitude,_clocation.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
