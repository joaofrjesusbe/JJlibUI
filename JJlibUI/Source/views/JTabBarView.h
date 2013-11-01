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
@property(nonatomic,assign) UIButton *selectedTabBar;

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
 *  If YES the tabbar will become scrollable and when a tabbar item is selected will be centered.
 *  Default: NO
 */
@property(nonatomic,assign) BOOL centerTabBarOnSelect;

@end
