//
//  LoginWebViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/31.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "LoginWebViewController.h"
#import "HttpHandler.h"
@interface LoginWebViewController () <UIWebViewDelegate>
@property (strong,nonatomic)UIWebView *webView;
@end

@implementation LoginWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    
    NSURL *urlN =[NSURL URLWithString:self.url];
    NSURLRequest * request = [NSURLRequest requestWithURL:urlN];
    [_webView loadRequest:request];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL * redirectUrl = _webView.request.URL;
        NSLog(@"url is = %@",redirectUrl);
    NSURLComponents *component = [[NSURLComponents alloc]initWithURL:redirectUrl resolvingAgainstBaseURL:NO];
    NSArray *params =  component.queryItems;
    for (int i =0; i<[params count]; i++) {
        NSLog(@"params is = %@",params[i]);
    }
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"name=%@",@"code"];
    NSURLQueryItem *item = [[params filteredArrayUsingPredicate:predicat]firstObject];
    NSString *code = item.value;
    NSLog(@"value =%@",code);
    
    if (!code) {
        return;
    }
    [HttpHandler sendGithubOauth:code onSucess:^(id  _Nonnull responseObject) {
         NSLog(@"suecess %@",responseObject);
        NSString *access_token = [responseObject objectForKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]setObject:access_token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"the sucess token is %@",responseObject);
        if (_loginCallback) {
            _loginCallback(access_token);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } onError:^(NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
    
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
