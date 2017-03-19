//
//  ThirdViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/16.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initMainView];
}
- (void)initMainView
{
    //顶部的状态栏的高端是64
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 49 -64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discover"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"discover"];
    }
    if (indexPath.section==0) {
        cell.textLabel.text=@"trending";
    }else if (indexPath.section==1) {
        cell.textLabel.text=@"showcases";
    }else if (indexPath.section==2) {
        cell.textLabel.text=NSLocalizedString(@"News", @"");
    }else if (indexPath.section==3) {
        cell.textLabel.text=NSLocalizedString(@"search", @"");
    }else if (indexPath.section==4) {
        cell.textLabel.text=@"githubranking";
    }else if (indexPath.section==5) {
        cell.textLabel.text=@"github-awards";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
