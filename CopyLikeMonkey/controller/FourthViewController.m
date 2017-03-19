//
//  FourthViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/16.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
}

-(void)initMainView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"more"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"more"];
    }
    if (indexPath.section==0) {
        cell.textLabel.text=NSLocalizedString(@"login", @"");
    }else if (indexPath.section==1) {
        cell.textLabel.text=NSLocalizedString(@"about", @"");
    }else if (indexPath.section==2) {
        cell.textLabel.text=NSLocalizedString(@"feedback", @"");
    }else if (indexPath.section==3) {
        cell.textLabel.text=@"Network Debug";
    }
    return cell;
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
