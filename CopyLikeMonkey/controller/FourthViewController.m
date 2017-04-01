//
//  FourthViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/16.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "FourthViewController.h"
#import "LoginWebViewController.h"
#import "HttpHandler.h"
#import "Summer/Summer.h"
#import "UserModel.h"
#import "AboutViewController.h"
#import "NEHTTPEyeViewController.h"
#import "WebViewController.h"
@interface FourthViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *userAvatar;
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
    self.userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    self.userAvatar = [[NSUserDefaults standardUserDefaults]objectForKey:@"useravatar"];
    [self.tableView reloadData];
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
    if ([self isLogin]) {
        return 7;
    } else {
        return 6;
    }
}
-(Boolean)isLogin
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"token"] != nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"more"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"more"];
    }
    if (indexPath.section==0) {
        if ([self isLogin]) {
            cell.imageView.hidden = NO;
            cell.textLabel.text = self.userName;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.userAvatar]];
        }else{
            cell.imageView.hidden = YES;
            [cell.imageView sd_cancelCurrentImageLoad];
            cell.textLabel.text=NSLocalizedString(@"login", @"");
        }
    }else if (indexPath.section==1) {
        cell.textLabel.text=NSLocalizedString(@"about", @"");
    }else if (indexPath.section==2) {
        cell.textLabel.text=NSLocalizedString(@"feedback", @"");
    }else if (indexPath.section==3) {
        cell.textLabel.text=@"Network Debug";
    }else if(indexPath.section == 4){
        cell.textLabel.text = @"logout";
    }else if(indexPath.section == 5){
        cell.textLabel.text = @"test iuap";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        //login
        if ([self isLogin]) {
            [HttpHandler getUserInfoWithToken:^(id  _Nonnull responseObject) {
                NSLog(@"sucess %@",responseObject);
                UserModel *model = [UserModel modelWithDict:responseObject];
                self.userName = model.login;
                self.userAvatar = model.avatar_url;
                [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:self.userAvatar  forKey:@"useravatar"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self.tableView reloadData];
            } onError:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要登录吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action1];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LoginWebViewController *login = [[LoginWebViewController alloc]init];
                login.url = [HttpHandler getSendGithubOauthUrl];
                login.loginCallback = ^(NSString *access_token) {
                    [HttpHandler getUserInfoWithToken:^(id  _Nonnull responseObject) {
                        NSLog(@"sucess %@",responseObject);
                        UserModel *model = [UserModel modelWithDict:responseObject];
                        self.userName = model.login;
                        self.userAvatar = model.avatar_url;
                        [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"username"];
                        [[NSUserDefaults standardUserDefaults] setObject:self.userAvatar  forKey:@"useravatar"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [self.tableView reloadData];
                    } onError:^(NSError * _Nonnull error) {
                        NSLog(@"%@",error);
                    }];
                };
                [self.navigationController pushViewController:login animated:YES];
 
            }];
            [alertController addAction:action2];
           
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else if(indexPath.section == 1){
        AboutViewController *about = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }else if(indexPath.section == 2){
        WebViewController *web = [[WebViewController alloc]init];
        web.requstUrl = @"https://github.com/PHEOBUSYY/CopyOfMonkey";
        [self.navigationController pushViewController:web animated:YES];
    }else if (indexPath.section ==3){
        NEHTTPEyeViewController *vc=[[NEHTTPEyeViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if(indexPath.section ==4){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action1];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"useravatar"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.userAvatar = nil;
            self.userName = nil;
            [self.tableView reloadData];
 
                   }];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        
        NSDictionary *params = @{ @"identifier": @"root", //
                                  @"startPage": @"index.html", //
                                  @"wwwFolder": @"www", //
//                                  @"configPath": @"config.xml", //
                                  };
        UIViewController *vc = [Summer summerViewControllerWithParams:params];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
//        [self.navigationController pushViewController:navi animated:YES];
        self.tabBarController.tabBar.hidden = YES;
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
