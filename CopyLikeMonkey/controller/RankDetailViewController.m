//
//  RankDetailViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/16.
//  Copyright © 2017年 阎翼. All rights reserved.
//  排名详情页
//

#import "RankDetailViewController.h"
#import "RepositoriesDetailControllerViewController.h"
#import "DetailSegmentControll.h"
#import "HttpKit.h"
#import "TestObject.h"
#import "RepositoryModel.h"
#import "FirstTableViewCell.h"
#import "RepoTableViewCell.h"
@interface RankDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *name;
    UIImageView *avatar;
    UILabel *ownerName;
    UILabel *blog;
    UILabel *email;
    UILabel *net;
    UILabel *createTime;
    UILabel *company;
    UILabel *location;
}
@property (strong,nonatomic) DetailSegmentControll *headerControl;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *headerDetailView;
@property (strong,nonatomic) YiRefreshFooter *footer;
@property (strong,nonatomic) YiRefreshHeader *header;
@property (copy,nonatomic) errorBlock errorBlock;
@property (assign,nonatomic) int page1;
@property (assign,nonatomic) int page2;
@property (assign,nonatomic) int page3;
@property (strong,nonatomic) NSMutableArray * data1;
@property (strong,nonatomic) NSMutableArray * data2;
@property (strong,nonatomic) NSMutableArray * data3;
@property (strong,nonatomic) NSMutableArray * currentDataList;
@property (assign,nonatomic) int currentPage;

@end

@implementation RankDetailViewController

- (void)viewDidLoad {
    self.page1 = self.page2 = self.page3 = 1;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAKREF
    self.errorBlock = ^(NSError * _Nonnull error){
        STRONGREF
        NSLog(@"the http error is %@",error);
        [strongSelf.header endRefreshing];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    [self initMainView];
    
    UserModel *mode = [[NSUserDefaults standardUserDefaults]objectForKey:@"detail"];
    if (mode) {
        self.userModel = mode;
    }else{
        [_header beginRefreshing];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma view Init
- (void)initMainView
{
    [self initTableView];
    [self initHeaderDetailView];
    [self initHeaderAndFooter];
}
- (void)initHeaderAndFooter
{
    self.header = [[YiRefreshHeader alloc]init];
    self.header.scrollView = self.tableView;
    [self.header header];
    WEAKREF
    self.header.beginRefreshingBlock = ^(){
        STRONGREF
        if([self getCurrntIndex] == 1){
            strongSelf.page2 =1;
        }else if([self getCurrntIndex] ==2){
            strongSelf.page3 =1;
        }else{
            strongSelf.page1 =1;
        }
        [strongSelf getUserDetail];
    };
    
    self.footer = [[YiRefreshFooter alloc]init];
    self.footer.scrollView = self.tableView;
    [self.footer footer];
    self.footer.beginRefreshingBlock = ^(){
        STRONGREF
        if([self getCurrntIndex] == 1){
            strongSelf.page2 ++;
        }else if([self getCurrntIndex] ==2){
            strongSelf.page3 ++;
        }else{
            strongSelf.page1 ++;
        }
        [strongSelf getUserDataByType:[strongSelf getCurrntIndex]];
    };
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}
- (void)initHeaderDetailView
{
    
    float topSpace = 10;
    float honSpace = 10;
    float imageWidth = 50;
    float labelWidth = 110;
    float labelHeight = 25;
    float labelFont = 13;
    float headerControlHeight = 68;
    float h = topSpace + labelHeight+topSpace+labelFont+topSpace+labelFont+topSpace;
    self.headerDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, h+headerControlHeight+topSpace)];
    self.headerDetailView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerDetailView;
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(honSpace+imageWidth+honSpace, topSpace, labelWidth, labelHeight)];
    name.textColor = YiBlue;
    name.font = [UIFont systemFontOfSize:15];
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(honSpace, topSpace, imageWidth, imageWidth)];
    avatar.layer.cornerRadius = 11;
    avatar.layer.borderWidth = 0.3;
    avatar.layer.borderColor = YiGray.CGColor;
    avatar.layer.masksToBounds=YES;
    createTime = [[UILabel alloc] initWithFrame:CGRectMake(honSpace, topSpace + imageWidth+topSpace, imageWidth+3, labelHeight)];
    createTime.font = [UIFont systemFontOfSize:9];

    ownerName = [[UILabel alloc] initWithFrame:CGRectMake(honSpace + imageWidth + honSpace, topSpace + labelHeight +topSpace, labelWidth, labelHeight)];
    ownerName.font = [UIFont systemFontOfSize:labelFont];
    ownerName.textColor = YiGray;
    company = [[UILabel alloc] initWithFrame:CGRectMake(honSpace + imageWidth + honSpace, topSpace + labelHeight + topSpace + labelHeight + topSpace, labelWidth, labelHeight)];
    company.font = [UIFont systemFontOfSize:labelFont];
    float leftStart = honSpace + imageWidth + honSpace + labelWidth;
    float width = ScreenWidth - leftStart - honSpace;
    
    email = [[UILabel alloc] initWithFrame:CGRectMake(leftStart, topSpace, width, labelHeight)];
    email.textColor = YiBlue;
    email.font = [UIFont systemFontOfSize:labelFont];
    net = [[UILabel alloc] initWithFrame:CGRectMake(leftStart, topSpace + labelHeight + topSpace, width, labelHeight)];
    net.font = [UIFont systemFontOfSize:labelFont];
    net.textColor = YiBlue;
    location = [[UILabel alloc] initWithFrame:CGRectMake(leftStart, topSpace + labelHeight +topSpace + labelHeight + topSpace, width, labelHeight)];
    location.font = [UIFont systemFontOfSize:14];
    location.textColor = [UIColor blackColor];
    [self.headerDetailView addSubview:name];
    [self.headerDetailView addSubview:avatar];
    [self.headerDetailView addSubview:createTime];
    [self.headerDetailView addSubview:email];
    [self.headerDetailView addSubview:location];
    [self.headerDetailView addSubview:net];
    [self.headerDetailView addSubview:ownerName];
    [self.headerDetailView addSubview:company];
    
    [self updateHeaderView];
    _headerControl = [[DetailSegmentControll alloc]initWithFrame:CGRectMake(0, h+topSpace, ScreenWidth, headerControlHeight)];
    
