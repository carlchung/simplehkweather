//
//  swAppDelegate.m
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

#import "swAppDelegate.h"

@implementation swAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
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

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
        restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler
{
    // Handle Hand off activity from Apple Watch
    NSLog(@"type %@ title %@" , userActivity.activityType, userActivity.title);
    
    if ( [userActivity.activityType isEqualToString:@"com.metacreate.simplehkweather.airindex"] ){
        UITabBarController *tabController = (UITabBarController*) self.window.rootViewController;
        [tabController setSelectedIndex:3];
    } else if ( [userActivity.activityType isEqualToString:@"com.metacreate.simplehkweather.9day"] ){
        UITabBarController *tabController = (UITabBarController*) self.window.rootViewController;
        [tabController setSelectedIndex:1];
    } else if ( [userActivity.activityType isEqualToString:@"com.metacreate.simplehkweather.mainpage"] ){
        UITabBarController *tabController = (UITabBarController*) self.window.rootViewController;
        [tabController setSelectedIndex:0];
    }
    return YES;
}

- (NSString*) customFontName
{
    NSString * preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    //NSLog(@"language %@",preferredLang);
    //NSArray *arrayFonts = [UIFont fontNamesForFamilyName:@"Bodoni 72" ];
    //NSLog(@"arrayFonts %@", arrayFonts);
    NSString *fontName;
    if ( [preferredLang isEqualToString:@"zh-Hant"]) {
        fontName = @"HiraMinProN-W6";
    } else {
        fontName = @"BodoniSvtyTwoITCTT-Book";
    }
    
    return fontName;
}

@end
