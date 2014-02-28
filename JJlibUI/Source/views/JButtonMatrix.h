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
@property(nonatomic,copy) IBOutletCollection(UIButton) NSArray *buttonsArray;

/**
 *  The UIButton that is currently selected.
 *  Setting this to nil will deselect the button.
 *  Default: nil
 */
@property(nonatomic,weak) UIButton *selectedButton;

/**
 *  The UIButton#selectedIndex that is currently selected.
 *  Setting this to NSNotFound will deselect the button.
 *  Default: NSNotFound
 */
@property(nonatomic,assign) NSInteger selectedIndex;

@property(nonatomic,assign) id<JButtonMatrixDelegate> delegate;

@property(nonatomic,assign) BOOL allowNoSelection;

@property(nonatomic,assign) BOOL allowMultipleSelection;

@property(nonatomic,copy,readonly) NSArray *selectedButtons;


@end


@protocol JButtonMatrixDelegate <NSObject>
@optional

- (BOOL)buttonMatrix:(JButtonMatrix *)buttonMatrix willSelectButton:(UIButton *)button forIndex:(NSInteger)index;

- (void)buttonMatrix:(JButtonMatrix *)buttonMatrix didSelectButton:(UIButton *)button forIndex:(NSInteger)index;

@end

