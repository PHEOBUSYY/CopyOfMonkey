//
//  FirstTableViewCell.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/8.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        float h=70.5;
        float originX = 0;
        float w = ScreenWidth - originX * 2;
        float preWidth = 15;
        float rankWidth = 45;
        float sufRankWidth = 10;
        float imageViewWidth=50;
        float sufImageViewWidth=25;
        float lableWidth = w- 2*preWidth-rankWidth-sufRankWidth-imageViewWidth-sufImageViewWidth;
        self.contentView.backgroundColor = YiGray;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(originX, 0, w, h)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bgView];
        
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (h-30)/2,rankWidth+preWidth, 30)];
        
        self.avatar=[[UIImageView alloc] initWithFrame:CGRectMake(preWidth+rankWidth+sufRankWidth, (h-imageViewWidth)/2, imageViewWidth, imageViewWidth)];
        
        self.title=[[UILabel alloc] initWithFrame:CGRectMake((preWidth+rankWidth+sufRankWidth+imageViewWidth+sufImageViewWidth), (h-imageViewWidth)/2, lableWidth, imageViewWidth)];
        
        self.detail=[[UILabel alloc] initWithFrame:CGRectMake((preWidth+rankWidth+sufRankWidth+imageViewWidth+sufImageViewWidth), (h-imageViewWidth)/2 + imageViewWidth/2, lableWidth, imageViewWidth/2)];
        
        [bgView addSubview:self.rankLabel];
        [bgView addSubview:self.avatar];
        [bgView addSubview:self.title];
        [bgView addSubview:self.detail];
        
        self.title.numberOfLines=0;
        self.rankLabel.textColor=YiBlue;
        self.title.textColor=YiBlue;
        self.detail.textColor=YiGray;
        
        self.rankLabel.textAlignment=NSTextAlignmentCenter;
        self.title.font=[UIFont systemFontOfSize:18];
        self.detail.font=[UIFont systemFontOfSize:13];
        self.title.textAlignment=NSTextAlignmentLeft;
        self.detail.textAlignment=NSTextAlignmentLeft;
        
        self.avatar.layer.cornerRadius=10;
        self.avatar.layer.borderColor=YiGray.CGColor;
        self.avatar.layer.borderWidth=0.3;
        self.avatar.layer.masksToBounds=YES;
        
        
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
