//
//  MyTrendsPageViewController.m
//  Bbian
//
//  Created by dengwt on 2017/3/14.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "MyTrendsPageViewController.h"

@interface MyTrendsPageViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextView *massage;

@property (strong, nonatomic) IBOutlet UITextField *mtitle;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

@implementation MyTrendsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)build{
    if((_mtitle!=nil)&&(_massage!=nil)&&(_mtitle.text.length!=0)&&(_massage.text.length!=0)){
        //根据不同的数据使用不同的方法和地址
        [SendtoServer sendMessage:_mtitle.text describe:_massage.text url:@"http://localhost:8080/Bian04/receiveMassage" user:@"马化腾"];

    }else{
        [self alertView];
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_massage resignFirstResponder];
    [_mtitle resignFirstResponder];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* chosenImage = info[UIImagePickerControllerEditedImage];
    self.image.image = chosenImage;
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
- (void)alertView
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"照片和说明等不能为空" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"点击取消");
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"点击确认");
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
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
