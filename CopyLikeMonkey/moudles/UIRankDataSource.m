//
//  UIRankDataSource.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/10.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "UIRankDataSource.h"
#import "FirstTableViewCell.h"
#import "UserModel.h"
@implementation UIRankDataSource

-(id)init{
    self = [super init];
    if (self) {
        _dataArray1 = [[NSMutableArray alloc]init];
        _dataArray2 = [[NSMutableArray alloc]init];
        _dataArray3 = [[NSMutableArray alloc]init];
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_clickIndex) {
        case 0:
            return [_dataArray1 count];
        case 1:
            return [_dataArray2 count];
        case 2:
            return [_dataArray3 count];
        default:
            return 0;
    }
}
-(NSMutableArray *)getDataArrayWithIndex:(NSInteger) clickIndex
{
    switch (_clickIndex) {
        case 0:
            return _dataArray1;
        case 1:
            return _dataArray2;
        case 2:
            return _dataArray3;
        default:
            return nil;
    }
}
-(NSString *) getCellIndetifier:(NSInteger) clickIndex
{
    switch (_clickIndex) {
        case 0:
            return @"cell";
        case 1:
            return @"cell2";
        case 2:
            return @"cell3";
        default:
            return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self getCellIndetifier:_clickIndex]];
    if(cell == nil){
        cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIndetifier:_clickIndex]];
    }
    UserModel *model = [UserModel modelWithDict:[[self getDataArrayWithIndex:_clickIndex] objectAtIndex:indexPath.row]];
    NSString *avatar = model.avatar_url;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:avatar]];
    cell.title.text = [NSString stringWithFormat:@"%@",model.login];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    return cell;
}

@end
