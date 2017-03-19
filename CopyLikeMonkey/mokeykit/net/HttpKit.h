//
//  HttpKit.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/16.
//  Copyright © 2017年 阎翼. All rights reserved.
//  自己封装的http请求工具类

//

#import <Foundation/Foundation.h>
typedef void(^sucessBlock)(id _Nonnull responseObject);
typedef void(^errorBlock)(NSError * _Nonnull error);
@interface HttpKit : NSObject
+(nonnull id) sharedKit;
-(void) doGet:(nonnull NSString *)urlString withParam:(nullable id)param withSucessBlock:(nullable sucessBlock)sucess withErroBlock:(nullable errorBlock)errorBock;
-(void) doPost:(nonnull NSString *)urlString withParam:(nullable id)param withSucessBlock:(nullable sucessBlock)sucess withErroBlock:(nullable errorBlock)errorBlock;
@end
