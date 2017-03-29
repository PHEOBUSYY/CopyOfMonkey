//
//  RepositoriesDetailControllerViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/21.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "RepositoriesDetailControllerViewController.h"
#import "RankDetailViewController.h"
#import "DetailSegmentControll.h"
#import "HttpHandler.h"
#import "FirstTableViewCell.h"
#import "LanguageViewController.h"

@interface RepositoriesDetailControllerViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) YiRefreshHeader *header;
@property (strong,nonatomic) YiRefreshFooter *footer;
@property (strong,nonatomic) DetailSegmentControll *headerControll;
@property (strong,nonatomic) UIView *headerDetailView;
@property (strong,nonatomic) UILabel *descLabel;
@property (strong,nonatomic) UIImageView *avatarIv;
@property (strong,nonatomic) UILabel *createTimeLabel;
@property (strong,nonatomic) UIButton *ownerBtn;
@property (strong,nonatomic) UIButton *nameBtn;
@property (strong,nonatomic) UILabel *lineLabel;
@property (assign,nonatomic) int page1;
@property (assign,nonatomic) int page2;
@property (assign,nonatomic) int page3;
@property (strong,nonatomic) NSMutableArray *data1;
@property (strong,nonatomic) NSMutableArray *data2;
@property (strong,nonatomic) NSMutableArray *data3;
@end

@implementation RepositoriesDetailControllerViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.page1 = self.page2 = self.page3 = 1;
    }
    return self;
}

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    [self configNavig];
    [self initMainView];
    [self refreshDetail];
}
- (void) configNavig
{
     UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"langauge" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)rightAction:(UIBarButtonItem *)button
{
    LanguageViewController *language = [[LanguageViewController alloc] init];
    [self.navigationController pushViewController:language animated:YES];
}
- (void)initMainView
{
    [self initTableView];
    [self initTableViewHeader];
    self.tableView.tableHeaderView = self.headerDetailView;
    [self initYiHeaderAndFooter];
}
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    
    
}
- (void)initTableViewHeader
{
    [self initDetailHeader];
    [self initHeaderControll];
}
- (void)initDetailHeader
{
    float topSpace = 10;
    float space = 10;
    float imageViewWeight = 30;
    float smallFont = 11;
    float cormalFont = 14;
    float nameWidth  = 100;
    float ownerWidth = 80;
    float labelHeight = 20;

    self.headerDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5 *topSpace + 3 * labelHeight + 68)];
    self.headerDetailView.backgroundColor = [UIColor whiteColor];
    
    self.nameBtn = [[UIButton alloc]initWithFrame:CGRectMake(space, topSpace, nameWidth, labelHeight)];
    [self.nameBtn setTitleColor:YiBlue forState:UIControlStateNormal];
   
    
    self.nameBtn.titleLabel.font = [UIFont systemFontOfSize:cormalFont];
    
    
    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(space + nameWidth, topSpace, 5, labelHeight)];
    self.lineLabel.text = @"/";
    self.lineLabel.textColor = YiGray;
    
    self.ownerBtn = [[UIButton alloc] initWithFrame: CGRectMake(space+nameWidth + 5, topSpace, ownerWidth, labelHeight)];
    [self.ownerBtn setTitleColor:YiBlue forState:UIControlStateNormal];
    self.ownerBtn.titleLabel.font = [UIFont systemFontOfSize:cormalFont];
    
    self.avatarIv = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - space - imageViewWeight, topSpace, imageViewWeight, imageViewWeight)];
    self.avatarIv.layer.cornerRadius = 11;
    self.avatarIv.layer.borderColor = YiGray.CGColor;
    self.avatarIv.layer.borderWidth = 0.3;
    self.avatarIv.layer.masksToBounds = YES;
    
    self.createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(space, topSpace + labelHeight + topSpace, nameWidth, labelHeight)];
    self.createTimeLabel.font = [UIFont systemFontOfSize:smallFont];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, topSpace*3 + labelHeight*2  , ScreenWidth - space*2 , 2*labelHeight)];
    self.descLabel.numberOfLines = 2;
    self.descLabel.font = [UIFont systemFontOfSize:smallFont];
    
    [self.headerDetailView addSubview:self.ownerBtn];
    [self.headerDetailView addSubview:self.lineLabel];
    [self.headerDetailView addSubview:self.nameBtn];
    [self.headerDetailView addSubview:self.avatarIv];
    [self.headerDetailView addSubview:self.createTimeLabel];
    [self.headerDetailView addSubview:self.descLabel];
    
   
}
- (void)initHeaderControll
{
    _headerControll = [[DetailSegmentControll alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 68)];
    self.headerControll.label1Top.text = @"";
    self.headerControll.label2Top.text = @"";
    self.headerControll.label3Top.text = @"";
    
    self.headerControll.label1Bottom.text = @"Contributors";
    self.headerControll.label2Bottom.text = @"Forks";
    self.headerControll.label3Bottom.text = @"Star";
    WEAKREF
    self.headerControll.clickBlock = ^(int clickIndex){
        STRONGREF
        [strongSelf.tableView reloadData];
        [strongSelf getDataWithClickIndex:clickIndex];
    };
    [self.headerDetailView addSubview:self.headerControll];
}
- (void)initYiHeaderAndFooter
{
    _header = [[YiRefreshHeader alloc] init];
    _header.scrollView = _tableView;
    [_header header];
    WEAKREF
    _header.beginRefreshingBlock = ^(){
        STRONGREF
            [HttpHandler getRepoDetailFromNet:strongSelf.repo.name withOwner:strongSelf.repo.user.login page:1 onSucess:^(id  _Nonnull responseObject) {
                //NSLog(@"%@",responseObject);
                strongSelf.repo = [RepositoryModel modelWithDict:responseObject];
                [strongSelf refreshDetail];
                //[strongSelf.header endRefreshing];
                [strongSelf getDataWithClickIndex:[strongSelf getCurrntIndex]];
            } onError:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
                 [strongSelf.header endRefreshing];
            }];
    };
    [self.header beginRefreshing];
    
    _footer = [[YiRefreshFooter alloc]init];
    _footer.scrollView = self.tableView;
    [_footer footer];
    _footer.beginRefreshingBlock = ^(){
        STRONGREF
        if ([strongSelf getCurrntIndex ] == 1) {
            strongSelf.page2 ++;
        }else if([strongSelf getCurrntIndex ] == 2){
            strongSelf.page3 ++;
        }else{
            strongSelf.page1 ++;
        }
        [strongSelf getDataWithClickIndex:[strongSelf getCurrntIndex]];
    };
}
- (void)refreshDetail
{
    if (self.repo) {
        [self.nameBtn setTitle:self.repo.name forState:UIControlStateNormal];
        
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //根据文字的长度来调整view的位置
        float nameWidth=[self.repo.name sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake((ScreenWidth-2*10)/2, 20) lineBreakMode:NSLineBreakByWordWrapping].width;
        CGRect frame = self.nameBtn.frame;
        frame.size.width = nameWidth;
        self.nameBtn.frame = frame;
        
        CGRect lineFrame = self.lineLabel.frame;
        lineFrame.origin.x = nameWidth + 10 ;
        self.lineLabel.frame = lineFrame;
        
        CGRect ownerFrame = self.ownerBtn.frame;
        ownerFrame.origin.x = nameWidth + 15;
        self.ownerBtn.frame = ownerFrame;
        [self.ownerBtn setTitle:self.repo.user.login forState:UIControlStateNormal];
        self.ownerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:self.repo.user.avatar_url]];
        self.descLabel.text = self.repo.repositoryDescription;
        self.createTimeLabel.text = [self.repo.created_at substringToIndex:10];
        
        self.headerControll.label2Top.text = [NSString stringWithFormat:@"%d",self.repo.forks_count];
        self.headerControll.label3Top.text = [NSString stringWithFormat:@"%d",self.repo.stargazers_count];
    }
}
- (int) getCurrntIndex
{
    return [self.headerControll currentIndex];
}
- (void)getDataWithClickIndex:(int) clickIndex
{
    if ([self getCurrntIndex] == 1) {
        [self getForks];
    }else if([self getCurrntIndex] == 2){
        [self getStars];
    }else{
        [self getContribute];
    }
}
- (void)getContribute
{
    [HttpHandler getRepoContribute:self.repo.name withOwner:self.repo.user.login page:self.page1 onSucess:^(id  _Nonnull responseObject) {
        if (_page1 > 1) {
            [self.data1 addObjectsFromArray:responseObject];
            [self.footer endRefreshing];
        }else{
            self.data1 = [[NSMutableArray alloc]initWithArray:responseObject];
            [self.header endRefreshing];
        }
        [self.tableView reloadData];
    } onError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)getForks
{
    [HttpHandler getForkList:self.repo.name withOwner:self.repo.user.login page:self.page1 onSucess:^(id  _Nonnull responseObject) {
        if (_page2 > 1) {
            [self.data2 addObjectsFromArray:responseObject];
            [self.footer endRefreshing];
        }else{
            self.data2 = [[NSMutableArray alloc]initWithArray:responseObject];
            [self.header endRefreshing];
        }
        [self.tableView reloadData];
        
    } onError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)getStars
{
    [HttpHandler getStarsList:self.repo.name withOwner:self.repo.user.login page:self.page1 onSucess:^(id  _Nonnull responseObject) {
        if (_page3 > 1) {
            [self.data3 addObjectsFromArray:responseObject];
             [self.footer endRefreshing];
        }else{
            self.data3 = [[NSMutableArray alloc]initWithArray:responseObject];
             [self.header endRefreshing];
        }
        [self.tableView reloadData];
       
    } onError:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"repodetail%d",[self getCurrntIndex]]];
    if (cell == nil) {
        cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"repodetail%d",[self getCurrntIndex]]];
    }
    UserModel * model = nil;
    if ([self getCurrntIndex] == 1) {
        model =[RepositoryModel modelWithDict: self.data2[indexPath.row]].user;
    } else if([self getCurrntIndex] == 2){
        model =[UserModel modelWithDict: self.data3[indexPath.row]];
    }else {
        model = [UserModel modelWithDict:self.data1[indexPath.row]];
    }
    [cell showViewByModel:model withIndex:(int)(indexPath.row + 1)];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel * model = nil;
    if ([self getCurrntIndex] == 1) {
        model =[RepositoryModel modelWithDict: self.data2[indexPath.row]].user;
    } else if([self getCurrntIndex] == 2){
        model =[UserModel modelWithDict: self.data3[indexPath.row]];
    }else {
        model = [UserModel modelWithDict:self.data1[indexPath.row]];
    }
    RankDetailViewController *ranDetail = [[RankDetailViewController alloc]init];
    ranDetail.userModel = model;
    [self.navigationController pushViewController:ranDetail animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self getCurrntIndex] == 1) {
        return [_data2 count];
    }else if([self getCurrntIndex] == 2){
        return [_data3 count];
    }else{
        return [_data1 count];
    }
    return 0;
}

@end
