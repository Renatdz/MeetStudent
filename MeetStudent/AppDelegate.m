//
//  AppDelegate.m
//  MeetStudent
//
//  Created by Renato Mendes on 23/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // conexao do banco
    //https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"tujAI1LqcE6klqjHyQOI9zB9whgkEn8Vq7JnkCXr"
                  clientKey:@"4mODPFqVOKfqGLdIauIbWKP86XjENjZW8N9kpel7"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"InitView"];
    [self.window setRootViewController:controller];//set view controller
    
    if([self isLogin]){
        UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"NavigationInit"];
        [self.window setRootViewController:controller];//set view controller
    }
    
    return YES;
}

//|-------------------------------------------------
// Usuário logado?
-(bool)isLogin
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if([user objectForKey:@"nome"] == nil)
        return false;
    else
        return true;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
