//
//  TestObject.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/8.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObject : NSObject
@property (assign,nonatomic) int total_count;
@property (assign,nonatomic) BOOL incomplete_results;
@property (strong,nonatomic) NSMutableArray  *items;

@end
