//
//  RepoTableViewCell.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/15.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "RepoTableViewCell.h"

@implementation RepoTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float space = 15;
        float topSpace = 5;
        float labelHeight = 20;
        float imageWidth = 35;
        float lableWidth = 110;
        self.rankLanbel = [[UILabel alloc]initWithFrame:CGRectMake(space, topSpace, imageWidth, labelHeight)];
        
        self.loginLable = [[UILabel alloc]initWithFrame:CGRectMake(space+imageWidth+space, topSpace, lableWidth+50, labelHeight)];
        self.startLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - lableWidth-space, topSpace, lableWidth, labelHeight)];
        self.avarta = [[UIImageView alloc] initWithFrame:CGRectMake(space, topSpace+imageWidth, imageWidth, imageWidth)];
        
        self.ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(space + imageWidth + space,topSpace +  labelHeight+topSpace, lableWidth, labelHeight)];
        
        float startNetLabelLeft = space + imageWidth + space + lableWidth + space;
        self.netLebal = [[UILabel alloc]initWithFrame:CGRectMake(startNetLabelLeft, topSpace + labelHeight+topSpace, ScreenWidth - startNetLabelLeft - space, labelHeight)];
        self.desLabel = [[UILabel alloc]initWithFrame:CGRectMake(space +imageWidth+space,topSpace+ labelHeight+topSpace+topSpace+labelHeight, ScreenWidth - space*3 -imageWidth, labelHeight*2)];
        
        float h = topSpace + labelHeight+topSpace + labelHeight + topSpace +labelHeight*2 + topSpace;
        float w = ScreenWidth;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
        [self.contentView addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        
        [bgView addSubview:_rankLanbel];
        [bgView addSubview:_startLabel];
        [bgView addSubview:_loginLable];
        [bgView addSubview:_avarta];
        [bgView addSubview:_ownerLabel];
        [bgView addSubview:_netLebal];
        [bgView addSubview:_desLabel];
        
        self.avarta.layer.cornerRadius = 10;
        self.avarta.layer.borderColor = YiGray.CGColor;
        self.avarta.layer.borderWidth=0.3;
        self.avarta.layer.masksToBounds=YES;
        
        self.rankLanbel.textAlignment = NSTextAlignmentCenter;
        self.rankLanbel.textColor = YiBlue;
        self.loginLable.textColor = YiBlue;
        self.startLabel.textColor = YiGray;
        self.ownerLabel.textColor = YiGray;
        self.netLebal.textColor = YiBlue;
        self.loginLable.font = [UIFont systemFontOfSize:16];
        self.startLabel.font = [UIFont systemFontOfSize:13];
        self.ownerLabel.font = [UIFont systemFontOfSize:13];
        self.netLebal.font = [UIFont systemFontOfSize:13];
        self.desLabel.textColor = [UIColor blackColor];
        
        self.desLabel.font = [UIFont systemFontOfSize:15];
        self.desLabel.numberOfLines = 2;
        
        
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