//    [_headerControl setNeedsLayout];
    WEAKREF
    _headerControl.clickBlock = ^(int clickIndex){
        STRONGREF
        strongSelf.currentDataList = [[NSMutableArray alloc]initWithCapacity:0];
        [strongSelf.tableView reloadData  ];
//        strongSelf.headerControl.buttonCount = 2;
        [strongSelf getUserDataByType:clickIndex];
//        [strongSelf.headerControl setNeedsLayout];
//        [strongSelf.headerControl layoutIfNeeded];
    };
    [self.headerDetailView addSubview:_headerControl];
    _headerControl.buttonCount = 2;
}
- (void) updateHeaderView
{
    if (self.userModel) {
        name.text = _userModel.name;
        [avatar sd_setImageWithURL:[NSURL URLWithString:_userModel.avatar_url]];
        createTime.text = [_userModel.created_at substringWithRange:NSMakeRange(0,10)];
        ownerName.text = _userModel.login;
        company.text = _userModel.company;
        email.text = _userModel.email;
        net.text = _userModel.blog;
        location.text = _userModel.location;
        
        _headerControl.label1Top.text = [NSString stringWithFormat:@"%d", _userModel.public_repos];
        _headerControl.label2Top.text = [NSString stringWithFormat:@"%d", _userModel.following];
        _headerControl.label3Top.text = [NSString stringWithFormat:@"%d", _userModel.followers];
    }
 
}
- (void)updateHeaderControlText:(int) clickIndex withCount:(int) count
{
    if (clickIndex == 1) {
        _headerControl.label2Top.text = [NSString stringWithFormat:@"%d",count];
    }else if(clickIndex == 2){
        _headerControl.label3Top.text = [NSString stringWithFormat:@"%d",count];
    }else{
        _headerControl.label1Top.text = [NSString stringWithFormat:@"%d",count];
    }
}
- (int)getCurrntIndex
{
    return self.headerControl.currentIndex;
}
- (int)getCurrentPage
{
    if ([self getCurrntIndex] == 1) {
        return self.page2;
    }else if([self getCurrntIndex] == 2){
        return self.page3;
    }else{
        return self.page1;
    }
}
#pragma tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self getCurrntIndex] == 1) {
        
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail1"];
        if (cell == nil) {
            cell = [[FirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detail1"];
        }
        UserModel *model = [UserModel modelWithDict:_data2[indexPath.row]];
        [cell showViewByModel:model withIndex:(int)(indexPath.row + 1)];
        return cell;
    }else if([self getCurrntIndex] == 2){
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail2"];
        if (cell == nil) {
            cell = [[FirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detail2"];
        }
        UserModel *model = [UserModel modelWithDict:_data3[indexPath.row]];
        
        [cell showViewByModel:model withIndex:(int)(indexPath.row + 1)];
        return cell;
    }else{
        RepoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail0"];
        if (cell == nil) {
            cell = [[RepoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detail0"];
        }
        RepositoryModel *model = [RepositoryModel modelWithDict:_data1[indexPath.row]];
        [cell showViewByModel:model withIndex:(int)(indexPath.row + 1)];
        return cell;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self getCurrntIndex] == 1) {
        return [_data2 count];
    }else if([self getCurrntIndex] == 2){
        return [_data3 count];
    }
    return [_data1 count];;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self getCurrntIndex] != 0) {
        return 70;
    }else{
        return 100;
    };
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self getCurrntIndex] == 1) {
        RankDetailViewController *detail = [[RankDetailViewController alloc] init];
        detail.userModel = [UserModel modelWithDict: self.data2[indexPath.row]];
        [self.navigationController pushViewController:detail animated:YES];
    }else if([self getCurrntIndex ] ==2){
        RankDetailViewController *detail = [[RankDetailViewController alloc] init];
        detail.userModel = [UserModel modelWithDict: self.data3[indexPath.row]];
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        RepositoriesDetailControllerViewController *repoDetail = [[RepositoriesDetailControllerViewController alloc]init];
        repoDetail.repo = [RepositoryModel modelWithDict: self.data1[indexPath.row]] ;
        [self.navigationController pushViewController:repoDetail animated:YES];
    }
}
#pragma http request
-(void)getUserDetail
{
    NSString * urlStr = @"https://api.github.com/users/%@";
    urlStr = [NSString stringWithFormat:urlStr,_userModel.login];
    
    [[HttpKit sharedKit]doGet:urlStr withParam:nil withSucessBlock:^(NSDictionary * _Nonnull responseObject) {
        self.userModel = [UserModel modelWithDict:responseObject];
        [self updateHeaderView];
        [self getUserDataByType:[self getCurrntIndex]];
        
    } withErroBlock:^(NSError * _Nonnull error) {
        self.errorBlock(error);
    }];
 
}

