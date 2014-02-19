//
//  CheckBoxValue.h
//  JJlibUI
//
//  Created by João Jesus on 19/02/14.
//  Copyright (c) 2014 Joao Jesus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxValue : UIView

+ (CheckBoxValue *)checkBoxValue;

- (void)setupCheckBoxWithHiddenValueAndText:(NSString *)text;

- (void)setupCheckBoxWithText:(NSString *)text value:(float)value;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (weak, nonatomic) IBOutlet UILabel *checkLabel;

@property (weak, nonatomic) IBOutlet UIView *containerValue;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;

@end
