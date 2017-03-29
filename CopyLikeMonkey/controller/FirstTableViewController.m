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

#import "ContryTableViewController.h"
#import "LanguageViewController.h"
#import "RankDetailViewController.h"

@interface FirstTableViewController ()<UITableViewDelegate>{
    UITableView *tableView;
    UITableView *tableView2;
    UITableView *tableView3;
    YiRefreshHeader *header;
    YiRefreshHeader *header2;
    YiRefreshHeader *header3;
    
    YiRefreshFooter *footer;
    YiRefreshFooter *footer2;
    YiRefreshFooter *footer3;
    
    HeaderSegmentControl *headerControll;
    float bgViewHeight;
    
    UIRankDataSource *dataSource;
    
    int currentIndex;
    int page1 ;
    int page2 ;
    int page3 ;
    
}
@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) NSMutableArray<UserModel*> *data;
@property(strong,nonatomic) NSMutableArray<UserModel*> *data2;
@property(strong,nonatomic) NSMutableArray<UserModel*> *data3;
@property(strong,nonatomic) NSString *currentLanguage;
@property(strong,nonatomic) NSString *currentCountry;
@property(strong,nonatomic) NSString *currentCity;

@end

@implementation FirstTableViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    //解决如果根view是scrollview的时候给scrollview添加view的时候会向下偏移64px的问题
    
    self.view.backgroundColor = [UIColor redColor];
    [self initData];
    [self initMainView];
    
}
-(void)initData
{
    dataSource = [[UIRankDataSource alloc]init];
}
-(void) initMainView{
    [self initNavigationItem];
    //减去了顶部标题+状态栏+底部tabbar的高度
    [self initHeaderControll];
    bgViewHeight = ScreenHeight - 35 - 64 - 49;
    [self initScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initTableView];
    [self initTableView2];
    [self initTableView3];
}
-(void)viewWillAppear:(BOOL)animated
{
    //相当于onRsume声明周期
    //在这里配置默认的选择城市
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    if (cityName == nil) {
        cityName = @"Beijing";
    }
    [headerControll.buttonFirst setTitle:cityName forState:UIControlStateNormal];
    
    NSString *contryName = [[NSUserDefaults standardUserDefaults] objectForKey:@"country"];
    if (contryName == nil) {
        contryName = @"china";
    }
    [headerControll.buttonSecond setTitle:contryName forState:UIControlStateNormal];
    
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if (language == nil) {
        language = @"Objective-C";
    }
    if ([self.currentLanguage isEqualToString:language] &&
        [self.currentCountry isEqualToString:contryName] &&
        [self.currentCity isEqualToString:cityName]
        ) {
        return;
    }
    self.currentCity = cityName;
    self.currentCountry = contryName;
    self.currentLanguage = language;
    
    self.navigationItem.title = language;
    if (currentIndex == 1) {
        [header2 beginRefreshing];
    }else if(currentIndex == 2){
        [header3 beginRefreshing];
    }else{
        [header beginRefreshing];
    }
     self.tabBarController.tabBar.hidden = NO;
}
-(void)initNavigationItem
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"city" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"langauge" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
    
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)leftAction:(UIBarButtonItem *)UIBarButtonItem{
    ContryTableViewController *contryController = [[ContryTableViewController alloc]init ];
    [self.navigationController pushViewController:contryController animated:YES];
}
-(void)rightAction:(UIBarButtonItem *)UIBarButtonItem{
    LanguageViewController *languageController = [[LanguageViewController alloc]init];
    [self.navigationController pushViewController:languageController animated:YES];
}
-(void)initHeaderControll
{
    headerControll = [[HeaderSegmentControl alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 35)];
    headerControll.buttonCount = 3;
    [self.view addSubview:headerControll];
    __weak typeof(self) weakSelf2 = self;
    headerControll.ClickBlock = ^(NSInteger clickIndex){
        __strong typeof(self) strongSelf2 = weakSelf2;
        strongSelf2->currentIndex = (int)clickIndex;
        [strongSelf2.scrollView setContentOffset:CGPointMake(ScreenWidth*clickIndex, 0) animated:YES];
        [strongSelf2.scrollView scrollRectToVisible:CGRectMake(ScreenWidth*clickIndex, 0, ScreenWidth, strongSelf2->bgViewHeight) animated:NO];
        NSLog(@"the offsetX is %f",strongSelf2.scrollView.contentOffset.x);
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
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth * (3),0)];
    
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
        strongself->page1 = 1;
        NSLog(@"beginRefresh offsetX %f ",strongself.scrollView.contentOffset.x);
        [strongself requestWithAFNetWork:0 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
            strong->dataSource.dataArray1 = testObject.items;
            
            strong->dataSource.clickIndex = 0;
            [strong->tableView reloadData];
            [strong->header endRefreshing];
            [strong updateTitleTabText:testObject.total_count];
            
        }];
    };
    footer = [[YiRefreshFooter alloc] init];
    footer.scrollView = tableView;
    [footer footer];
    footer.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        __weak typeof(self) weak = strongself;
        if (page1 == 0) {
            page1 = 1;
        }
        strongself->page1++;
        [strongself requestWithAFNetWork:0 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
            [strong->dataSource.dataArray1 addObjectsFromArray:testObject.items];
            
            strong->dataSource.clickIndex = 0;
            [strong->tableView reloadData];
            [strong->footer endRefreshing];
//            [strong updateTitleTabText:testObject.total_count];
            NSLog(@"enter talbe1 footer");
            
        }];
    };