-(void)getUserDataByType:(int) clickIndex
{
    if (clickIndex == 1) {
        [self getUserFollowing];
    } else if(clickIndex == 2){
        [self getUserFollower];
    }else {
        [self getUserRepo];
    }
}

- (void)getUserRepo
{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.github.com/users/%@/repos?sort=updated&page=%ld",self.userModel.login,(long)_page1];
    
    [[HttpKit sharedKit]doGet:urlStr withParam:nil withSucessBlock:^(id _Nonnull responseObject){
        if (_page1 > 1) {
            [_data1 addObjectsFromArray:responseObject];
            [self.footer endRefreshing];
        }else{
             _data1  = [[NSMutableArray alloc]initWithArray:responseObject];
            [self.header endRefreshing];
        }
         [self.tableView reloadData];
    }  withErroBlock:^(NSError * _Nonnull error) {
        [self.header endRefreshing];
    }];
}
- (void)getUserFollowing
{
    NSLog(@"enter userfollowing!");
    NSString *urlStr = @"https://api.github.com/users/%@/following?page=%ld";
    urlStr = [NSString stringWithFormat:urlStr,self.userModel.login,(long)_page2];
    [[HttpKit sharedKit]doGet:urlStr withParam:nil withSucessBlock:^(id _Nonnull responseObject){
        if (_page2 > 1) {
            [_data2 addObjectsFromArray:responseObject];
            [self.footer endRefreshing];
        }else{
             _data2 =  [[NSMutableArray alloc] initWithArray: responseObject];
            [self.header endRefreshing];
        }
         [self.tableView reloadData];
    }  withErroBlock:^(NSError * _Nonnull error) {
        self.errorBlock(error);
    }];
 
}
- (void)getUserFollower
{
    NSString *urlStr = @"https://api.github.com/users/%@/followers?page=%ld";
    urlStr = [NSString stringWithFormat:urlStr,self.userModel.login,(long)_page3];
    [[HttpKit sharedKit]doGet:urlStr withParam:nil withSucessBlock:^(id _Nonnull responseObject){
        if (_page3 > 1) {
            [_data3 addObjectsFromArray:responseObject];
            [self.footer endRefreshing];
        }else{
             _data3 =  [[NSMutableArray alloc] initWithArray: responseObject];
            [self.header endRefreshing];
        }
        [self.tableView reloadData];
    }  withErroBlock:^(NSError * _Nonnull error) {
        self.errorBlock(error);
    }];
 
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
