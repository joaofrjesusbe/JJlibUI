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

/**
 *  Segue to be used on UIStoryboard's to link the UIButton to the UIViewController child.
 */
static const NSString *JTabBarSegueIndex = @"JIndex";


@protocol JTabBarControllerDelegate;
/**
 *  @brief Implementation of the JTabBarView as a TabBar View Controller.
 *
 *  Creates a tabbar or use a specific one to manage wich child UIViewController should be presented.
 *  A tabbar can be dock to the specific side.
 *
 *  To use this controller through the code or a xib file, you must pass the child view controllers throw the tabbarChilds property.
 *  
 *  For the storyboard, you create a UIStoryboardSegue with the identifier "index%d" where %d is the index number of the tabbar.
 *  Next link the UIButton's to a JTabBarView and finally link the tabBar and the viewContainer to this controller.
 *
 *  The tabbar controller will use the following rule to use a button as a tabbar item:
 *  1.  Use the UIViewController.jTabBarButton
 *  2.  Use the UIButton provided by the delegate
 *  3.  Use the buttons already in the tabbar
 *  4.  Will generate a new UIButton
 *  
 *  Then each button will be fill with the info based on the UIViewController.tabBarItem title, image and selected image (if not nil).
 */
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


#pragma mark - Properties

/**
 *  View that defines the area where the selected child viewController will be position.
 */
@property(nonatomic,strong) IBOutlet UIView *viewContainer;

/**
 *  Child's UIViewController's. Will create a tabbar for each UIViewController.
 *  No animation is perform when setting a new value.
 */
@property(nonatomic,copy) NSArray *tabBarChilds;

/**
 *  UIViewController that is currently on the viewContainer.
 *  No animation is perform when setting a new value.
 */
@property(nonatomic,weak) UIViewController *selectedTabBarChild;

/**
 *  Tabbar index that is currently selected. 
 *  No animation is perform when setting a new value.
 */
@property(nonatomic,assign) NSInteger selectedTabBarIndex;

/**
 *  Delegate to give extra control over the tabbar controller.
 */
@property(nonatomic,weak) id<JTabBarControllerDelegate> delegate;


#pragma mark - TabBar

/**
 *  Tabbar used by this controller.
 */
@property(nonatomic,strong) IBOutlet JTabBarView *tabBar;

/**
 *  Position of the tabbar relative to this controller.
 */
@property(nonatomic,assign) JTabBarDock tabBarDock;

/**
 *  Allows to show or hide the tabbar.
 *  Default: NO
 */
@property(nonatomic,assign) BOOL hiddenTabBar;


#pragma mark - Animations

/**
 *  Default animation when the selectedTabBarChild changes by default by the user.
 *  Default: JTabBarAnimationNone
 */
@property(nonatomic,assign) JTabBarAnimation defaultSelectedControllerAnimation;

/**
 *  Select the selected child view controller by it's index using a specific animation.
 */
- (void)setSelectedTabBarIndex:(NSInteger)selectedIndex animation:(JTabBarAnimation)animation completion:(void (^)(void))completion;

/**
 *  Select the selected child view controller by it's child using a specific animation.
 */
- (void)setSelectedTabBarChild:(UIViewController *)selectedChildViewController animation:(JTabBarAnimation)animation completion:(void (^)(void))completion;

/**
 *  Replace all the childs UIViewController's by new ones using a specific animation.
 */
- (void)setTabBarChilds:(NSArray *)childViewControllers animation:(JTabBarAnimation)animation completion:(void (^)(void))completion;

/**
 *  Show or hide the tabbar using a specific animation.
 */
- (void)setHiddenTabBar:(BOOL)hiddenTabBar animation:(JTabBarAnimation)animation completion:(void (^)(void))completion;

@end

/**
 *  Protocol representing JTabBarController delegate.
 */
@protocol JTabBarControllerDelegate <NSObject>
@optional

/**
 *  Call when a button is required to serve as a tabbar button for a specific child UIViewController. 
 *  It will ignore the return value if is the UIViewController has a jTabBarButton.
 */
- (UIButton *)tabBarController:(JTabBarController *)tabBarController tabBarButtonForTabBarChild:(UIViewController *)childViewController forIndex:(NSInteger)index;

/**
 *  Allows to override the selection state of a child UIViewController used by the tabbar controller.
 *  Returning NO will not select the child.
 */
- (BOOL)tabBarController:(JTabBarController *)tabBarController willSelectTabBarChild:(UIViewController *)childViewController forIndex:(NSInteger)index;

/**
 *  Selector that executes after a sucessfull selection of a child UIViewController.
 */
- (void)tabBarController:(JTabBarController *)tabBarController didSelectTabBarChild:(UIViewController *)childViewController forIndex:(NSInteger)index;

@end


/**
 *  Category that adds extra functionality to the UIViewController when inside this controller.
 */
@interface  UIViewController (JTabBarController)

/**
 *  Button to be used as a tabbar button if this view controller is inside a tabbar controller.
 */
@property (nonatomic, strong) IBOutlet UIButton *jTabBarButton;

/**
 *  If the view controller has a tabbar controller as its ancestor, return it. Returns nil otherwise.
 */
@property (nonatomic, weak) JTabBarController *jTabBarController;

@end
