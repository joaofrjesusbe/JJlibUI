//
//  JButtonMatrix.h
//  JJlibUI
//
//  Created by Joao Jesus on 10/20/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+JButton.h"

/**
 *  Object responsible for manage the UIButton#selected state.
 *  Also fires UIButton#blockSelectionAction and set the UIButton#selectedIndex .
 */
@protocol JButtonMatrixDelegate;
@interface JButtonMatrix : NSObject

/**
 *  Array of buttons to be managed by this object.
 *  Default: @[]
 */
@property(nonatomic,copy) NSArray *buttonsArray;

/**
 *  The UIButton that is currently selected.
 *  Setting this to nil will deselect the button.
 *  Default: nil
 */
@property(nonatomic,assign) UIButton *selectedButton;

/**
 *  The UIButton#selectedIndex that is currently selected.
 *  Setting this to NSNotFound will deselect the button.
 *  Default: NSNotFound
 */
@property(nonatomic,assign) NSInteger selectedIndex;

@end
