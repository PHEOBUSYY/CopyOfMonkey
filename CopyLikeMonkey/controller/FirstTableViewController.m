//
//  FirstTableViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/7.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "FirstTableViewController.h"
#import "FirstTableViewCell.h"
#import "TestObject.h"
#import "HeaderSegmentControl.h"
#import "UIRankDataSource.h"



@interface FirstTableViewController ()<UITableViewDelegate>{
    UITableView *tableView;
    UITableView *tableView2;
    UITableView *tableView3;
    YiRefreshHeader *header;
    YiRefreshHeader *header2;
    YiRefreshHeader *header3;
    HeaderSegmentControl *headerControll;
    float bgViewHeight;
    
    UIRankDataSource *dataSource;
}
@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) NSMutableArray<UserModel*> *data;
@property(strong,nonatomic) NSMutableArray<UserModel*> *data2;
@property(strong,nonatomic) NSMutableArray<UserModel*> *data3;

@end

@implementation FirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决如果根view是scrollview的时候给scrollview添加view的时候会向下偏移64px的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor redColor];
    [self initData];
    [self initMainView];
    
}
-(void)initData
{
    dataSource = [[UIRankDataSource alloc]init];
}
-(void) initMainView{
    //减去了顶部标题+状态栏+底部tabbar的高度
    
    [self initHeaderControll];
//                                  contrl.initWithFrame:CGRectMake(0, 35, ScreenWidth, 35)];
    bgViewHeight = ScreenHeight - 35 - 64 - 49;
    [self initScrollView];
    [self initTableView];
    [self initTableView2];
    [self initTableView3];
}
-(void)initHeaderControll
{
    headerControll = [[HeaderSegmentControl alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 35)];
    [self.view addSubview:headerControll];
    __weak typeof(self) weakSelf2 = self;
    headerControll.ClickBlock = ^(NSInteger clickIndex){
        
        __strong typeof(self) strongSelf2 = weakSelf2;
//       strongSelf2->dataSource.clickIndex = clickIndex;
       [strongSelf2.scrollView setContentOffset:CGPointMake(ScreenWidth*clickIndex, 0) animated:YES];
        [strongSelf2 onTabClick:clickIndex];
    };
}
-(void)onTabClick:(NSInteger) clickIndex{
    
    switch (clickIndex) {
        case 0:
            if([dataSource.dataArray1 count]==0){
                [header beginRefreshing];
            }
            break;
        case 1:
            if([dataSource.dataArray2 count]==0){
                [header2 beginRefreshing];
            }
            break;
        case 2:
            if([dataSource.dataArray3 count]==0){
                [header3 beginRefreshing];
            }
            break;
            
        default:
            break;
    }
}
-(void)initScrollView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+35, ScreenWidth, bgViewHeight)];
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth * (4),0)];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, bgViewHeight) animated:NO];

}
-(void)initTableView{
    tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.frame = CGRectMake(0, 0, ScreenWidth, bgViewHeight);
    tableView.delegate = self;
    tableView.dataSource=dataSource;
    tableView.rowHeight = 70;
    header = [[YiRefreshHeader alloc] init];
    [self.scrollView addSubview:tableView];
    header.scrollView=tableView;
    [header header];
    __weak typeof(self) weakself = self;
    header.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        __weak typeof(self) weak = strongself;
        [strongself requestWithAFNetWork:0 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
            strong->dataSource.dataArray1 = testObject.items;
            
            strong->dataSource.clickIndex = 0;
            [strong->tableView reloadData];
            [strong->header endRefreshing];
            NSLog(@"enter talbe1");
            
        }];
    };
    [header beginRefreshing];
}
-(void)initTableView2{
    tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView2.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, bgViewHeight);
    tableView2.delegate = self;
    tableView2.dataSource=dataSource;
    tableView2.rowHeight = 70;
    header2 = [[YiRefreshHeader alloc] init];
    [self.scrollView addSubview:tableView2];
    header2.scrollView=tableView2;
    [header2 header];
    __weak typeof(self) weakself = self;
    header2.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        __weak typeof(self) weak = strongself;
        [strongself requestWithAFNetWork:1 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
            strong->dataSource.dataArray2 = testObject.items;
            strong->dataSource.clickIndex = 1;
            [strong->tableView2 reloadData];
            [strong->header2 endRefreshing];
            NSLog(@"enter talbe2");
        }];
    };
}
-(void)initTableView3{
    tableView3 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView3.frame = CGRectMake(ScreenWidth*2, 0, ScreenWidth, bgViewHeight);
    tableView3.delegate = self;
    tableView3.dataSource=dataSource;
    tableView3.rowHeight = 70;
    header3 = [[YiRefreshHeader alloc] init];
    [self.scrollView addSubview:tableView3];
    header3.scrollView=tableView3;
    [header3 header];
    __weak typeof(self) weakself = self;
    header3.beginRefreshingBlock = ^(){
        
        __strong typeof(self) strongself = weakself;
        __weak typeof(self) weak = strongself;
        [strongself requestWithAFNetWork:2 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
                                strong->dataSource.dataArray3 = testObject.items;
                                strong->dataSource.clickIndex = 2;
                                [strong->tableView3 reloadData];
                                [strong->header3 endRefreshing];
            NSLog(@"enter talbe3");

        }];
    };
}
-(void)requestWithAFNetWork:(NSInteger )clickIndex resultBlock:(void (^)(TestObject* testObject))block
{
    
    NSString *urlStr = @"https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000";
    if (clickIndex == 1) {
        urlStr = @"https://api.github.com/search/users?q=jack+repos:%3E42+followers:%3E1000";
    }else if(clickIndex ==2){
        urlStr = @"https://api.github.com/search/users?q=java+language:%3E42+followers:%3E1000";
    }
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            block(nil);
        } else {
              dispatch_async(dispatch_get_main_queue(), ^{
                TestObject *test = [TestObject mj_objectWithKeyValues:responseObject];
                block(test);
              });
            
        }
    }];
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//scrollView滑动监听
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if(scrollView.contentOffset.x > scrollView.contentOffset.y && scrollView.contentOffset.x > 10){
        CGFloat pagewidth = scrollView.frame.size.width;
        int currentPage = floor((scrollView.contentOffset.x - pagewidth/ (2)) / pagewidth) + 1;
        [headerControll clickIndex:(currentPage)];
    }
}
@end
