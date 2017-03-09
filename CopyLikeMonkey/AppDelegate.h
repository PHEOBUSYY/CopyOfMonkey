//
//  AppDelegate.h
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/7.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

