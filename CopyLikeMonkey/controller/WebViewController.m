//
//  WebViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/30.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong,nonatomic) UIButton *backBtn;
@property (strong,nonatomic) UIButton *closeBtn;

@end

@implementation WebViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    [self.indicatorView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    if (self.requstUrl) {
        self.navigationItem.title = _requstUrl;
        [_webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_requstUrl]]];
    }
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(ScreenWidth-60, 0, 44, 44)];
    [self.navigationController.navigationBar addSubview:_indicatorView];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 33, 33);
    [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"ic_arrow_back_white_48pt"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(0, 0, 33, 33);
    [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeBtn setImage:[UIImage imageNamed:@"ic_cancel_white_48pt"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:_backBtn]];
    
}
-(void)clickBack
{
    if([self.webView canGoBack]){
        [self.webView goBack];
       self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:_backBtn],[[UIBarButtonItem alloc]initWithCustomView:_closeBtn]];
    }else{
        [self clickClose];
    }
}
-(void)clickClose
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma webViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicatorView startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorView stopAnimating];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.indicatorView stopAnimating];
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
