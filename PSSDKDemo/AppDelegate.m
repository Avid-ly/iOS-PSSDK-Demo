//
//  AppDelegate.m
//  PSSDK
//
//  Created by steve on 2020/9/7.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    ViewController *con = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
