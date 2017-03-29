//
//  HttpKit.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/16.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "HttpKit.h"
#import <AFNetworking.h>
@interface HttpKit()
@property AFHTTPSessionManager *manager;
@end
@implementation HttpKit
static HttpKit *kit;

+(id) sharedKit
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (kit == nil) {
            kit = [[HttpKit alloc] init];
        }
    });
    return kit;
}
-(id)init
{
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc]init];
    }
    return self;
}
-(void)doGet:(NSString *)urlString withParam:(NSDictionary *)param withSucessBlock:(sucessBlock)sucess withErroBlock:(errorBlock)errorBlock
{
    NSString *url =[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [_manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"the request is error @%@",error);
        errorBlock(error);
    }];
}
-(void)doPost:(NSString *)urlString withParam:(NSDictionary *)param withSucessBlock:(sucessBlock)sucess withErroBlock:(errorBlock)errorBlock
{
    [_manager POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}
@end
