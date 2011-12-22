//
//  ExampleModalPickerViewController.m
//  SCKitSample
//
//  Created by Sebastian Celis on 12/22/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import "ExampleModalPickerViewController.h"

#import "SCModalPickerView.h"

@interface SCInputDatePicker : UIDatePicker
@end

@implementation SCInputDatePicker

- (void)setFrame:(CGRect)frame
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && frame.size.width > 400.0)
    {
        frame.size.height = 162.0;
    }
    else
    {
        frame.size.height = 216.0;
    }
    
    [super setFrame:frame];
}

@end


@interface ExampleModalPickerViewController ()
- (void)updateStatusLabel;
@end

@implementation ExampleModalPickerViewController

@synthesize date = _date;
@synthesize datePicker = _datePicker;
@synthesize showPickerButton = _showPickerButton;
@synthesize statusLabel = _statusLabel;

#pragma mark - Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self allowAllInterfaceOrientations];
        [self setTitle:@"Modal Picker View"];
    }
    
    return self;
}

- (void)dealloc
{
    [_date release];
    [_datePicker release];
    [_showPickerButton release];
    [_statusLabel release];
    [super dealloc];
}

#pragma mark - Accessors

- (UIButton *)showPickerButton
{
    if (_showPickerButton == nil)
    {
        _showPickerButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [_showPickerButton setTitle:@"Show Modal Picker View" forState:UIControlStateNormal];
        [_showPickerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
        [_showPickerButton addTarget:self action:@selector(showPickerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _showPickerButton;
}

- (UILabel *)statusLabel
{
    if (_statusLabel == nil)
    {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_statusLabel setTextAlignment:UITextAlignmentCenter];
        [_statusLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_statusLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
        [self updateStatusLabel];
    }
    
    return _statusLabel;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil)
    {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    
    return _datePicker;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect;
    UIView *view = [self view];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button = [self showPickerButton];
    [button sizeToFit];
    rect = [button frame];
    rect.size.width += 20.0;
    rect.origin.x = floor(([view bounds].size.width - rect.size.width) / 2.0);
    rect.origin.y = floor([view bounds].size.height / 3.0 - rect.size.height / 2.0);
    [button setFrame:rect];
    [view addSubview:button];
    
    UILabel *label = [self statusLabel];
    [label sizeToFit];
    rect = [label frame];
    rect.size.width = [view bounds].size.width - 20.0;
    rect.origin.x = 10.0;
    rect.origin.y = floor([view bounds].size.height / 3.0 * 2.0 - rect.size.height / 2.0);
    [label setFrame:rect];
    [view addSubview:label];
}

- (void)viewDidUnload
{
    [_datePicker release];
    _datePicker = nil;
    [_showPickerButton release];
    _showPickerButton = nil;
    [_statusLabel release];
    _statusLabel = nil;
    [super viewDidUnload];
}

#pragma mark - Actions

- (void)updateStatusLabel
{
    NSString *text;
    if ([self date] == nil)
    {
        text = @"No Date Selected";
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        text = [NSString stringWithFormat:@"Date Selected: %@", [formatter stringFromDate:[self date]]];
        [formatter release];
    }
    [[self statusLabel] setText:text];
}

- (void)showPickerButtonPressed:(id)sender
{
    __block UIDatePicker *datePicker = [self datePicker];
    SCModalPickerView *modalPickerView = [[SCModalPickerView alloc] init];
    [modalPickerView setPickerView:datePicker];
    
    __block ExampleModalPickerViewController *safeSelf = self;
    [modalPickerView setCompletionHandler:^(SCModalPickerViewResult result){
        if (result == SCModalPickerViewResultDone)
        {
            [safeSelf setDate:[datePicker date]];
            [safeSelf updateStatusLabel];
        }
    }];

    [modalPickerView show];
    [modalPickerView release];
}

@end
