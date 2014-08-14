//
//  ViewController.h
//  SparkRGB
//
//  Created by Mohit Bhoite on 8/3/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBColorPicker.h"

@interface ViewController : UIViewController <VBColorPickerDelegate>

@property (nonatomic, strong) IBOutlet UIView *rect;
@property (nonatomic, strong) VBColorPicker *cPicker;

@property (nonatomic, strong) UIColor *colorWithBrightness;


@property (weak,nonatomic)IBOutlet UISwitch *sendButton;
@property (nonatomic, retain) IBOutlet UITextField *red,*green,*blue;

@property (weak, nonatomic) IBOutlet UISlider *brightness;

@property (retain, nonatomic) NSURLConnection *connection;

@property (retain, nonatomic) NSMutableData *receivedData;

@end
