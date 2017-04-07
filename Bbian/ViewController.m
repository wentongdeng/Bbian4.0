//
//  ViewController.m
//  Bbian
//
//  Created by dengwt on 2017/3/14.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "ViewController.h"
#import "MomentViewModel.h"
#import "Moments.h"
#import "MomentsTableViewCell.h"
#import "MJRefresh.h"
#import "TrendsPageViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,MKMapViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *moments;      //数据模型
@property (nonatomic,strong) NSMutableArray *momentFrames; //ViewModel(包含cell子控件的Frame)
@property (nonatomic,strong)NSString *contentURL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    //注意顺序
    [self setData];
    [self setUI];
}
//-(IBAction)trends{
//    NSLog(@"看看有没有运行");
//    TrendsPageViewController *trends=[[TrendsPageViewController alloc]init];
//    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:trends];
//    [self presentViewController:n animated:YES completion:nil];
//}
- (void)setUI{
//    self.title = @"便态";
//    //设置navigationBar不透明
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    //导航条颜色
//    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
//    self.view.backgroundColor = [UIColor whiteColor];
    //输入URL
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    [self.view addSubview:self.tableView];
}
//将经纬度传入请求当中
- (void)setData{
    _contentURL=@"http://localhost:8080/Bbian";
    NSString* extendUrl=[NSString stringWithFormat:@"?latitude=%f&longitude=%f",_clocation.latitude,_clocation.longitude];
    _contentURL=[_contentURL stringByAppendingString:extendUrl];
}

- (NSMutableArray *)moments{
    if (!_moments) {
        _moments = [NSMutableArray array];
        _moments = [Moments moments:_contentURL];
    }
    return _moments;
}

- (NSMutableArray *)momentFrames{
    if (!_momentFrames) {
        _momentFrames = [NSMutableArray array];
        //数据模型 => ViewModel(包含cell子控件的Frame)
        for (Moments *moment in self.moments) {
            MomentViewModel *momentFrame = [[MomentViewModel alloc] init];
            momentFrame.moment = moment;
            [self.momentFrames addObject:momentFrame];
        }
    }
    return _momentFrames;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        CGFloat tableViewH =  self.view.bounds.size.height - 49;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, screenWidth, tableViewH) style:UITableViewStylePlain];
        _tableView = tableView;
        //防止tableView被tabBar遮挡
        _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.backgroundColor = iCodeTableviewBgColor;
        //下拉刷新
        //怎么样传递参数
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

#pragma mark - 加载最新数据

- (void)loadNewData{
    //模拟增加数据
    for (Moments *moment in self.moments) {
        MomentViewModel *momentFrames = [[MomentViewModel alloc] init];
        momentFrames.moment = moment;
        [_momentFrames addObject:momentFrames];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}


#pragma mark - tableView的方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.momentFrames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentsTableViewCell *cell = [MomentsTableViewCell momentsTableViewCellWithTableView:tableView];
    cell.momentFrames = self.momentFrames[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取数据
    MomentViewModel *momentFrame = self.momentFrames[indexPath.section];
    return momentFrame.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return circleCellMargin;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
