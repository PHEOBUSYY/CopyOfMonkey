//
//  LanguageViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/13.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "LanguageViewController.h"

@interface LanguageViewController ()


@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.tabBarController.tabBar.hidden = YES;
    if (_languageEntranceType==RepLanguageEntranceType) {
        _languages=@[@"JavaScript",@"Java",@"PHP",@"Ruby",@"Python",@"CSS",@"CPP",@"C",@"Objective-C",@"Swift",@"Shell",@"R",@"Perl",@"Lua",@"HTML",@"Scala",@"Go"];
    }else if (_languageEntranceType==UserLanguageEntranceType  ) {
        _languages=@[NSLocalizedString(@"all languages", @""),@"JavaScript",@"Java",@"PHP",@"Ruby",@"Python",@"CSS",@"CPP",@"C",@"Objective-C",@"Swift",@"Shell",@"R",@"Perl",@"Lua",@"HTML",@"Scala",@"Go"];
    }else if (_languageEntranceType==TrendingLanguageEntranceType ) {
        _languages=@[NSLocalizedString(@"all languages", @""),@"javascript",@"java",@"php",@"ruby",@"python",@"css",@"cpp",@"c",@"objective-c",@"swift",@"shell",@"r",@"perl",@"lua",@"html",@"scala",@"go"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_languages count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"language"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"language"];
    }
    cell.textLabel.text = _languages[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:_languages[indexPath.row] forKey:@"language"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
