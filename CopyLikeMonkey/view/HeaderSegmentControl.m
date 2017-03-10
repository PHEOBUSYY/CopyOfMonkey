//
//  HeaderSegmentControl.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/9.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "HeaderSegmentControl.h"
@interface HeaderSegmentControl(){
    NSMutableArray<UIButton*> *buttonArray;
    UIColor *light;
    UIColor *black;
    UIFont *lightFont;
    UIFont *normalFont;
    NSInteger currentIndex;
}

@end
@implementation HeaderSegmentControl
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        black=[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1];
        buttonArray = [[NSMutableArray alloc]initWithCapacity:4];
        light = YiBlue;
        if (ScreenWidth<=320) {
            lightFont=[UIFont systemFontOfSize:12];
            
        }else{
            lightFont=[UIFont systemFontOfSize:14];
            
        }
        
        float h = 35;
        float space = 0 ;
        float width = (ScreenWidth/4) - space;
        float height = h;
        float w = space +width;
        normalFont = [UIFont systemFontOfSize:12];
        self.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        _buttonFirst = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_buttonFirst];
        _buttonFirst.frame = CGRectMake(space, (h-height)/2, width, height);
        [_buttonFirst setTitle:@"first" forState:UIControlStateNormal];
        _buttonFirst.titleLabel.font = normalFont;
        [_buttonFirst setTitleColor:black forState:UIControlStateNormal];
        [buttonArray addObject:_buttonFirst];
        [_buttonFirst addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonSecond = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_buttonSecond];
        _buttonSecond.frame = CGRectMake(w+space, (h-height)/2, width, height);
        [_buttonSecond setTitle:@"sencond" forState:UIControlStateNormal];
        _buttonSecond.titleLabel.font = normalFont;
        [_buttonSecond setTitleColor:black forState:UIControlStateNormal];
        [buttonArray addObject:_buttonSecond];
        [_buttonSecond addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonThird = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_buttonThird];
        _buttonThird.frame = CGRectMake(w*2 + space, (h-height)/2, width, height);
        [_buttonThird setTitle:@"third" forState:UIControlStateNormal];
        _buttonThird.titleLabel.font = normalFont;
        [_buttonThird setTitleColor:black forState:UIControlStateNormal];
        [buttonArray addObject:_buttonThird];
        [_buttonThird addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonFourth = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_buttonFourth];
        _buttonFourth.frame = CGRectMake(w*3 + space, (h-20)/2, width-5, 20);
        [_buttonFourth setTitle:@"fourth" forState:UIControlStateNormal];
        _buttonFourth.titleLabel.font = normalFont;
        [_buttonFourth setTitleColor:black forState:UIControlStateNormal];
        [buttonArray addObject:_buttonFourth];
        _buttonFourth.backgroundColor = YiBlue;
        [_buttonFourth addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonFirst.titleLabel.font = lightFont;
        [_buttonFirst setTitleColor:light forState:UIControlStateNormal];
        
    }
    return self;
}
-(void)actionClick:(UIButton *)button
{
    int index = 0;
    for (int i=0; i<[buttonArray count]; i++) {
        
        if([buttonArray[i] isEqual:button]){
            index = i;
            break;
        }
    }
    [self clickIndex:index];
}
-(void)clickIndex:(NSInteger)clickIndex
{
    if (clickIndex == currentIndex) {
        return;
    }
    currentIndex = clickIndex;
    UIButton *clickButton = buttonArray[clickIndex];
    clickButton.titleLabel.font = lightFont;
    [clickButton setTitleColor:light forState:UIControlStateNormal];
    for (int i=0; i<[buttonArray count]; i++) {
        if(i != clickIndex){
            UIButton *unclickButton = buttonArray[i];
            unclickButton.titleLabel.font = normalFont;
            [unclickButton setTitleColor:black forState:UIControlStateNormal];
        }
    }
    
    if (_ClickBlock) {
        _ClickBlock(clickIndex);
    }
}
@end
