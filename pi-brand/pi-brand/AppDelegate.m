//
//  AppDelegate.m
//  HARMAY_PI_BRAND
//
//  Created by Madodg on 2017/7/25.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MenuViewController.h"
#import "BaseNavigationController.h"
#import "RESideMenu.h"
#import "NewFeatureVIew.h"

#import <UMSocialCore/UMSocialCore.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self umengTrack];
    // Override point for customization after application launch.
    [self newFeature];
    return YES;
}

-(void)newFeature{
    MenuViewController *leftMenuViewController = [[MenuViewController alloc] init];
    MainViewController* manVC = [[MainViewController alloc]init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:[[BaseNavigationController alloc]initWithRootViewController:manVC]
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
//    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
//    sideMenuViewController.menuPreferredStatusBarStyle = 1;
//    sideMenuViewController.contentViewInPortraitOffsetCenterX = 50;
//    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
//    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
//    sideMenuViewController.contentViewShadowOpacity = 0.6;
//    sideMenuViewController.contentViewShadowRadius = 12;
//    sideMenuViewController.contentViewShadowEnabled = YES;
//    sideMenuViewController.animationDuration = 0.2;
    if (showNewFeature) {
        NewFeatureVIew * newFeature = [[NewFeatureVIew alloc]init];
        newFeature.sideMenuViewController = sideMenuViewController;
        self.window.rootViewController = newFeature;
    }else{
        self.window.rootViewController = sideMenuViewController;
    }

}
- (void)umengTrack {

    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppId appSecret:WXAppSecret redirectURL:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
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
}


@end
