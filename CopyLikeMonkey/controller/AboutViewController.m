//
//  AboutViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/4/1.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"about";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMainView];
}
- (void)initMainView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    float topSpace = 50;
    float labelHeight = 25;
    UILabel *author = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+topSpace, ScreenWidth, labelHeight)];
    author.textAlignment = NSTextAlignmentCenter;
    author.textColor = YiTextGray;
    author.font = [UIFont systemFontOfSize:14];
    author.text = @"author: pheobusYY";
    [self.view addSubview:author];
    
    UIButton *url = [UIButton buttonWithType:UIButtonTypeCustom];
    [url setTitleColor:YiBlue forState:UIControlStateNormal];
    url.frame = CGRectMake(30, 64+2*topSpace, ScreenWidth - 60,labelHeight);
    [url setTitle:@"https://github.com/PHEOBUSYY/CopyOfMonkey" forState:UIControlStateNormal];
    
    [self.view addSubview:url];
    [url addTarget:self action:@selector(goToWeb) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(20, 64+topSpace*3, ScreenWidth-20,labelHeight*2)];
    desc.textColor = YiTextGray;
    desc.font = [UIFont systemFontOfSize:14];
    desc.numberOfLines = 3;
    desc.textAlignment = NSTextAlignmentCenter;
    desc.text = @"this is personal ios project for learn the monkey project !!! the monkey project is a github client ";
    [self.view addSubview:desc];
    
}
-(void)goToWeb
{
    WebViewController *web = [[WebViewController alloc] init];
    web.requstUrl = @"https://github.com/PHEOBUSYY/CopyOfMonkey";
    [self.navigationController pushViewController:web animated:YES];
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
