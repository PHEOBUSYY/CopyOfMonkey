//
//  FirstTableViewCell.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/8.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface FirstTableViewCell : UITableViewCell
@property (strong,nonatomic) UILabel *rankLabel;
@property (strong,nonatomic) UIImageView *avatar;
@property (strong,nonatomic) UILabel *title;
@property (strong,nonatomic) UILabel *detail;
-(void) showViewByModel:(UserModel *)model withIndex:(int)index;
@end
