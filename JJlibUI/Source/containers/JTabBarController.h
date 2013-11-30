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
@property(nonatomic,strong) IBOutlet UIView *viewContainer;

/**
 *  Child's UIViewController's. Will create a tabbar for each UIViewController.
 */
@property(nonatomic,copy) NSArray *childViewControllers;

- (void)setChildViewControllers:(NSArray *)childViewControllers animatedOptions:(UIViewAnimationOptions)animatedOptions completion:(void (^)(void))completion;

@property(nonatomic,assign) UIViewController *selectedChildViewController;

@property(nonatomic) uint selectedIndex;

@property(nonatomic,strong) JButtonMatrix *associatedButtonMatrix;

@property(nonatomic,assign) id<JTabBarControllerDelegate> delegate;

#pragma mark - if tabBar associated 

@property(nonatomic,strong) IBOutlet JTabBarView *associatedTabBar;

@property(nonatomic,assign) JTabBarDock tabBarDock;

@property(nonatomic,assign) BOOL hiddenTabBar;

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animatedOptions:(UIViewAnimationOptions)animatedOptions completion:(void (^)(void))completion;

@end


@protocol JTabBarControllerDelegate <NSObject>
@optional

- (UIButton *)tabBarController:(JTabBarController *)tabBarController tabBarButtonForChildViewController:(UIViewController *)childViewController forIndex:(uint)index;

- (BOOL)tabBarController:(JTabBarController *)tabBarController willSelectChildViewController:(UIViewController *)childViewController forIndex:(uint)index;

- (void)tabBarController:(JTabBarController *)tabBarController didSelectChildViewController:(UIViewController *)childViewController forIndex:(uint)index;

@end


@interface  UIViewController (JTabBarController)

@property (nonatomic, strong) IBOutlet UIButton *jTabBarButton;

@property (nonatomic, weak) JTabBarController *jTabBarController;

@end
