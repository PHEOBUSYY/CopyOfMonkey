//
//  ShowCaseViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/23.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "ShowCaseViewController.h"
#import "HttpHandler.h"
#import "ShowcasesModel.h"
#import "ShowCaseViewCellTableViewCell.h"
#import "ShowCaseDetailControllerViewController.h"
@interface ShowCaseViewController ()

@end

@implementation ShowCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"showCases";
}
-(Boolean)needConfigFooter
{
    return NO;
}

-(void)requestData:(Boolean)isFirst
{
    
    [HttpHandler getShowCase:^(id  _Nonnull responseObject) {
        if (isFirst) {
            self.data = [[NSMutableArray alloc]initWithArray:responseObject];
            [self.header endRefreshing];
        }else{
            [self.data addObjectsFromArray:responseObject];
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
    ShowCaseViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    if (cell == nil) {
        cell = [[ShowCaseViewCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"base"];
    }
    id modelDic = self.data[indexPath.row];
    ShowcasesModel *model =[ShowcasesModel modelWithDict:modelDic];
    [cell.logo sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    cell.title.text = model.name;
    cell.desc.text = model.showcasesDescription;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id modelDic = self.data[indexPath.row];
    ShowcasesModel *model =[ShowcasesModel modelWithDict:modelDic];
    ShowCaseDetailControllerViewController *detail = [[ShowCaseDetailControllerViewController alloc]init];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
