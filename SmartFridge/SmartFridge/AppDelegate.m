//
//  AppDelegate.m
//  SmartFridge
//
//  Created by Rony Besprozvanny on 2018-01-15.
//  Copyright © 2018 Rony Besprozvanny. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize userNameStr, resultDict, shelfDict, withinShelfDict, lastUpdateStr, fridgeImgStr, capValStr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Remember the last update if there was one
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // TODO: Replace with real
    self.userNameStr = @"iosAcct";
    self.resultDict = [[defaults objectForKey:@"resultDict"] mutableCopy];
    self.lastUpdateStr = [defaults objectForKey:@"lastUpdateStr"];
    self.fridgeImgStr = [defaults objectForKey:@"fridgeImgStr"];
    self.shelfDict = [[defaults objectForKey:@"shelfDict"] mutableCopy];
    self.withinShelfDict = [[defaults objectForKey:@"withinShelfDict"] mutableCopy];
    self.capValStr = [defaults objectForKey:@"capValStr"];
    
    // Load it into app
    NSString *userNameStrLcl = self.userNameStr;
    NSDictionary *resultDictLcl = self.resultDict;
    NSString *lastUpdateStrLcl = self.lastUpdateStr;
    NSString *fridgeImgStrLcl = self.fridgeImgStr;
    NSDictionary *shelfDictLcl = self.shelfDict;
    NSDictionary *withinShelfDictLcl = self.withinShelfDict;
    NSString *capValStrLcl = self.capValStr;
    
    [defaults setObject:userNameStrLcl forKey:@"userNameStr"];
    [defaults setObject:resultDictLcl forKey:@"resultDict"];
    [defaults setObject:lastUpdateStrLcl forKey:@"lastUpdateStr"];
    [defaults setObject:fridgeImgStrLcl forKey:@"fridgeImgStr"];
    [defaults setObject:shelfDictLcl forKey:@"shelfDict"];
    [defaults setObject:withinShelfDictLcl forKey:@"withinShelfDict"];
    [defaults setObject:capValStrLcl forKey:@"capValStr"];

    [defaults synchronize];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Saving
    // TODO: Replace with real
    NSString *userNameStrLcl = self.userNameStr;
    NSDictionary *resultDictLcl = self.resultDict;
    NSString *lastUpdateStrLcl = self.lastUpdateStr;
    NSString *fridgeImgStrLcl = self.fridgeImgStr;
    NSDictionary *shelfDictLcl = self.shelfDict;
    NSDictionary *withinShelfDictLcl = self.withinShelfDict;
    NSString *capValStrLcl = self.capValStr;

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userNameStrLcl forKey:@"userNameStr"];
    [defaults setObject:resultDictLcl forKey:@"resultDict"];
    [defaults setObject:lastUpdateStrLcl forKey:@"lastUpdateStr"];
    [defaults setObject:fridgeImgStrLcl forKey:@"fridgeImgStr"];
    [defaults setObject:shelfDictLcl forKey:@"shelfDict"];
    [defaults setObject:withinShelfDictLcl forKey:@"withinShelfDict"];
    [defaults setObject:capValStrLcl forKey:@"capValStr"];

    
    [defaults synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Saving
    // TODO: Replace with real
    NSString *userNameStrLcl = self.userNameStr;
    NSDictionary *resultDictLcl = self.resultDict;
    NSString *lastUpdateStrLcl = self.lastUpdateStr;
    NSString *fridgeImgStrLcl = self.fridgeImgStr;
    NSDictionary *shelfDictLcl = self.shelfDict;
    NSDictionary *withinShelfDictLcl = self.withinShelfDict;
    NSString *capValStrLcl = self.capValStr;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userNameStrLcl forKey:@"userNameStr"];
    [defaults setObject:resultDictLcl forKey:@"resultDict"];
    [defaults setObject:lastUpdateStrLcl forKey:@"lastUpdateStr"];
    [defaults setObject:fridgeImgStrLcl forKey:@"fridgeImgStr"];
    [defaults setObject:shelfDictLcl forKey:@"shelfDict"];
    [defaults setObject:withinShelfDictLcl forKey:@"withinShelfDict"];
    [defaults setObject:capValStrLcl forKey:@"capValStr"];

    [defaults synchronize];
}


@end
