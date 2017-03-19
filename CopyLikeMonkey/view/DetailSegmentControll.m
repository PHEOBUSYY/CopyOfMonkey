
//
//  DetailSegmentControll.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/16.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "DetailSegmentControll.h"
@interface DetailSegmentControll()
@property (strong,nonatomic) NSMutableArray *buttonArray;
@property (strong,nonatomic) NSMutableArray<UILabel *> *labelTopArray;
@property (strong,nonatomic) NSMutableArray<UILabel *> *labelBottomArray;
@end
@implementation DetailSegmentControll
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:3];
        _labelTopArray = [[NSMutableArray alloc] initWithCapacity:3];
        _labelBottomArray = [[NSMutableArray alloc] initWithCapacity:3];
        float avgWidth = ScreenWidth/3;
        float topSpace = 5;
        float labelHeight = 25;
        float labelWidth = avgWidth - 5;
        float indicateHeight = 3;
        float indicateWeight = 50;
        float h = topSpace + labelHeight + topSpace + labelHeight + topSpace + indicateHeight;
        self.button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, avgWidth, h)];
        self.button2 = [[UIButton alloc] initWithFrame:CGRectMake(avgWidth, 0, ScreenWidth/3, h)];
        self.button3 = [[UIButton alloc] initWithFrame:CGRectMake(avgWidth*2, 0, ScreenWidth/3, h)];
        
        self.label1Top = [[UILabel alloc] initWithFrame:CGRectMake((avgWidth - labelWidth)/2, topSpace, labelWidth, labelHeight)];
        self.label1Bottom = [[UILabel alloc] initWithFrame:CGRectMake((avgWidth - labelWidth)/2, topSpace+labelHeight+topSpace, labelWidth, labelHeight)];
//        self.label1Top.text = @"135";
        self.label1Bottom.text = @"Repositories";
        
        
        self.label2Top = [[UILabel alloc] initWithFrame:CGRectMake((avgWidth - labelWidth)/2+avgWidth, topSpace, labelWidth, labelHeight)];
        self.label2Bottom = [[UILabel alloc] initWithFrame:CGRectMake((avgWidth - labelWidth)/2 +avgWidth, topSpace+labelHeight+topSpace, labelWidth, labelHeight)];
//        self.label2Top.text = @"135";
        self.label2Bottom.text = @"Following";
        
        
        self.label3Top = [[UILabel alloc] initWithFrame:CGRectMake((avgWidth - labelWidth)/2+avgWidth*2, topSpace, labelWidth, labelHeight)];
        self.label3Bottom = [[UILabel alloc] initWithFrame:CGRectMake((avgWidth - labelWidth)/2 + avgWidth*2, topSpace+labelHeight+topSpace, labelWidth, labelHeight)];
//        self.label3Top.text = @"135";
        self.label3Bottom.text = @"Follower";
        
        
        self.indicateView = [[UIView alloc] initWithFrame:CGRectMake((avgWidth - indicateWeight)/2, topSpace + labelHeight + topSpace + labelHeight +topSpace, indicateWeight, indicateHeight)];
        self.indicateView.backgroundColor = YiBlue;
        [self.buttonArray addObject:self.button1];
        [self.buttonArray addObject:self.button2];
        [self.buttonArray addObject:self.button3];
        
        [self.labelTopArray addObject:self.label1Top];
        [self.labelTopArray addObject:self.label2Top];
        [self.labelTopArray addObject:self.label3Top];
        
        
        [self.labelBottomArray addObject:_label1Bottom];
        [self.labelBottomArray addObject:_label2Bottom];
        [self.labelBottomArray addObject:_label3Bottom];
        
        [self.button1 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.button2 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.button3 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.label1Top.textAlignment = NSTextAlignmentCenter;
        self.label2Top.textAlignment = NSTextAlignmentCenter;
        self.label3Top.textAlignment = NSTextAlignmentCenter;
        
        self.label1Bottom.textAlignment = NSTextAlignmentCenter;
        self.label2Bottom.textAlignment = NSTextAlignmentCenter;
        self.label3Bottom.textAlignment = NSTextAlignmentCenter;
       
        
        
        [self addSubview:self.button1];
        [self addSubview:self.button2];
        [self addSubview:self.button3];
        
        [self addSubview:self.label1Top];
        [self addSubview:self.label2Top];
        [self addSubview:self.label3Top];
        
        [self addSubview:self.label1Bottom];
        [self addSubview:self.label2Bottom];
        [self addSubview:self.label3Bottom];
        
        [self addSubview:self.indicateView];
        
        _label1Top.textColor = YiBlue;
        _label1Bottom.textColor = YiBlue;
    }
    return self;
}
-(void)clickButton:(UIButton *)button
{
    int clickIndex = -1;
    for (int index=0; index < [_buttonArray count]; index ++) {
        if ([_buttonArray[index] isEqual:button]) {
            clickIndex = index;
            self.labelTopArray[index].textColor = YiBlue;
            self.labelBottomArray[index].textColor = YiBlue;
        }else{
            self.labelTopArray[index].textColor = [UIColor blackColor];
            self.labelBottomArray[index].textColor = [UIColor blackColor];
        }
    }
    
    if (clickIndex == self.currentIndex) {
        return;
    }
    //在这里改变地下的滑块
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.indicateView.frame;
        frame.origin.x += (ScreenWidth/3) * (clickIndex - _currentIndex);
        self.indicateView.frame = frame;
    }];
    _currentIndex = clickIndex;
    if (_clickBlock) {
        _clickBlock(clickIndex);
    }
    
}
@end
