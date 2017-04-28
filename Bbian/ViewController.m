//
//  ViewController.m
//  SoolyMomentCell
//
//  Created by SoolyChristina on 2016/11/25.
//  Copyright © 2016年 SoolyChristina. All rights reserved.
//

#import "ViewController.h"
#import "MomentViewModel.h"
#import "Moments.h"
#import "MomentsTableViewCell.h"
#import "MJRefresh.h"
#import "NSArray+Extension.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *moments;      //数据模型
@property (nonatomic,strong) NSMutableArray *momentFrames; //ViewModel(包含cell子控件的Frame)

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setData];
}

- (void)setUI{
    self.title = @"便态";
    //设置navigationBar不透明
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //导航条颜色
    self.navigationController.navigationBar.barTintColor = iCodeNavigationBarColor;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)setData{
    
   }

- (NSMutableArray *)moments{
    if (!_moments) {
        _moments = [NSMutableArray array];
        _moments = [Moments moments];
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH) style:UITableViewStylePlain];
        _tableView = tableView;
        //防止tableView被tabBar遮挡
        _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.backgroundColor = iCodeTableviewBgColor;
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

#pragma mark - 加载最新数据

- (void)loadNewData{
    //增加数据
    [self reveicefromServer:@"http://10.151.254.125:8080/Bian07/listExtendMassage"];
}

-(void)loadData:(NSArray*)data{
    if(data!=nil){
        for (Moments *moment in [Moments loadmoments:data]) {
            MomentViewModel *momentFrames = [[MomentViewModel alloc] init];
            momentFrames.moment = moment;
            [_momentFrames addObject:momentFrames];
        }
    }else{
        for (Moments *moment in [Moments moments]) {
            MomentViewModel *momentFrames = [[MomentViewModel alloc] init];
            momentFrames.moment = moment;
            [_momentFrames addObject:momentFrames];
        }
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

- (void)reveicefromServer:(NSString*)url{
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
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"接收成功！！");
            
             NSArray* data=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"%@",data);
             [self loadData:data];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"接收失败，%@",error);
             //             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
    
    }


@end
