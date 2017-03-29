//
//  TrendingViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/23.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "TrendingViewController.h"
#import "HeaderSegmentControl.h"
#import "YiRefreshFooter.h"
#import "YiRefreshHeader.h"
#import "HttpHandler.h"
#import "RepoTableViewCell.h"
#import "RepositoryModel.h"
#import "RepositoriesDetailControllerViewController.h"
@interface TrendingViewController () <UITableViewDelegate ,UITableViewDataSource >
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) HeaderSegmentControl *headerControll;
@property (strong,nonatomic) YiRefreshHeader *header;
@property (strong,nonatomic) NSMutableArray *data1;
@property (strong,nonatomic) NSMutableArray *data2;
@property (strong,nonatomic) NSMutableArray *data3;

@property (assign,nonatomic) int currentIndex;
@end

@implementation TrendingViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initMainView];
    [self.header beginRefreshing];
}
- (void)initMainView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 +35, ScreenWidth, ScreenHeight - 64 - 35) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.rowHeight = 100;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.header = [[YiRefreshHeader alloc]init];
    self.header.scrollView = self.tableView;
    [self.header header];
    WEAKREF
    self.header.beginRefreshingBlock = ^(){
        STRONGREF
       
        [strongSelf getDataByClickType:strongSelf.currentIndex];
    };
    
    self.headerControll = [[HeaderSegmentControl alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 35)];
    [self.view addSubview:_headerControll];
    [self.headerControll.buttonFourth setTitle:@"" forState:UIControlStateNormal];
    
    UIColor *bgColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.headerControll.buttonFourth.backgroundColor = bgColor;
    [self.headerControll.buttonFirst setTitle:@"daily" forState:UIControlStateNormal];
    [self.headerControll.buttonSecond setTitle:@"weekly" forState:UIControlStateNormal];
    [self.headerControll.buttonThird setTitle:@"monthly" forState:UIControlStateNormal];
    self.headerControll.buttonCount = 3;
    self.headerControll.ClickBlock = ^(NSInteger clickIndex) {
        STRONGREF
        strongSelf.currentIndex = (int)clickIndex;
        [strongSelf.header beginRefreshing];
    };
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getDataByClickType:(int)clickIndex
{
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"language"];
    
    NSString *since = @"daily";
    
    if (self.currentIndex == 1) {
        since = @"weekly";
    }else if(self.currentIndex == 2){
        since = @"monthly";
    }
    WEAKREF
    [HttpHandler getTrending:since withLanguage:language onSucess:^(id  _Nonnull responseObject) {
        STRONGREF
        if (strongSelf.currentIndex == 1) {
                strongSelf.data2 = [[NSMutableArray alloc] initWithArray:responseObject];
                [strongSelf.header endRefreshing];
        }else if(strongSelf.currentIndex == 2){
                strongSelf.data3 = [[NSMutableArray alloc] initWithArray:responseObject];
                [strongSelf.header endRefreshing];
        }else{
                strongSelf.data1 = [[NSMutableArray alloc] initWithArray:responseObject];
                [strongSelf.header endRefreshing];
        }
        [strongSelf.tableView reloadData ];
    } onError:^(NSError * _Nonnull error) {
        STRONGREF
            [strongSelf.header endRefreshing];
        NSLog(@"%@",error);
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"trending"];
    if (cell == nil) {
        cell = [[RepoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"trending"];
    }
    id modelDic = nil;
    if (self.currentIndex == 1) {
        modelDic = self.data2[indexPath.row];
    }else if(self.currentIndex == 2){
        modelDic = self.data3[indexPath.row];
    }else{
        modelDic = self.data1[indexPath.row];
    }
    RepositoryModel *model = [RepositoryModel modelWithDict:modelDic];
    [cell showViewByModel:model withIndex:(int)(indexPath.row+1)];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentIndex == 1) {
        return [self.data2 count];
    }else if (self.currentIndex == 2){
        return [self.data3 count ];
    }else{
        return [self.data1 count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id modelDic = nil;
    if (self.currentIndex == 1) {
        modelDic = self.data2[indexPath.row];
    }else if(self.currentIndex == 2){
        modelDic = self.data3[indexPath.row];
    }else{
        modelDic = self.data1[indexPath.row];
    }
    RepositoryModel *model = [RepositoryModel modelWithDict:modelDic];
    RepositoriesDetailControllerViewController *detal = [[RepositoriesDetailControllerViewController alloc ]init];
    detal.repo = model;
    [self.navigationController pushViewController:detal animated:YES];
}
@end
