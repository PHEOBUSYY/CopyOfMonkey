//
//  BaseRequestViewController.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/23.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"
#import "HttpKit.h"
#import "HttpHandler.h"
@interface BaseRequestViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource>
@property (strong,nonatomic) UITableView * tableView;

@property (strong,nonatomic) YiRefreshHeader *header;
@property (strong,nonatomic) YiRefreshFooter *footer;
@property (strong,nonatomic) NSMutableArray *data;
@property (assign,nonatomic) int page;
-(void)requestData:(Boolean)isFirst;
-(Boolean)needConfigHeader;
-(Boolean)needConfigFooter;
-(Boolean)needFristUpdate;

@end
