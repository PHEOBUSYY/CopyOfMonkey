//
//  DetailSegmentControll.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/16.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSegmentControll : UIView
@property (strong,nonatomic) UIButton *button1;
@property (strong,nonatomic) UIButton *button2;
@property (strong,nonatomic) UIButton *button3;

@property (strong,nonatomic) UILabel *label1Top;
@property (strong,nonatomic) UILabel *label2Top;
@property (strong,nonatomic) UILabel *label3Top;

@property (strong,nonatomic) UILabel *label1Bottom;
@property (strong,nonatomic) UILabel *label2Bottom;
@property (strong,nonatomic) UILabel *label3Bottom;

@property (strong,nonatomic) UIView *indicateView;

@property (copy,nonatomic) void(^clickBlock)(int clickIndex);

@property (assign,nonatomic) int currentIndex;
@property (assign,nonatomic) int buttonCount;
@property (assign,nonatomic) Boolean showTopLabel;
@end
