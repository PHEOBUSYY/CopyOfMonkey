//
//  LoginWebViewController.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/31.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginWebViewController : UIViewController
@property (strong,nonatomic) NSString *url;
@property (copy,nonatomic) void (^loginCallback) (NSString* access_token);
@end
