//
//  RootTableViewController.m
//  SCKitSample
//
//  Created by Sebastian Celis on 12/22/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import "RootTableViewController.h"

#import "ExampleModalPickerViewController.h"

typedef enum {
    RootTableViewCellTagModalPickerView
} RootTableViewCellTag;
#define kNumRootTableViewCells (RootTableViewCellTagModalPickerView + 1)

@implementation RootTableViewController

#pragma mark - Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setTitle:@"Examples"];
    }
    
    return self;
}

#pragma mark - UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumRootTableViewCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell autorelease];
    }
    
    switch ([indexPath row])
    {
        case RootTableViewCellTagModalPickerView:
            [[cell textLabel] setText:@"Modal Picker View"];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    
    switch ([indexPath row])
    {
        case RootTableViewCellTagModalPickerView:
            vc = [[ExampleModalPickerViewController alloc] initWithNibName:nil bundle:nil];
            break;
        default:
            break;
    }
    
    if (vc != nil)
    {
        [[self navigationController] pushViewController:vc animated:YES];
        [vc release];
    }
}

@end
