//
//  ATAppDelegate.m
//  ATReadingBookSDK
//
//  Created by Spaino on 11/22/2018.
//  Copyright (c) 2018 Spaino. All rights reserved.
//

#import "ATAppDelegate.h"
#import <ABCtimeReadingBookSDK/ABCtimeReadingBookSDK.h>
#import <FLEX/FLEX.h>

@implementation ATAppDelegate
- (void)showFlex {
    //    [[FLEXManager sharedManager] showExplorer];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 注册ABCtimeReadingBookSDK
    [ATReadingBookManager registAppID:@"sdk761251283344" appSecret:@"a63623e86db5c31699cef42c36d729d3"];
    
    // 设定服务器类型;
    [ATReadingBookManager setServerType:EATServerTypeProduction];
    
    [[FLEXManager sharedManager] setNetworkDebuggingEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFlex)];
    gesture.numberOfTapsRequired = 3;
//    [self test];
    [self.window addGestureRecognizer:gesture];
    return YES;
}

- (void)test {
    NSBundle *bundle = [self at_resourceBundleWithClass:self.class bundleName:@"ATReadingBookLottieJSONs"];
    NSLog(@"%@++++++++++", bundle);
    NSString *jsonPath = [bundle pathForResource:@"data" ofType:@"json" inDirectory:@"eval_result/enter"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSLog(@"%@++++++++++", jsonPath);
    NSError *error = nil;
    NSDictionary *JSONObject = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    if (error || !JSONObject) {
        NSLog(@"json data error: %@, jsonPath : %@", error, jsonPath);
    }else{
        NSLog(@"%@================================", jsonPath);
    }
}


- (NSBundle *)at_resourceBundleWithClass:(Class) bundleClass
                              bundleName:(NSString *) bundleName {
    NSBundle *libraryBundle = [NSBundle bundleForClass:bundleClass];
    //    NSString *path = [libraryBundle pathForResource:bundleName ofType:@"bundle"];
    
    NSString *sourcePath = [libraryBundle pathForResource:@"ATReadingBookSDK" ofType:@"bundle"];
    NSBundle *sdkBundle = [NSBundle bundleWithPath:sourcePath];
    NSString *path = [sdkBundle pathForResource:bundleName ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

@end
