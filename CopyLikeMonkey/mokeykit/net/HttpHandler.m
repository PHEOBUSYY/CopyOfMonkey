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
+(NSString * )getSendGithubOauthUrl
{
    NSString *clientId = @"d6326c3ca0a8700c31fc";
    NSString *redirectUrl = @"https://github.com/PHEOBUSYY/CopyOfMonkey";
    NSString *getString = @"https://github.com/login/oauth/authorize?client_id=%@&scope=user,public_repo&state=copylikemonkey&redirect_uri=%@";
    getString = [NSString stringWithFormat:getString,clientId,redirectUrl];
    return getString;
}
+ (void)sendGithubOauth:(NSString *)code onSucess:(sucessBlock)sucess onError:(errorBlock)error
{
    NSString * getUrl = @"https://github.com/login/oauth/access_token";
    NSMutableDictionary *param = [[NSMutableDictionary alloc ]init];
    
    NSString *clientId = @"d6326c3ca0a8700c31fc";
    NSString *redirectUrl = @"https://github.com/PHEOBUSYY/CopyOfMonkey";
    NSString *clientScreat = @"ae60e186abbc3cfd65cbf10cd7fb81252c5c88d8";
    NSString *state = @"copylikemonkey";
    [param setValue:code forKey:@"code"];
    [param setValue:clientId forKey:@"client_id"];
    [param setValue:clientScreat forKey:@"client_secret"];
    [param setValue:redirectUrl forKey:@"redirect_uri"];
    [param setValue:state forKey:@"state"];
    
    [[HttpKit sharedKit]doPost:getUrl withParam:param withSucessBlock:sucess withErroBlock:error];
}
+(void) getUserInfoWithToken:(sucessBlock)sucess onError:(errorBlock)errorBlock
{
     NSString * getUrl = @"https://api.github.com/user";
    [[HttpKit sharedKit]doGetWithToken:getUrl withParam:nil withSucessBlock:^(id  _Nonnull responseObject) {
        sucess(responseObject);
    } withErroBlock:^(NSError * _Nonnull error) {
        errorBlock(error);
    }];
}
@end
