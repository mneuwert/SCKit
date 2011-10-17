//
//  SCModalPickerView.h
//  SCKit
//
//  Created by Sebastian Celis on 8/25/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SCModalPickerViewResultCancelled,
    SCModalPickerViewResultDone
} SCModalPickerViewResult;

typedef void (^SCModalPickerViewCompletionHandler)(SCModalPickerViewResult result);

// A class to handle the display of a modal UIPickerView or UIDatePicker. This code does not
// currently support device rotations, however that should be fairly easy to add by putting all
// of the views into a UIViewController and then displaying that UIViewController as the new
// window's root view controller.
@interface SCModalPickerView : UIView
{
}

// The UIPickerView to display to the user. This must be set before the caller attempts to show
// the SCModalPickerView. This should be a UIPickerView or a UIDatePicker.
@property (nonatomic, retain) UIView *pickerView;

// The window in which the UIPickerView and UIToolbar will be displayed.
@property (nonatomic, readonly, retain) UIWindow *window;

// This toolbar is displayed above the UIPickerView. It contains three UIToolbarItems:
// 1) A cancel button.
// 2) Flexible space.
// 3) A done button.
// You may reorder these buttons or add your own before calling show on the SCModalPickerView.
@property (nonatomic, readonly, retain) UIToolbar *toolbar;

// A block to execute upon dismissing the SCModalPickerView.
@property (nonatomic, copy) SCModalPickerViewCompletionHandler completionHandler;

// Display the SCModalPickerView. Once it has been displayed it will be retained as an active,
// visible window and the creator may safely release it.
- (void)show;

@end
