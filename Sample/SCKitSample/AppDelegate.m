//
//  AppDelegate.m
//  SCKitSample
//
//  Created by Sebastian Celis on 12/22/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize navigationController = _navigationController;
@synthesize rootTableViewController = _rootTableViewController;
@synthesize window = _window;

#pragma mark - Delegate Lifecycle

- (void)dealloc
{
    [_navigationController release];
    [_rootTableViewController release];
    [_window release];
    [super dealloc];
}

#pragma mark - Accessors

- (UIWindow *)window
{
    if (_window == nil)
    {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_window setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _window;
}

- (UINavigationController *)navigationController
{
    if (_navigationController == nil)
    {
        _navigationController = [[UINavigationController alloc] initWithRootViewController:[self rootTableViewController]];
    }
    
    return _navigationController;
}

- (RootTableViewController *)rootTableViewController
{
    if (_rootTableViewController == nil)
    {
        _rootTableViewController = [[RootTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    
    return _rootTableViewController;
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[self window] setRootViewController:[self navigationController]];
    [[self window] makeKeyAndVisible];
    return YES;
}

@end
