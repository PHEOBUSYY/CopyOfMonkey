//
//  HeaderSegmentControl.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/9.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderSegmentControl : UIView
@property(strong,nonatomic) UIButton *buttonFirst;
@property(strong,nonatomic) UIButton *buttonSecond;
@property(strong,nonatomic) UIButton *buttonThird;
@property(strong,nonatomic) UIButton *buttonFourth;

@property(copy,nonatomic) void (^ClickBlock)(NSInteger clickIndex);
-(void)clickIndex:(NSInteger)clickIndex;

@property(nonatomic,assign) int buttonCount;

@end
