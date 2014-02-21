//
//  CheckBoxValue.m
//  JJlibUI
//
//  Created by João Jesus on 19/02/14.
//  Copyright (c) 2014 Joao Jesus. All rights reserved.
//

#import "CheckBoxValue.h"

@interface CheckBoxValue ()

@end


@implementation CheckBoxValue

+ (CheckBoxValue *)checkBoxValue {
    
    CheckBoxValue *checkBox = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    return checkBox;
}


- (void)setupCheckBoxWithHiddenValueAndText:(NSString *)text {
    self.containerValue.hidden = YES;
    CGRect frame = self.checkLabel.frame;
    frame.size.width += 80;
    self.checkLabel.frame = frame;
    self.checkLabel.text = text;
}

- (void)setupCheckBoxWithText:(NSString *)text value:(float)value {
    
    self.containerValue.hidden = NO;
    self.checkLabel.text = text;

    self.labelValue.text = [NSString stringWithFormat:@"%.1f", value];

}

@end
