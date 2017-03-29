//
//  ShowCaseDetailControllerViewController.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/28.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequestViewController.h"
#import "ShowcasesModel.h"
@interface ShowCaseDetailControllerViewController : BaseRequestViewController
@property (strong,nonatomic) ShowcasesModel *model;
@end
