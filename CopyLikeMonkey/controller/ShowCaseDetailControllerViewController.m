//
//  ShowCaseDetailControllerViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/28.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "ShowCaseDetailControllerViewController.h"
#import "ShowCaseViewCellTableViewCell.h"
#import "ShowcasesModel.h"
#import "RepoTableViewCell.h"
#import "RepositoryModel.h"
#import "RepositoriesDetailControllerViewController.h"
@interface ShowCaseDetailControllerViewController ()

@end

@implementation ShowCaseDetailControllerViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    self.navigationItem.title = self.model.name;
}
-(void)configView
{
    self.tableView.rowHeight = 100;
}
-(Boolean)needConfigFooter
{
    return NO;
}

-(void)requestData:(Boolean)isFirst
{
    [HttpHandler getShowCaseDetail:self.model.slug onSucess:^(id  _Nonnull responseObject) {
        NSArray * list = [responseObject objectForKey:@"repositories"];
        if (isFirst) {
            self.data = [[NSMutableArray alloc]initWithArray:list];
            [self.header endRefreshing];
        }else{
            [self.data addObjectsFromArray:list];
            [self.footer endRefreshing];
        }
        [self.tableView reloadData];
    } onError:^(NSError * _Nonnull error) {
        if (isFirst) {
            [self.header endRefreshing];
        }else{
            [self.footer endRefreshing];
        }
        NSLog(@"%@",error);
    }];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    if (cell == nil) {
        cell = [[RepoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"base"];
    }
    id modelDic = self.data[indexPath.row];
    RepositoryModel *model =[RepositoryModel modelWithDict:modelDic];
    [cell showViewByModel:model withIndex:(int)(indexPath.row+1)];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepositoriesDetailControllerViewController *detail = [[RepositoriesDetailControllerViewController alloc] init];
    id modelDic = self.data[indexPath.row];
    RepositoryModel *model =[RepositoryModel modelWithDict:modelDic];
    detail.repo = model;
    [self.navigationController pushViewController:detail animated:YES];
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
