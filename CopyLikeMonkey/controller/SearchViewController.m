//
//  SearchViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/29.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailSegmentControll.h"
#import "DetailSegmentControll.h"
#import "HttpHandler.h"
#import "UserModel.h"
#import "RepositoryModel.h"
#import "RepoTableViewCell.h"
#import "FirstTableViewCell.h"
#import "RankDetailViewController.h"
#import "RepositoriesDetailControllerViewController.h"
@interface SearchViewController () <UISearchBarDelegate>
@property (strong,nonatomic) DetailSegmentControll *headControll;
@property (strong,nonatomic) UISearchBar *searchBar;
@property (assign,nonatomic) int currentIndex;
@property (assign,nonatomic) int page1;
@property (assign,nonatomic) int page2;
@property (strong,nonatomic) NSMutableArray *data1;
@property (strong,nonatomic) NSMutableArray *data2;
@end
@implementation SearchViewController

-(Boolean)needFristUpdate
{
    return NO;
}
-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController.navigationBar addSubview:_searchBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchBar removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 2, ScreenWidth - 90, 40)];
    _searchBar.delegate = self;
    [self.navigationController.navigationBar addSubview:_searchBar];
    _searchBar.tintColor = YiBlue;
    [_searchBar becomeFirstResponder];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
    self.navigationItem.rightBarButtonItem = right;
    
    _headControll = [[DetailSegmentControll alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 38)];
    _headControll.buttonCount = 2;
    _headControll.showTopLabel = NO;
    _headControll.label1Bottom.text = @"user";
    _headControll.label2Bottom.text = @"repo";
    self.tableView.tableHeaderView = _headControll;
    WEAKREF
    _headControll.clickBlock = ^(int clickIndex){
        STRONGREF
        strongSelf.currentIndex = clickIndex;
        if (clickIndex == 0) {
            if (strongSelf.data1==nil ||[strongSelf.data1 count] == 0) {
                strongSelf.data1 = [[NSMutableArray alloc]initWithCapacity:0];
                [strongSelf.tableView reloadData];
                [strongSelf.header beginRefreshing];
            } else{
                [strongSelf.tableView reloadData];
            }
        }else {
            if (strongSelf.data2==nil ||[strongSelf.data2 count] == 0) {
                strongSelf.data2 = [[NSMutableArray alloc]initWithCapacity:0];
                [strongSelf.tableView reloadData];
 
                [strongSelf.header beginRefreshing];
            }else {
                [strongSelf.tableView reloadData];
            }
 
        }
    };
}
-(void)cancelClick:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.header beginRefreshing];
     [_searchBar endEditing:YES];
    
}
-(void)requestData:(Boolean)isFirst
{
    if (isFirst) {
        if (_currentIndex == 0) {
            self.page1 = 1;
        }else{
            self.page2 = 1;
        }
    } else {
        if (_currentIndex == 0) {
            self.page1++;
        }else{
            self.page2++;
        }
    
    }
    if (self.currentIndex == 0) {
        [HttpHandler searchUser:_searchBar.text withPage:self.page1 onSucess:^(id  _Nonnull responseObject) {
            NSMutableArray *data = [responseObject valueForKey:@"items"];
            if(isFirst){
                self.data1 = [[NSMutableArray alloc] initWithArray:data];
                [self.header endRefreshing];
            }else{
                [self.data1 addObjectsFromArray:data];
                [self.footer endRefreshing];
            }
            [self.tableView reloadData];
        } onError:^(NSError * _Nonnull error) {
            if(isFirst){
                [self.header endRefreshing];
            }else{
                [self.footer endRefreshing];
            }
        }];
    } else {
        [HttpHandler searchRepo:_searchBar.text withPage:self.page2 onSucess:^(id  _Nonnull responseObject) {
              NSMutableArray *data = [responseObject valueForKey:@"items"];
            if(isFirst){
                self.data2 = [[NSMutableArray alloc] initWithArray:data];
                [self.header endRefreshing];
            }else{
                [self.data2 addObjectsFromArray:data];
                [self.footer endRefreshing];
            }
            [self.tableView reloadData];
        } onError:^(NSError * _Nonnull error) {
            if(isFirst){
                [self.header endRefreshing];
            }else{
                [self.footer endRefreshing];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentIndex == 0) {
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
        if (!cell) {
            cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"user"];
        }
        UserModel *model = [UserModel modelWithDict:self.data1[indexPath.row]];
        [cell showViewByModel:model withIndex:(int)(indexPath.row + 1)];
        return cell;
    } else {
        RepoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repo"];
        cell = [[RepoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"repo"];
        RepositoryModel *model = [RepositoryModel modelWithDict:self.data2[indexPath.row]];
        [cell showViewByModel:model withIndex:(int)(indexPath.row + 1)];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentIndex == 0 ) {
        return [self.data1 count];
    }else{
        return [self.data2 count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentIndex == 0) {
        return 70;
    }else {
        return 100;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentIndex == 0) {
        RankDetailViewController *detail = [[RankDetailViewController alloc] init];
        detail.userModel = [UserModel modelWithDict:self.data1[indexPath.row]];
        [self.navigationController pushViewController:detail animated:YES];
    }else {
        RepositoriesDetailControllerViewController *detail = [[RepositoriesDetailControllerViewController alloc] init];
        detail.repo = [RepositoryModel modelWithDict:self.data2[indexPath.row]];
        [self.navigationController pushViewController:detail animated:YES];
    }
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
