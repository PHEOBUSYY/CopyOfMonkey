//
//  LanguageViewController.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/13.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LanguageEntranceType){
    UserLanguageEntranceType = 0,
    RepLanguageEntranceType,
    TrendingLanguageEntranceType,
};

@interface LanguageViewController : UITableViewController
@property (strong,nonatomic) NSArray *languages;
@property (assign,nonatomic) LanguageEntranceType languageEntranceType;
@end
