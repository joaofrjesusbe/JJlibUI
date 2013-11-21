//
//  JTabBarController.h
//  JJlibUI
//
//  Created by Joao Jesus on 18/11/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JButtonMatrix.h"
#import "JTabBarView.h"

/**
 *  Allow's the tabBarView to be docked into one of the side's.
 */
typedef NS_ENUM(short, JTabBarDock) {
    JTabBarDockNone,
    JTabBarDockBottom,
    JTabBarDockTop,
    JTabBarDockLeft,
    JTabBarDockRight
};

#define JTabBarDockIsHorizontal(x) ( (x) == JTabBarDockBottom || (x) == JTabBarDockTop )
#define JTabBarDockIsVertical(x) ( (x) == JTabBarDockLeft || (x) == JTabBarDockRight )


@protocol JTabBarControllerSource;
@protocol JTabBarControllerDelegate;
@interface JTabBarController : UIViewController

/**
 *  The same as: initWithTabBarSize:height andDockOrientation:JTabBarDockBottom
 *
 *  @param height size of the bottom dock tabbar
 */
- (id)initWithTabBarHeight:(CGFloat)height;

/**
 *  Prefered initializer with code. Creates a fixed tabbar based on the dock property.
 *
 *  @param size         Size of the dock tabbar. If bottom or top is height, if left or right is width.
 *  @param dockPosition dockPosition
 */
- (id)initWithTabBarSize:(CGFloat)size andDockPosition:(JTabBarDock)dockPosition;

/**
 *  Initializer with a custom tabview. The controller will use the tabview given instead of generate a new one.
 *
 *  @param tabview      custom tabbar
 *  @param dockPosition dockPostion
 */
- (id)initWithTabBar:(JTabBarView *)tabBar andDockPosition:(JTabBarDock)dockPosition;

/**
 *  Initializer with a checkbox matrix that is outside the tabcontroller.
 *  Allows to create a custom tabbar.
 *
 *  @param checkBoxMatrix matix to be associated
 */
- (id)initWithButtonMatrix:(JButtonMatrix *)buttonMatrix;

/**
 *  View that defines the area where the selected child viewController will be position.
 */
@property(nonatomic,readwrite) IBOutlet UIView *viewContainer;

/**
 *  Child's UIViewController's. Will create a tabbar for each UIViewController.
 */
@property(nonatomic,copy) NSArray *childViewControllers;

@property(nonatomic,readonly) JButtonMatrix *associatedButtonMatrix;

@property(nonatomic,assign) id<JTabBarControllerDelegate> delegate;

#pragma mark - if tabBar associated 

@property(nonatomic,readwrite) IBOutlet JTabBarView *associatedTabBar;

@property(nonatomic,readonly) JTabBarDock tabBarDock;

@property(nonatomic,assign) BOOL hiddenTabBar;

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animated:(BOOL)animated;

@end


@protocol JTabBarControllerDelegate <NSObject>
@optional

- (UIButton *)tabBarController:(JTabBarController *)tabBarController tabBarButtonForIndex:(uint)index;

- (BOOL)tabBarController:(JTabBarController *)tabBarController willSelectSubViewController:(UIViewController *)subViewController forIndex:(uint)index;

- (void)tabBarController:(JTabBarController *)tabBarController didSelectSubViewController:(UIViewController *)subViewController forIndex:(uint)index;

@end
