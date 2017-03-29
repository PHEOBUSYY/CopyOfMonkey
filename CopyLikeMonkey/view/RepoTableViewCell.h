//
//  RepoTableViewCell.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/15.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepositoryModel.h"
@interface RepoTableViewCell : UITableViewCell
@property (strong,nonatomic) UILabel *rankLanbel;
@property (strong,nonatomic) UILabel *ownerLabel;
@property (strong,nonatomic) UILabel * desLabel;
@property (strong,nonatomic) UILabel *startLabel;
@property (strong,nonatomic) UILabel *loginLable;
@property (strong,nonatomic) UILabel *netLebal;
@property (strong,nonatomic) UIImageView *avarta;
-(void)showViewByModel:(RepositoryModel *)model withIndex:(int)index;
@end
