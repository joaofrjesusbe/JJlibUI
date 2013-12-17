//
//  JTabBarView.h
//  JJlibUI
//
//  Created by Joao Jesus on 10/21/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBarView.h"
#import "UIButton+JButton.h"
#import "JButtonMatrix.h"

/**
 *  A tabbar build over the JBarView.
 *  Will use the JBarView#childViews of type UIButton's as tabbar items.
 */
@interface JTabBarView : JBarView

/**
 *  The UIButton representing as a tabbar item that is selected
 *  Setting this to nil will deselect the button.
 *  Default: nil
 */
@property(nonatomic,weak) UIButton *selectedTabBar;

/**
 *  The UIButton representing as a tabbar item that is selected
 *  Setting this to nil will deselect the button.
 *
 *  @param selectedTabBar UIButton to be selected
 *  @param animated       is animating
 */
- (void)setSelectedTabBar:(UIButton *)selectedTabBar animated:(BOOL)animated;

/**
 *  The UIButton#selectedIndex that is currently selected.
 *  Setting this to NSNotFound will deselect the button.
 *  Default: NSNotFound
 */
@property(nonatomic,assign) NSInteger selectedIndex;

/**
 *  The UIButton#selectedIndex that is currently selected.
 *  Setting this to NSNotFound will deselect the button.
 *
 *  @param selectedIndex index of the UIButton to be selected
 *  @param animated      is animating
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/**
 *  @warning different behaviour from v0.1
 *
 *  If YES the tabbar will become scrollable and when a tabbar item is selected will be centered, except on the borders.
 *  Default: NO
 */
@property(nonatomic,assign) BOOL centerTabBarOnSelect;

/**
 *  The same behaviour then centerTabBarOnSelect except that it will grow the scrollbar to able to always center items.
 *  Default: NO
 */
@property(nonatomic,assign) BOOL alwaysCenterTabBarOnSelect;

@property(nonatomic,readonly) JButtonMatrix *associatedButtonMatrix;

@end
