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

/**
 *  Different animations to be applied on the JTabBarController
 */
typedef NS_ENUM(short, JTabBarAnimation) {
    JTabBarAnimationNone,
    JTabBarAnimationCrossDissolve,
    JTabBarAnimationSlide,
};

#define JTabBarDockIsHorizontal(x) ( (x) == JTabBarDockBottom || (x) == JTabBarDockTop )
#define JTabBarDockIsVertical(x) ( (x) == JTabBarDockLeft || (x) == JTabBarDockRight )


const static NSString *JTabBarControllerSegue = @"JTabBarControllerSegue";


@protocol JTabBarControllerDelegate;
@interface JTabBarController : UIViewController

/**
 *  The same as: initWithTabBarSize:height andDockOrientation:JTabBarDockBottom
 *
 *  @param height size of the bottom dock tabbar
 */
- (id)initWithTabBarSize:(CGSize)size;

/**
 *  Prefered initializer with code. Creates a fixed tabbar based on the dock property.
 *
 *  @param size         Size of the dock tabbar. If bottom or top is height, if left or right is width.
 *  @param dockPosition dockPosition
 */
- (id)initWithTabBarSize:(CGSize)size andDockPosition:(JTabBarDock)dockPosition;

/**
 *  Initializer with a custom tabview. The controller will use the tabview given instead of generate a new one.
 *
 *  @param tabview      custom tabbar
 *  @param dockPosition dockPostion
 */
- (id)initWithTabBar:(JTabBarView *)tabBar andDockPosition:(JTabBarDock)dockPosition;


/**
 *  View that defines the area where the selected child viewController will be position.
 */
@property(nonatomic,strong) IBOutlet UIView *viewContainer;

/**
 *  Child's UIViewController's. Will create a tabbar for each UIViewController.
 */
@property(nonatomic,copy) IBOutletCollection(UIViewController) NSArray *childViewControllers;

@property(nonatomic,strong) UIViewController *selectedChildViewController;

@property(nonatomic,assign) NSInteger selectedIndex;

@property(nonatomic,assign) id<JTabBarControllerDelegate> delegate;


#pragma mark - TabBar

@property(nonatomic,strong) IBOutlet JTabBarView *tabBar;

@property(nonatomic,assign) JTabBarDock tabBarDock;

@property(nonatomic,assign) BOOL hiddenTabBar;


#pragma mark - Animations

@property(nonatomic,assign) JTabBarAnimation defaultSelectedControllerAnimation;

- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(JTabBarAnimation)animation completion:(void (^)(void))completion;

- (void)setSelectedChildViewController:(UIViewController *)selectedChildViewController animation:(JTabBarAnimation)animation completion:(void (^)(void))completion;

- (void)setChildViewControllers:(NSArray *)childViewControllers animation:(JTabBarAnimation)animation completion:(void (^)(void))completion;

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animation:(JTabBarAnimation)animation completion:(void (^)(void))completion;

@end


@protocol JTabBarControllerDelegate <NSObject>
@optional

- (UIButton *)tabBarController:(JTabBarController *)tabBarController tabBarButtonForChildViewController:(UIViewController *)childViewController forIndex:(NSInteger)index;

- (BOOL)tabBarController:(JTabBarController *)tabBarController willSelectChildViewController:(UIViewController *)childViewController forIndex:(NSInteger)index;

- (void)tabBarController:(JTabBarController *)tabBarController didSelectChildViewController:(UIViewController *)childViewController forIndex:(NSInteger)index;

@end


@interface  UIViewController (JTabBarController)

@property (nonatomic, strong) IBOutlet UIButton *jTabBarButton;

@property (nonatomic, weak) JTabBarController *jTabBarController;

@end
