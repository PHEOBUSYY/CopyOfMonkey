//
//  HttpHandler.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/21.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "HttpHandler.h"
#import "HttpKit.h"
@implementation HttpHandler
+ (void)getRepoData:(NSString *)urlStr repoName:(NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    [[HttpKit sharedKit] doGet:urlStr withParam:nil withSucessBlock:sucess withErroBlock:error];
}
+(void)getRepoDetailFromNet:(NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    
    NSString *getString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@",owner,name];
    [HttpHandler getRepoData:getString repoName:name withOwner:owner page:page onSucess:sucess onError:error];
}
+ (void)getForkList:(NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    NSString *getString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/forks",owner,name];
    [HttpHandler getRepoData:getString repoName:name withOwner:owner page:page onSucess:sucess onError:error];
}
+ (void)getStarsList:(NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    NSString *getString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/stargazers",owner,name];
    [HttpHandler getRepoData:getString repoName:name withOwner:owner page:page onSucess:sucess onError:error];
}
+ (void)getRepoContribute:(NSString *)name withOwner:(NSString *)owner page:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    NSString *getString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/contributors",owner,name];
    [HttpHandler getRepoData:getString repoName:name withOwner:owner page:page onSucess:sucess onError:error];
}
+ (void)getTrending:(NSString *)since withLanguage:(NSString *)language onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    language = [language lowercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *getString = [NSString stringWithFormat:@"http://trending.codehub-app.com/v2/trending?since=%@&language=%@",since,language];
    [[HttpKit sharedKit]doGet:getString withParam:nil withSucessBlock:sucess withErroBlock:error];
}
+ (void)getShowCase:(sucessBlock)sucess onError:(errorBlock)error
{
    NSString *getString = @"http://trending.codehub-app.com/v2/showcases";
    [[HttpKit sharedKit]doGet:getString withParam:nil withSucessBlock:sucess withErroBlock:error];
}
+ (void)getShowCaseDetail:(NSString *)caseName onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    NSString *getString = @"http://trending.codehub-app.com/v2/showcases/%@";
    getString = [NSString stringWithFormat:getString,caseName];
    [[HttpKit sharedKit]doGet:getString withParam:nil withSucessBlock:sucess withErroBlock:error];
}
+ (void)searchUser:(NSString *)userName withPage:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    NSString *getString = @"Http://api.github.com/search/users?q=%@&sort=followers&page=%d";
    getString = [NSString stringWithFormat:getString,userName,page];
     [[HttpKit sharedKit]doGet:getString withParam:nil withSucessBlock:sucess withErroBlock:error];
}
+ (void)searchRepo:(NSString *)repoName withPage:(int)page onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    NSString *getString = @"Http://api.github.com/search/repositories?q=%@&sort=stars&page=%d";
    getString = [NSString stringWithFormat:getString,repoName,page];
    [[HttpKit sharedKit]doGet:getString withParam:nil withSucessBlock:sucess withErroBlock:error];
}
@end