//    [header beginRefreshing];
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
        NSLog(@"beginRefresh offsetX %f ",strongself.scrollView.contentOffset.x);
        strongself->page2 = 1;
        [strongself requestWithAFNetWork:1 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
            strong->dataSource.dataArray2 = testObject.items;
            strong->dataSource.clickIndex = 1;
            [strong->tableView2 reloadData];
            [strong->header2 endRefreshing];
           [strong updateTitleTabText:testObject.total_count];
             NSLog(@"beginRefresh1111 offsetX %f ",strongself.scrollView.contentOffset.x);
            NSLog(@"enter talbe2");
        }];
    };
    footer2 = [[YiRefreshFooter alloc]init];
    footer2.scrollView = tableView2;
    [footer2 footer];
    footer2.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        __weak typeof(self) weak = strongself;
        strongself->page2++;
        [strongself requestWithAFNetWork:1 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
            [strong->dataSource.dataArray2 addObjectsFromArray: testObject.items];
            strong->dataSource.clickIndex = 1;
            [strong->tableView2 reloadData];
            [strong->footer2 endRefreshing];
//            [strong updateTitleTabText:testObject.total_count];
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
         strongself->page3 = 1;
        NSLog(@"beginRefresh offsetX %f ",strongself.scrollView.contentOffset.x);
        [strongself requestWithAFNetWork:2 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
                                strong->dataSource.dataArray3 = testObject.items;
                                strong->dataSource.clickIndex = 2;
                                [strong->tableView3 reloadData];
                                [strong->header3 endRefreshing];
            [strong updateTitleTabText:testObject.total_count];
            
            NSLog(@"enter talbe3");

        }];
    };
    footer3 = [[YiRefreshFooter alloc]init];
    footer3.scrollView = tableView2;
    [footer3 footer];
    footer3.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        __weak typeof(self) weak = strongself;
        strongself->page3++;
        [strongself requestWithAFNetWork:2 resultBlock:^(TestObject *testObject) {
            __strong typeof(self) strong = weak;
            [strong->dataSource.dataArray3 addObjectsFromArray: testObject.items];
            strong->dataSource.clickIndex = 2;
            [strong->tableView3 reloadData];
            [strong->footer3 endRefreshing];
        }];
    };
}
-(void)updateTitleTabText:(int)titleCount
{
    NSString * titleText =[ NSString stringWithFormat:@"total: %d",titleCount];
    [headerControll.buttonFourth setTitle:titleText forState:UIControlStateNormal];
}
-(void)requestWithAFNetWork:(NSInteger )clickIndex resultBlock:(void (^)(TestObject* testObject))block
{
    int page = 1;
    if(clickIndex == 0){
        if (page1 == 0) {
            page1 = 1;
        }
        page = page1;
    }else if(clickIndex == 1){
        if (page2 == 0) {
            page2 = 1;
        }
        page = page2;
    }else if(clickIndex == 2){
        if (page3 == 0) {
            page3 = 1;
        }
        page = page3;
    }
    NSString *contry = [[NSUserDefaults standardUserDefaults] objectForKey:@"contry"];
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if (contry == nil) {
        contry = @"china";
    }
    if (city == nil) {
        city = @"beijing";
    }
     city=[city stringByReplacingOccurrencesOfString:@" "  withString:@"%2B"];
    if (language == nil) {
        language = @"Objective-C";
    }
    NSString * q = [NSString stringWithFormat: @"location:%@+language:%@",city,language];
   
    if (clickIndex == 1) {
        q =  [NSString stringWithFormat: @"location:%@+language:%@",contry,language];
    }else if(clickIndex ==2){
        q =  [NSString stringWithFormat: @"language:%@",language];
    }
    NSString *urlStr = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@&page=%d&sort=followers",q,page];
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"request url %@ ",urlStr);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    id model = nil;
    if (currentIndex == 1) {
        model = dataSource.dataArray2[indexPath.row];
    }else if(currentIndex == 2){
        model = dataSource.dataArray3[indexPath.row];
    }else{
        model = dataSource.dataArray1[indexPath.row];
    }
    UserModel *newModel = [UserModel modelWithDict:model];
    RankDetailViewController *detailController = [[RankDetailViewController alloc] init];
    detailController.userModel = newModel;
    [self.navigationController pushViewController:detailController animated:YES];
}
#pragma mark - Table view data source

//scrollView滑动监听
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > scrollView.contentOffset.y && scrollView.contentOffset.x > 0){
        CGFloat pagewidth = scrollView.frame.size.width;
        int currentPage = floor((scrollView.contentOffset.x - pagewidth/ (3)) / pagewidth) + 1;
        currentIndex = currentPage;
        [headerControll clickIndex:(currentPage)];
    }
}
@end
