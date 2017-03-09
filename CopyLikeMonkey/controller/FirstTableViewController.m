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




@interface FirstTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView;
    UITableView *tableView2;
    UITableView *tableView3;
    YiRefreshHeader *header;
    YiRefreshHeader *header2;
    YiRefreshHeader *header3;
    HeaderSegmentControl *headerControll;
    float bgViewHeight;
}
@property(strong,nonatomic)  UIScrollView *scrollView;
@property(strong,nonatomic) NSMutableArray<UserModel*> *data;

@end

@implementation FirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决如果根view是scrollview的时候给scrollview添加view的时候会向下偏移64px的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor redColor];
    [self initMainView];
    
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
           [strongSelf2.scrollView setContentOffset:CGPointMake(ScreenWidth*clickIndex, 0) animated:YES];
        [strongSelf2 onTabClick:clickIndex];
    };
}
-(void)onTabClick:(NSInteger) clickIndex{
    switch (clickIndex) {
        case 0:
            [header beginRefreshing];
            break;
        case 1:
            [header2 beginRefreshing];
            break;
        case 2:
            [header3 beginRefreshing];
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
    tableView.dataSource=self;
    tableView.rowHeight = 70;
    header = [[YiRefreshHeader alloc] init];
    [self.scrollView addSubview:tableView];
    header.scrollView=tableView;
    [header header];
    __weak typeof(self) weakself = self;
    header.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        [strongself requestWithAFNetWork];
    };
    [header beginRefreshing];
}
-(void)initTableView2{
    tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView2.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, bgViewHeight);
    tableView2.delegate = self;
    tableView2.dataSource=self;
    tableView2.rowHeight = 70;
    header2 = [[YiRefreshHeader alloc] init];
    [self.scrollView addSubview:tableView2];
    header2.scrollView=tableView2;
    [header2 header];
    __weak typeof(self) weakself = self;
    header2.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        [strongself requestWithAFNetWork];
    };
//    [header2 beginRefreshing];
}
-(void)initTableView3{
    tableView3 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView3.frame = CGRectMake(ScreenWidth*2, 0, ScreenWidth, bgViewHeight);
        tableView2.delegate = self;
        tableView2.dataSource=self;
    tableView3.rowHeight = 70;
    header3 = [[YiRefreshHeader alloc] init];
    [self.scrollView addSubview:tableView3];
    header3.scrollView=tableView3;
    [header3 header];
    __weak typeof(self) weakself = self;
    header3.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        [strongself requestWithAFNetWork];
    };
//    [header3 beginRefreshing];
}
-(void)requestWithAFNetWork{
    
    NSString *urlStr = @"https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000";
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            TestObject *test = [TestObject mj_objectWithKeyValues:responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.data = test.items;
                for (int i=0; i<[self.data count]; i++) {
                    UserModel *model = [self.data objectAtIndex:i];
                    NSLog(@"the model is %@",[model valueForKey:@"login"]);
                }
                [tableView reloadData];
                [tableView2 reloadData];
                [tableView3 reloadData];
                [header endRefreshing];
                [header2 endRefreshing];
                [header3 endRefreshing];

                
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UserModel *model = [self.data objectAtIndex:indexPath.row];
    NSString *avatar = [model valueForKey:@"avatar_url"];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:avatar]];
    cell.title.text = [NSString stringWithFormat:@"%@",[model valueForKey:@"login"]];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
        CGFloat pagewidth = scrollView.frame.size.width;
        int currentPage = floor((scrollView.contentOffset.x - pagewidth/ (2)) / pagewidth) + 1;
    
    [headerControll clickIndex:(currentPage)];
}
@end
