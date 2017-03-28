//
//  TrendsPageViewController.m
//  Bbian
//
//  Created by dengwt on 2017/3/14.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "TrendsPageViewController.h"

@interface TrendsPageViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *convenientButton;
@property (strong, nonatomic) IBOutlet UIButton *maintenanceButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIImageView *mapView;

@end

@implementation TrendsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    // Do any additional setup after loading the view.
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
