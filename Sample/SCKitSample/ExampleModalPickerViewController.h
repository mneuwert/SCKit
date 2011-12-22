//
//  ExampleModalPickerViewController.h
//  SCKitSample
//
//  Created by Sebastian Celis on 12/22/11.
//  Copyright (c) 2011 Sebastian Celis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCViewController.h"

@interface ExampleModalPickerViewController : SCViewController

@property (nonatomic, retain, readonly) UIButton *showPickerButton;
@property (nonatomic, retain, readonly) UILabel *statusLabel;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain, readonly) UIDatePicker *datePicker;

@end
