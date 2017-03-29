//
//  HttpHandler.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/21.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpKit.h"
@interface HttpHandler : NSObject

+ (void) getRepoDetailFromNet: (NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error;
+ (void) getRepoContribute: (NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error;
+ (void) getForkList: (NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error;
+ (void) getStarsList: (NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error;
+ (void) getRepoData: (NSString *)urlStr repoName:(NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error;
+ (void)getTrending: (NSString *)since withLanguage:(NSString *)language onSucess:(sucessBlock)sucess onError:(errorBlock)error;
+ (void)getShowCase: (sucessBlock)sucess onError:(errorBlock)error;
+ (void)getShowCaseDetail:(NSString *)caseName onSucess: (sucessBlock)sucess onError:(errorBlock)error;
+ (void)searchUser:(NSString *)userName withPage:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error;
+ (void)searchRepo:(NSString *)repoName withPage:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error;
@end
