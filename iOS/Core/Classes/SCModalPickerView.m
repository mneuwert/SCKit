//
//  SCModalPickerView.m
//  SCKit
//
//  Created by Sebastian Celis on 8/25/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import "SCModalPickerView.h"

@interface SCModalPickerView ()
@property (nonatomic, readwrite, retain) UIWindow *window;
@property (nonatomic, readwrite, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIButton *dimmingButton;
@property (nonatomic, assign) UIWindow *previousWindow;
- (void)hideWithResult:(SCModalPickerViewResult)result;
@end

@implementation SCModalPickerView

@synthesize completionHandler = _completionHandler;
@synthesize dimmingButton = _dimmingButton;
@synthesize pickerView = _pickerView;
@synthesize previousWindow = _previousWindow;
@synthesize toolbar = _toolbar;
@synthesize window = _window;

#pragma mark - View Lifecycle

- (id)init
{
    if ((self = [self initWithFrame:CGRectZero]))
    {
    }
    
    return self;
}

- (void)dealloc
{
    [_dimmingButton release];
    [_pickerView release];
    [_toolbar release];
    [super dealloc];
}

#pragma mark - Accessors

- (UIWindow *)window
{
    if (_window == nil)
    {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_window setWindowLevel:UIWindowLevelStatusBar + 1.0];
    }
    
    return _window;
}

- (UIButton *)dimmingButton
{
    if (_dimmingButton == nil)
    {
        _dimmingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_dimmingButton setBackgroundColor:[UIColor blackColor]];
        [_dimmingButton setAlpha:0.0];
        [_dimmingButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    
    return _dimmingButton;
}

- (UIToolbar *)toolbar
{
    if (_toolbar == nil)
    {
        // Toolbar
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height, self.bounds.size.width, 44.0)];
        [_toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [_toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        
        // Toolbar Items
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self
                                                                                    action:@selector(cancel:)];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:NULL];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(done:)];
        [_toolbar setItems:[NSArray arrayWithObjects:cancelItem, spaceItem, doneItem, nil]];
        [cancelItem release];
        [spaceItem release];
        [doneItem release];
    }
    
    return _toolbar;
}

#pragma mark - Showing and Hiding

- (void)show
{
    // Remember the previous key window
    [self setPreviousWindow:[[UIApplication sharedApplication] keyWindow]];
    
    // Retrieve the window in which we are going to display ourself
    UIWindow *window = [self window];
    [window addSubview:self];

    // Dimming Button
    UIButton *dimmingButton = [self dimmingButton];
    [dimmingButton setFrame:[window bounds]];
    [window insertSubview:dimmingButton belowSubview:self];

    // Toolbar
    UIToolbar *toolbar = [self toolbar];
    [self addSubview:toolbar];

    // Picker View
    UIPickerView *pickerView = [self pickerView];
    NSAssert(pickerView != nil, @"A UIPickerView must be set before displaying the SCModalPickerView.");
    [self addSubview:pickerView];
    
    // Set our frame and layout our subviews
    [self setFrame:CGRectMake(0.0, [window bounds].size.height, [window bounds].size.width, [pickerView bounds].size.height + [toolbar bounds].size.height)];
    [self layoutIfNeeded];

    // Make the window visible
    [window makeKeyAndVisible];

    // Perform the animation
    [UIView animateWithDuration:0.3 animations:^{
        [_dimmingButton setAlpha:0.4];
        
        CGRect rect = [self frame];
        rect.origin.y -= [self bounds].size.height;
        [self setFrame:rect];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_toolbar && _pickerView)
    {
        [_toolbar setFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, _toolbar.bounds.size.height)];
        [_pickerView setFrame:CGRectMake(0.0, CGRectGetMaxY(_toolbar.frame), self.bounds.size.width, _pickerView.bounds.size.height)];
    }
}

- (void)cancel:(id)sender
{
    [self hideWithResult:SCModalPickerViewResultCancelled];
}

- (void)done:(id)sender
{
    [self hideWithResult:SCModalPickerViewResultDone];
}

- (void)hideWithResult:(SCModalPickerViewResult)result
{
    // Execute the completion handler
    if (_completionHandler)
    {
        _completionHandler(result);
    }

    // Animate out
    [UIView animateWithDuration:0.3
                     animations:^{
                         [_dimmingButton setAlpha:0.0];

                         CGRect rect = [self frame];
                         rect.origin.y += [self bounds].size.height;
                         [self setFrame:rect];
                     }
                     completion:^(BOOL finished) {
                         [_previousWindow makeKeyAndVisible];
                         [self setWindow:nil];  // Break the retain loop and allow both self and the UIWindow to be reclaimed.
                     }];
}

@end
