//
//  SCModalPickerView.m
//  SCKit
//
//  Created by Sebastian Celis on 8/25/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import "SCModalPickerView.h"

@interface SCModalPickerView ()
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

#pragma mark - View Lifecycle

- (id)init
{
    if ((self = [self initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setWindowLevel:UIWindowLevelStatusBar + 1.0];
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

- (UIButton *)dimmingButton
{
    if (_dimmingButton == nil)
    {
        _dimmingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_dimmingButton setBackgroundColor:[UIColor blackColor]];
        [_dimmingButton setAlpha:0.0];
        [_dimmingButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_dimmingButton setFrame:[self bounds]];
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
    // Add ourself to the thread dictionary to ensure we are retained by something. This allows
    // the caller to release us after displaying us. Otherwise, the system thinks that it should
    // dealloc the window even though it is made key and visible.
    [[[NSThread currentThread] threadDictionary] setObject:self forKey:@"SCModalPickerView"];

    // Remember the previous key window
    [self setPreviousWindow:[[UIApplication sharedApplication] keyWindow]];

    // Dimming Button
    UIButton *dimmingButton = [self dimmingButton];
    [self addSubview:dimmingButton];

    // Toolbar
    UIToolbar *toolbar = [self toolbar];
    [self addSubview:toolbar];

    // Picker View
    UIPickerView *pickerView = [self pickerView];
    NSAssert(pickerView != nil, @"A UIPickerView must be set before displaying the SCModalPickerView.");
    [pickerView setFrame:CGRectMake(0.0, CGRectGetMaxY(toolbar.frame), self.bounds.size.width, pickerView.bounds.size.height)];
    [self addSubview:pickerView];

    // Make the window visible
    [self makeKeyAndVisible];

    // Perform the animation
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat yOffset = CGRectGetMaxY(pickerView.frame) - self.bounds.size.height;
        [_dimmingButton setAlpha:0.4];
        
        CGRect rect = [_pickerView frame];
        rect.origin.y -= yOffset;
        [_pickerView setFrame:rect];
        
        rect = [_toolbar frame];
        rect.origin.y -= yOffset;
        [_toolbar setFrame:rect];
    }];
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
    __block NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGFloat yOffset = _pickerView.bounds.size.height + _toolbar.bounds.size.height;
                         [_dimmingButton setAlpha:0.0];

                         CGRect rect = [_pickerView frame];
                         rect.origin.y += yOffset;
                         [_pickerView setFrame:rect];
                         
                         rect = [_toolbar frame];
                         rect.origin.y += yOffset;
                         [_toolbar setFrame:rect];
                     }
                     completion:^(BOOL finished) {
                         [_previousWindow makeKeyAndVisible];
                         [threadDict removeObjectForKey:@"SCModalPickerView"];
                     }];
}

@end
