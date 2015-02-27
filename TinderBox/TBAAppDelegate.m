//
//  TBAAppDelegate.m
//  TinderBox
//
//  Created by Jonathan Fox on 7/30/14.
//  Copyright (c) 2014 Jon Fox. All rights reserved.
//

#import "TBAAppDelegate.h"
#import "TBAViewController.h"

@implementation TBAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    TBAViewController * vc = [[TBAViewController alloc]initWithNibName:nil bundle:nil];
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor lightGrayColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
