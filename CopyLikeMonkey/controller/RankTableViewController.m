//
//  RankTableViewController.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/7.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "RankTableViewController.h"
@interface RankTableViewController()<UITableViewDelegate>

@end
@implementation RankTableViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
}
-(void)initData{
    self.tableView.delegate = self;
    
    
}


@end
