//
//  Github-awardsViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/29.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "Github-awardsViewController.h"
#import "WebViewController.h"

@interface Github_awardsViewController ()

@end

@implementation Github_awardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *head = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    head.textAlignment = NSTextAlignmentCenter;
    head.text = @"ranking by stars";
    head.textColor = YiTextGray;
    self.tableView.tableHeaderView = head;
    
    UIButton * footer = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [footer setTitleColor:YiBlue forState:UIControlStateNormal];
    [footer setTitle:@"data from githubranking.com" forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(clickFooter) forControlEvents:UIControlEventTouchUpInside];
    footer.titleLabel.font = [UIFont systemFontOfSize:13];
    self.tableView.tableFooterView = footer;
    
    NSArray * rankCategorys=@[@"users ranking world",@"users ranking country",@"users ranking city"];
    self.data = [[NSMutableArray alloc] initWithArray:rankCategorys];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}
- (void)clickFooter
{
    WebViewController *web = [[WebViewController alloc]init];
    web.requstUrl = @"http://github-awards.com/";
    [self.navigationController pushViewController:web animated:YES];
}
-(Boolean)needConfigFooter
{
    return NO;
}
-(Boolean)needConfigHeader
{
    return NO;
}
-(Boolean)tableViewStyleIsGroup
{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    cell.textLabel.text = self.data[indexPath.section];
    return cell;
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
