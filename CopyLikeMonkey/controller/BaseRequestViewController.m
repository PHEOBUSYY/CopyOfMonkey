//
//  BaseRequestViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/23.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "BaseRequestViewController.h"

@interface BaseRequestViewController () 

@end

@implementation BaseRequestViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    [self initMainView];
    
    if ([self needConfigHeader] && [self needFristUpdate]) {
        [self.header beginRefreshing];
    }
}
-(Boolean)needFristUpdate
{
    return YES;
}
- (void)initMainView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //默认生效
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.view addSubview:_tableView];
    if ([self needConfigHeader]) {
        self.header = [[YiRefreshHeader alloc] init];
        self.header.scrollView = self.tableView;
        [self.header header];
        WEAKREF
        self.header.beginRefreshingBlock = ^(){
            STRONGREF
            strongSelf.page = 1;
            [strongSelf requestData:YES];
        };
    }
   
    if ([self needConfigFooter]) {
        self.footer = [[YiRefreshFooter alloc] init];
        self.footer.scrollView = self.tableView ;
        [self.footer footer];
         WEAKREF
        self.footer.beginRefreshingBlock = ^(){
            STRONGREF
            strongSelf.page ++;
            [strongSelf requestData:NO];
        };
    }
}
-(Boolean)needConfigFooter
{
    return YES;
}
-(Boolean)needConfigHeader
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}
-(void)requestData:(Boolean)isFirst
{
    
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
