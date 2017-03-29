//
//  showCaseViewCellTableViewCell.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/23.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "showCaseViewCellTableViewCell.h"

@implementation ShowCaseViewCellTableViewCell
@synthesize logo,title,desc;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        logo = [[UIImageView alloc] init];
        title = [[UILabel alloc] init];
        desc = [[UILabel alloc] init];
        [self.contentView addSubview:logo];
        [self.contentView addSubview:title];
        [self.contentView addSubview:desc];
        //行数不加限制
        desc.numberOfLines = 0;
        logo.layer.cornerRadius = 20;
        logo.layer.borderColor = YiGray.CGColor;
        logo.layer.masksToBounds = YES;
        logo.layer.borderWidth = 0.3;
        logo.translatesAutoresizingMaskIntoConstraints=NO;
        title.translatesAutoresizingMaskIntoConstraints=NO;
        desc.translatesAutoresizingMaskIntoConstraints=NO;
        NSArray * constrants1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[logo(==40)]-8-[title]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logo,title)];
        NSArray *constrants2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[logo(==40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logo)];
        
        NSArray *constrants3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(title)];
        NSArray *constrants4 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-58-[desc]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(desc)];
        NSArray *constrants5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35-[desc]-(>=20)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(desc)];
        
        [self.contentView addConstraints:constrants1];
        [self.contentView addConstraints:constrants2];
        [self.contentView addConstraints:constrants3];
        [self.contentView addConstraints:constrants4];
        [self.contentView addConstraints:constrants5];
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
