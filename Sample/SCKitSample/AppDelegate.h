//
//  AppDelegate.h
//  SCKitSample
//
//  Created by Sebastian Celis on 12/22/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTableViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain, readonly) RootTableViewController *rootTableViewController;

@end
