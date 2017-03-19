//
//  UIRankDataSource.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/10.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface UIRankDataSource : NSObject<UITableViewDataSource>
@property(strong,nonatomic) NSMutableArray *dataArray1;
@property(strong,nonatomic) NSMutableArray *dataArray2;
@property(strong,nonatomic) NSMutableArray *dataArray3;
@property(assign,nonatomic) NSInteger clickIndex;
@end
