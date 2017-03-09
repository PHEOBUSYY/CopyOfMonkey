//
//  AppDelegate.m
//  CopyLikeMonkey
//
//  Created by 阎翼 on 2017/3/7.
//  Copyright © 2017年 阎翼. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initController];
    return YES;
}
- (void)initController{
    UITabBarController *tabarController = [[UITabBarController alloc] init];
    FirstTableViewController * tab1 = [[FirstTableViewController alloc] init];
    UIViewController * tab2 = [[UIViewController alloc] init];
    UIViewController * tab3 = [[UIViewController alloc] init];
    tab1.view.backgroundColor = [UIColor whiteColor];
    tab2.view.backgroundColor = [UIColor whiteColor];
    tab3.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *nv1 = [[UINavigationController alloc] initWithRootViewController:tab1];
    UINavigationController *nv2 = [[UINavigationController alloc] initWithRootViewController:tab2];
    UINavigationController *nv3 = [[UINavigationController alloc] initWithRootViewController:tab3];
    
    nv1.navigationBar.tintColor = [UIColor whiteColor];
    nv1.navigationBar.barTintColor = YiBlue;
    nv1.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [tab1 setTitle:@"item1"];
    
    nv1.navigationBar.barStyle = UIStatusBarStyleLightContent;

    nv2.navigationBar.tintColor = [UIColor whiteColor];
    nv2.navigationBar.barTintColor = YiBlue;
    nv2.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    //设置状态栏的字体颜色
    nv2.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [tab2 setTitle:@"item2"];
    
    
    nv3.navigationBar.tintColor = [UIColor whiteColor];
    nv3.navigationBar.barTintColor = YiBlue;
    nv3.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    //设置状态栏的字体颜色
    nv3.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [tab3 setTitle:@"item3"];
    
    
    tabarController.viewControllers = @[nv1,nv2,nv3];
    
    UITabBarItem *item1 = [tabarController.tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabarController.tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabarController.tabBar.items objectAtIndex:2];
    
    tabarController.tabBar.backgroundColor = [UIColor whiteColor];
    tabarController.tabBar.tintColor = YiBlue;
    item1.title = @"item1";
    item2.title = @"item2";
    item3.title = @"item3";
    
    item1.image = [UIImage imageNamed:@"github60"];
    item2.image = [UIImage imageNamed:@"github160"];
    item3.image = [UIImage imageNamed:@"more"];
    
    self.window.rootViewController = tabarController;
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CopyLikeMonkey"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
