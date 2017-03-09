//
//  FirstTableViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/7.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "FirstTableViewController.h"
#import "FirstTableViewCell.h"
#import "TestObject.h"




@interface FirstTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView;
    YiRefreshHeader *header;
    float bgViewHeight;
}
@property(strong,nonatomic) NSMutableArray<UserModel*> *data;

@end

@implementation FirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //减去了顶部标题+状态栏+底部tabbar的高度
    bgViewHeight = ScreenHeight - 64 - 49;
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, bgViewHeight) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource=self;
//    tableView.rowHeight = 70;
    header = [[YiRefreshHeader alloc] init];
    header.scrollView=tableView;
    [header header];
    __weak typeof(self) weakself = self;
    header.beginRefreshingBlock = ^(){
        __strong typeof(self) strongself = weakself;
        [strongself requestWithAFNetWork];
    };
    [header beginRefreshing];
    
}

//-(void)sendData{
//    //模拟发送网络请求
//    
//    NSURLResponse *response = [[NSURLResponse alloc]init];
//    NSString *urlStr = @"https://api.github.com/";
//    NSURL *url = [[NSURL alloc]initWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    
//    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil ]);
//}
//-(void)sendAsyncData{
//    
//    NSString *urlStr = @"https://api.github.com/";
//    NSURL *url = [[NSURL alloc]initWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        if(connectionError){
//            NSLog(@"%@",connectionError);
//            NSLog(@"==resq====%@",response);
//            return;
//        }
//        //检验状态码
//        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//            if (((NSHTTPURLResponse *)response).statusCode != 200) {
//                return;
//            }
//        }
//        //解析json
//        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil ]);
//        
//        NSLog(@"====请求结束====");
//    }];
//    
//}
//-(void)sendNewRequestWithURLSession{
//    NSString *urlStr = @"https://api.github.com/";
//    NSURL *url = [[NSURL alloc]initWithString:urlStr];
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLSessionTask *task  = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if(error){
//            NSLog(@"%@",error);
//            NSLog(@"==resq====%@",response);
//            return;
//        }
//        //检验状态码
//        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//            if (((NSHTTPURLResponse *)response).statusCode != 200) {
//                return;
//            }
//        }
//        SBJson5ValueBlock block = ^(id v, BOOL *stop) {
//            BOOL isTestObejct = [v isKindOfClass:[NSDictionary class]];
//            NSLog(isTestObejct ? @"yes":@"no");
//            TestObject *test = [TestObject mj_objectWithKeyValues:v];
////            NSLog(@"the object is %@",test.current_user_url);
////            BOOL isArray = [v isKindOfClass:[NSArray class]];
////            NSLog(@"Found: %@", isArray ? @"Array" : @"Object");
//            
//        };
//        
//        SBJson5ErrorBlock eh = ^(NSError* err) {
//            NSLog(@"OOPS: %@", err);
//            exit(1);
//        };
//        
//        id parser = [SBJson5Parser parserWithBlock:block
//                                      errorHandler:eh];
//        [parser parse:data]; // returns SBJson5ParserWaitingForData
//        //解析json
////        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil ]);
//        
//        NSLog(@"====请求结束====");
//    }];
//    [task resume];
//}
-(void)requestWithAFNetWork{
    
    NSString *urlStr = @"https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000";
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
//            NSLog(@"%@ %@", response, responseObject);
            
            TestObject *test = [TestObject mj_objectWithKeyValues:responseObject];
//            NSLog(@"the object url is %@",test.items);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.data = test.items;
                for (int i=0; i<[self.data count]; i++) {
                    UserModel *model = [self.data objectAtIndex:i];
                    NSLog(@"the model is %@",[model valueForKey:@"login"]);
                }
                [tableView reloadData];
                [header endRefreshing];
            });

            
            
            
            
        }
    }];
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UserModel *model = [self.data objectAtIndex:indexPath.row];
    NSString *avatar = [model valueForKey:@"avatar_url"];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:avatar]];
    cell.title.text = [NSString stringWithFormat:@"%@",[model valueForKey:@"login"]];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
