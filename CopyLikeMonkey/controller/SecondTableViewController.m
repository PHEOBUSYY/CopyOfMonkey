//
//  SecondTableViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/14.
//  Copyright © 2017年 阎翼. All rights reserved.
//  第二个列表.通过star数获取某一语言的排行
//

#import "SecondTableViewController.h"
#import "RepositoryModel.h"
#import "TestObject.h"
#import "LanguageViewController.h"
#import "RepoTableViewCell.h"
@interface SecondTableViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSString *currentLanguage;
}
@property (strong,nonatomic) NSArray * data;
@property (strong,nonatomic) YiRefreshHeader * header;
@property (strong,nonatomic) YiRefreshFooter * footer;
@property (assign,nonatomic) int page;
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation SecondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self initMainView];
    _page = 1;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if (language == nil) {
        language = @"repo";
    }
    self.navigationItem.title = language;
    
    self.tabBarController.tabBar.hidden = NO;
    if ([currentLanguage isEqualToString:language]) {
        return;
    }
    currentLanguage = language;
    [_header beginRefreshing];
}
-(void) initMainView
{
    self.navigationItem.title = @"Repo";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"language" style:UIBarButtonItemStylePlain target:self action:@selector(goLanguage)];
    self.tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    _header = [[YiRefreshHeader alloc]init];
    _header.scrollView = self.tableView;
    [_header header];
    WEAKREF
    _header.beginRefreshingBlock = ^(){
        STRONGREF
        strongSelf.page = 1;
        [strongSelf sendRequest];
    };
    
    _footer = [[YiRefreshFooter alloc]init];
    _footer.scrollView = self.tableView ;
    [_footer footer];
    _footer.beginRefreshingBlock=^(){
        STRONGREF
        strongSelf.page++;
        [strongSelf sendRequest];
    };
    
}
-(void)goLanguage
{
    LanguageViewController *languageController = [[LanguageViewController alloc] init];
    [self.navigationController pushViewController:languageController animated:YES];
}
    

-(void)sendRequest
{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    NSString *q = [NSString stringWithFormat: @"language:%@",language];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&page=%d&sort=stars",q,_page];;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    NSURLSessionTask *task =  [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [self parseData:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                TestObject *test = [TestObject mj_objectWithKeyValues:responseObject];
                [self parseData:test];
            });
            
        }
    
    }];
    [task resume];
}
-(void)parseData:(TestObject *)test
{
    if (_page>1) {
        [self.footer endRefreshing];
        NSMutableArray * allData = [[NSMutableArray alloc]initWithArray:_data];
        [allData addObjectsFromArray:test.items];
        _data = [allData copy];
    }else{
        [self.header endRefreshing];
        _data = test.items;
    }
    
    if (_data == nil) {
        _data = [[NSArray alloc]init];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data == nil) {
        return 0;
    }
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repo"];
    if (cell == nil) {
        cell = [[RepoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"repo"];
    }
    RepositoryModel *model = [RepositoryModel modelWithDict:_data[indexPath.row]] ;
    //这里要注意请求返回的居然是一个字典,不是理解上的对象,可以直接获取属性
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ _ %ld", [model valueForKey:@"login"],indexPath.row];
    cell.rankLanbel.text = [NSString stringWithFormat:@"%ld",indexPath.row] ;
    cell.loginLable.text = model.name;
    cell.netLebal.text = model.homepage;
    cell.ownerLabel.text = [NSString stringWithFormat:@"owner:%@", model.user.login];
    cell.startLabel.text = [NSString stringWithFormat:@"stars:%d",model.stargazers_count];
    cell.desLabel.text = model.repositoryDescription;
    
    [cell.avarta sd_setImageWithURL:[NSURL URLWithString:model.user.avatar_url]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
