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
@property CLLocationCoordinate2D clocationcord;

@end
//在调用这个controller的时候就要先赋值
@implementation searchController
@synthesize url;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    _locationManager=[[CLLocationManager alloc]init];
    url=@"http://10.151.254.125:8080/Bian07/listMap";
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    _mapView.delegate=self;
//    [self setData];
    [self setUI];
    // Do any additional setup after loading the view.
}
-(NSArray*)content:(NSArray*)con{
    NSMutableArray* arr=[[NSMutableArray alloc]init];
    for(NSDictionary* dic in con){
        KCAnnotation *annotation=[[KCAnnotation alloc]init];
        //重新setValuesForKeysWithDictionary，不然CLLocationCoordinate2D应该无法赋值
        annotation.image=[UIImage imageNamed:[dic objectForKey:@"image"]];
        annotation.title=[dic objectForKey:@"title"];
        annotation.subtitle=[dic objectForKey:@"subtitle"];
        NSString* la=[dic objectForKey:@"latitude"];
        _clocationcord.latitude=la.doubleValue;
        la=[dic objectForKey:@"longitude"];
        _clocationcord.longitude=la.doubleValue;
        annotation.coordinate=_clocationcord;
        [arr addObject:annotation];
    }
    return arr;
}


- (void)reveicefromServer:(NSString*)Mapurl{
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cacert" ofType:@"cer"];
    //    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    //    NSArray *cerSet = [[NSArray alloc] initWithObjects:cerData, nil];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //    securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];    [securityPolicy setAllowInvalidCertificates:YES];
    //   [securityPolicy setPinnedCertificates:cerSet];
    //    securityPolicy.validatesDomainName = NO;
    
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    //    [manager setSecurityPolicy:securityPolicy];
    //设置可接受的数据类型
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    //用一个变量去接受结果分析结果然后返回yes or no
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Mapurl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"接收成功！！");
             
             NSArray* data=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"%@",data);
             NSArray *annotationArray=[self content:data];
             [self addAnnotation:annotationArray];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"接收失败，%@",error);
             //             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
    
}



-(void)setUI{
    [self reveicefromServer:url];
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
//    [self addAnnotation];
    NSLog(@"%f and %f",_clocation.latitude,_clocation.longitude);
}
//-(void)setData{
//    NSString* extendUrl=[NSString stringWithFormat:@"?latitude=%f&longitude=%f",_clocation.latitude,_clocation.longitude];
//    url=[url stringByAppendingString:extendUrl];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
