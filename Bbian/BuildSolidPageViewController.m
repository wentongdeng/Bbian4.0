//
//  BuildSolidPageViewController.m
//  Bbian
//
//  Created by dengwt on 2017/3/14.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "BuildSolidPageViewController.h"

@interface BuildSolidPageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *describeText;
@property (strong,nonatomic) CLLocation* location;
@property (strong,nonatomic) CLLocationManager *locationManager;
@end

@implementation BuildSolidPageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    _locationManager=[[CLLocationManager alloc]init];
    _locationManager.delegate=self;
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    }
    [_locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)takePhoto:(UIButton*)sender{
    // 创建UIImagePickerController控制器对象
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(IBAction)selectPhoto:(UIButton*)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_nameText resignFirstResponder];
    [_describeText resignFirstResponder];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* chosenImage = info[UIImagePickerControllerEditedImage];
    self.image.image = chosenImage;
    //看情况了，如果可以根据这个获取的话就用这个，不能就用定位了
    //连取两次字典，可以取出里面经纬度和时间
//    NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
//        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        NSDictionary *metadata = rep.metadata;
//        
//        //NSLog(@"%@", metadata);
//        NSDictionary *gps=[metadata objectForKey:@"GPS"];
//        NSString *la=[gps objectForKey:@"Latitude"];
//        NSString *lo=[gps objectForKey:@"Longitude"];
//        if((la==nil)||(la.length==0)||(lo==nil)||(lo.length==0)){
//            NSLog(@"经纬度获取失败");
//        }
//        double lat=la.doubleValue;
//        double lon=lo.doubleValue;
//        _location=[_location initWithLatitude:lat longitude:lon];
//        
//    } failureBlock:^(NSError *error) {
//        // error handling
//    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//直接在这传值就好了
//应该来一个判断，如果是空值就做相应的处理
-(IBAction)build{
    if((_nameText!=nil)&&(_describeText!=nil)&&(_image!=nil)&&(_nameText.text.length!=0)&&(_describeText.text.length!=0)){
        ResultPageViewController* result=[[ResultPageViewController alloc]init];
        result.solidTitle=_nameText.text;
        result.solidDescibe=_describeText.text;
        result.solidImage=_image.image;
        result._location=_location;
        [self.navigationController pushViewController:result animated:YES];
    }else{
       [self alertView];
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"出错了%@",error);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //[_locationManager stopUpdatingLocation];
    _location=[locations firstObject];
    NSLog(@"地址是%@",_location);
    [_locationManager stopUpdatingLocation];
}

- (void)alertView
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"照片和说明等不能为空" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击确认");
        
    }]];
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
