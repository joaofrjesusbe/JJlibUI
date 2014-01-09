//
//  JTabBarController.m
//  JJlibUI
//
//  Created by Joao Jesus on 18/11/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "JTabBarController.h"
#import <objc/runtime.h>

@interface JTabBarController ()

@property(nonatomic,assign) CGFloat tabBarSize;

@end

@implementation JTabBarController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _associatedButtonMatrix = nil;
        self.tabBarSize = 44;
    }
    return self;
}

- (id)initWithTabBarHeight:(CGFloat)height {
    return [self initWithTabBarSize:height andDockPosition:JTabBarDockBottom];
}

- (id)initWithTabBarSize:(CGFloat)size andDockPosition:(JTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        _associatedTabBar = nil;
        _associatedButtonMatrix = nil;
        _tabBarDock = dockPosition;
        self.tabBarSize = size;
    }
    return self;
}

- (id)initWithTabBar:(JTabBarView *)tabbar andDockPosition:(JTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        _associatedTabBar = tabbar;
        _associatedButtonMatrix = nil;
        _tabBarDock = dockPosition;
        if (_tabBarDock != JTabBarDockNone) {
            
            if ( JTabBarDockIsHorizontal(_tabBarDock) ) {
                _associatedTabBar.alignment = JBarViewAlignmentHorizontal;
                self.tabBarSize = CGRectGetWidth(tabbar.frame);
            } else {
                _associatedTabBar.alignment = JBarViewAlignmentVertical;
                self.tabBarSize = CGRectGetHeight(tabbar.frame);
            }
            
        }else {
            _associatedTabBar.alignment = JBarViewAlignmentNone;
            self.tabBarSize = -1;
        }
    }
    return self;
}

- (id)initWithButtonMatrix:(JButtonMatrix *)buttonMatrix {
    self = [super init];
    if (self) {
        _associatedButtonMatrix = buttonMatrix;
        _associatedTabBar = nil;
        _tabBarDock = JTabBarDockNone;
        self.tabBarSize = -1;
    }
    return self;
}

#pragma mark - public properties

- (void)setChildViewControllers:(NSArray *)childViewControllers {

    for (UIViewController *child in _childViewControllers) {
        child.jTabBarController = nil;
    }
    
    if ( [self isViewLoaded] ) {
        self.selectedChildViewController = nil;
    }
    
    _childViewControllers = [childViewControllers mutableCopy];
    
    for (UIViewController *child in _childViewControllers) {
        child.jTabBarController = self;
    }
    
    if ( [self isViewLoaded] ) {
        [self createButtonsForViewControllers];
        self.selectedIndex = 0;
    }
}

- (void)setSelectedChildViewController:(UIViewController *)selectedChildViewController {
    
    NSInteger index = [_childViewControllers indexOfObject:selectedChildViewController];
    if (index == NSNotFound) {
        return;
    }
    
    if ( [self isViewLoaded] ) {
        
        if ( _associatedButtonMatrix ) {
            _associatedButtonMatrix.selectedIndex = index;
        } else if ( _associatedTabBar ) {
            _associatedTabBar.selectedIndex = index;
        }
        
        if (selectedChildViewController != _selectedChildViewController) {
            [self changeToViewController:selectedChildViewController isInitializing:NO];
        }        
        
    } else {        
        _selectedChildViewController = selectedChildViewController;
    }
}

@dynamic selectedIndex;
- (NSInteger)selectedIndex {
    UIViewController *viewController = self.selectedChildViewController;
    if (viewController == nil) {
        return NSNotFound;
    }
    return [_childViewControllers indexOfObject:self.selectedChildViewController];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < _childViewControllers.count) {
        self.selectedChildViewController = _childViewControllers[selectedIndex];
    }
}

- (void)setAssociatedButtonMatrix:(JButtonMatrix *)associatedButtonMatrix {
    [NSException raise:NSGenericException format:@"Not implemented"];
}

- (void)setAssociatedTabBar:(JTabBarView *)associatedTabBar {
    [NSException raise:NSGenericException format:@"Not implemented"];
}

- (void)setHiddenTabBar:(BOOL)hiddenTabBar {
    
    _hiddenTabBar = hiddenTabBar;
    if (self.associatedTabBar) {
        self.associatedTabBar.hidden = _hiddenTabBar;
    }
    
    if ( [self isViewLoaded] ) {
        _viewContainer.frame = [self frameForContainer];
    }
}

#pragma mark - view helpers

- (void)createAssociatedTabBar {
    JTabBarView *tabbar = [[JTabBarView alloc] initWithFrame:CGRectZero];
    _associatedTabBar = tabbar;
    [self.view addSubview:tabbar];
    [self.view bringSubviewToFront:_associatedTabBar];
    
    _associatedTabBar.frame = [self frameForTabBar];
    _associatedTabBar.alignment = [self alignmentForTabBar];
}

- (void)createViewContainer {
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    _viewContainer = container;
    [self.view addSubview:container];
    [self.view sendSubviewToBack:container];
    
    _viewContainer.frame = [self frameForContainer];
}

- (CGRect)frameForTabBar {
    CGRect viewBounds = self.view.bounds;
    CGRect tabBarFrame = self.associatedTabBar.frame;
    
    switch (self.tabBarDock) {
        case JTabBarDockTop:
            tabBarFrame = CGRectMake(0, 0, viewBounds.size.width, self.tabBarSize);
            break;
            
        case JTabBarDockBottom:
            tabBarFrame = CGRectMake(0, viewBounds.size.height - self.tabBarSize, viewBounds.size.width, self.tabBarSize);
            break;
            
        case JTabBarDockLeft:
            tabBarFrame = CGRectMake(0, 0, self.tabBarSize, viewBounds.size.height);
            break;
            
        case JTabBarDockRight:
            tabBarFrame = CGRectMake(0, viewBounds.size.width - self.tabBarSize, self.tabBarSize, viewBounds.size.height);
            break;
            
        default:
            break;
    }
    
    return tabBarFrame;
}

- (JBarViewAlignment)alignmentForTabBar {
    if ( JTabBarDockIsHorizontal(self.tabBarDock) ) {
        return JBarViewAlignmentHorizontal;
    } else if ( JTabBarDockIsVertical(self.tabBarDock) ) {
        return JBarViewAlignmentVertical;
    } else {
        return JBarViewAlignmentNone;
    }
}

- (CGRect)frameForContainer {
    CGRect viewBounds = self.view.bounds;
    CGSize tabBarSize = _associatedTabBar.frame.size;
    if ( self.associatedTabBar.hidden ) {
        tabBarSize = CGSizeZero;
    }
    
    CGRect containerFrame = viewBounds;
    
    switch (self.tabBarDock) {
        case JTabBarDockTop:
            containerFrame = CGRectMake(0, tabBarSize.height, viewBounds.size.width, viewBounds.size.height - tabBarSize.height);
            break;
            
        case JTabBarDockBottom:
            containerFrame = CGRectMake(0, 0, viewBounds.size.width, viewBounds.size.height - tabBarSize.height);
            break;
            
        case JTabBarDockLeft:
            containerFrame = CGRectMake(tabBarSize.width, 0, viewBounds.size.width - tabBarSize.width, viewBounds.size.height);
            break;
            
        case JTabBarDockRight:
            containerFrame = CGRectMake(0, 0, viewBounds.size.width - tabBarSize.height, viewBounds.size.height);
            break;
            
        case JTabBarDockNone:
            break;
    }
    
    return containerFrame;
}

- (void)createButtonsForViewControllers {
    
    NSMutableArray *tabBarButtons = [NSMutableArray arrayWithCapacity:_childViewControllers.count];
    NSInteger i = 0;
    BOOL needToAssociateNewButtons = NO;
    for (UIViewController *childViewController in _childViewControllers) {
        
        UIButton *button = nil;
        
        if ( [self.delegate respondsToSelector:@selector(tabBarController:tabBarButtonForChildViewController:forIndex:)] ) {
            button = [self.delegate tabBarController:self tabBarButtonForChildViewController:childViewController forIndex:i];
            needToAssociateNewButtons = YES;
        }
        
        UIButton *customButton = childViewController.jTabBarButton;
        if (customButton) {
            button = customButton;
            needToAssociateNewButtons = YES;
        }
    
        if (button == nil && _associatedButtonMatrix) {
            NSArray *buttonsAvaiable = _associatedButtonMatrix.buttonsArray;
            button = (i < buttonsAvaiable.count ? buttonsAvaiable[i] : nil);
        }
        
        if (button == nil && _associatedTabBar) {
            NSArray *buttonsAvaiable = _associatedTabBar.associatedButtonMatrix.buttonsArray;
            button = (i < buttonsAvaiable.count ? buttonsAvaiable[i] : nil);
        }
        
        if (button == nil) {
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:[NSString stringWithFormat:@"%ld", i] forState:UIControlStateNormal];
            needToAssociateNewButtons = YES;
        }
        
        if ( childViewController.tabBarItem ) {
            [button setTitle:childViewController.tabBarItem.title forState:UIControlStateNormal];
            [button setImage:childViewController.tabBarItem.image forState:UIControlStateNormal];
            if ([childViewController.tabBarItem respondsToSelector:@selector(selectedImage)]) {
                [button setImage:childViewController.tabBarItem.selectedImage forState:UIControlStateNormal];
            }
        }
        
        [button addTarget:self action:@selector(changeWithButton:) forControlEvents:UIControlEventTouchUpInside];
        childViewController.jTabBarButton = button;
        [tabBarButtons addObject:button];
        i++;
    }
    
    if (needToAssociateNewButtons) {
        if (_associatedButtonMatrix) {
            _associatedButtonMatrix.buttonsArray = tabBarButtons;
        }
        
        if (_associatedTabBar) {
            _associatedTabBar.childViews = tabBarButtons;
        }
    }
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ( _associatedTabBar == nil && _associatedButtonMatrix == nil ) {
        [self createAssociatedTabBar];
        [self.view addSubview:_associatedTabBar];
    } else if ( _associatedTabBar ) {
        _associatedTabBar.frame = [self frameForTabBar];
        _associatedTabBar.alignment = [self alignmentForTabBar];
        [self.view addSubview:_associatedTabBar];
    }
    
    if ( _viewContainer == nil ) {
        [self createViewContainer];
    }
    
    [self createButtonsForViewControllers];
    
    if (_childViewControllers.count > 0) {
        
        NSUInteger index = 0;
        if (_selectedChildViewController) {
            index = [_childViewControllers indexOfObject:_selectedChildViewController];
        }
        
        if (_associatedButtonMatrix) {
            _associatedButtonMatrix.selectedIndex = index;
        }else if (_associatedTabBar) {
            _associatedTabBar.selectedIndex = index;
        }
        UIViewController *controller = _childViewControllers[index];
        [self changeToViewController:controller isInitializing:YES];
    }
}

- (void)viewWillLayoutSubviews {
    _associatedTabBar.frame = [self frameForTabBar];
    _associatedTabBar.alignment = [self alignmentForTabBar];
    _viewContainer.frame = [self frameForContainer];
}


- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
    // Remove non-active child's views
    for (UIViewController *childController in _childViewControllers) {
        if ( childController != _selectedChildViewController ) {
            if ( [childController isViewLoaded] && [self.view window] == nil ) {
                childController.view = nil;
            }
        }
    }
    
    [super didReceiveMemoryWarning];
}

#pragma mark - animation functions

- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    [NSException raise:NSGenericException format:@"Not implemented"];
}

- (void)setChildViewControllers:(NSArray *)childViewControllers animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    [NSException raise:NSGenericException format:@"Not implemented"];
}

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    [NSException raise:NSGenericException format:@"Not implemented"];
    
    _hiddenTabBar = hiddenTabBar;
    if (self.associatedTabBar) {
        self.associatedTabBar.hidden = _hiddenTabBar;
    }
    
    if ( [self isViewLoaded] ) {
        
    }
}

#pragma mark - private functions

- (void)changeWithButton:(UIButton *)button {
    
    NSInteger index = button.selectionIndex;
    UIViewController *viewController = _childViewControllers[index];
    BOOL shouldSelect = YES;
    if ( [self.delegate respondsToSelector:@selector(tabBarController:willSelectChildViewController:forIndex:)] ) {
        shouldSelect = [self.delegate tabBarController:self willSelectChildViewController:viewController forIndex:index];
    }
    
    if ( shouldSelect ) {
    
        if (viewController != _selectedChildViewController) {
            [self changeToViewController:viewController isInitializing:NO];
        }
        
        if ( [self.delegate respondsToSelector:@selector(tabBarController:didSelectChildViewController:forIndex:)] ) {
            [self.delegate tabBarController:self didSelectChildViewController:viewController forIndex:index];
        }
    }
}

- (void)changeToViewController:(UIViewController *)viewController isInitializing:(BOOL)isInitializing {
    
    BOOL allowTransition = !isInitializing && _selectedChildViewController != nil && viewController != nil;
    
    if ( allowTransition && self.defaultSelectedControllerAnimation != JTabBarAnimationNone ) {
        
        [self addChildViewController:viewController];
        viewController.view.frame = self.viewContainer.bounds;
        
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
        if ( self.defaultSelectedControllerAnimation == JTabBarAnimationCrossDissolve ) {
            options = UIViewAnimationOptionTransitionCrossDissolve;
        }
        
        [self transitionFromViewController:_selectedChildViewController
                          toViewController:viewController
                                  duration:0.4
                                   options:options
                                animations:^{
                                    if (self.defaultSelectedControllerAnimation == JTabBarAnimationSlide) {
                                        CGRect finalFrame = _selectedChildViewController.view.frame;
                                        switch (self.tabBarDock) {
                                            case JTabBarDockTop:
                                                finalFrame.origin.y -= finalFrame.size.height;
                                                break;

                                            case JTabBarDockBottom:
                                                finalFrame.origin.y += finalFrame.size.height;
                                                break;

                                            case JTabBarDockLeft:
                                                finalFrame.origin.x -= finalFrame.size.width;
                                                break;

                                            case JTabBarDockRight:
                                                finalFrame.origin.x += finalFrame.size.width;
                                                break;

                                            default:
                                                break;
                                        }
                                        _selectedChildViewController.view.frame = finalFrame;
                                    }
                                }
                                completion:^(BOOL finished){
                                    [_selectedChildViewController willMoveToParentViewController:nil];
                                    [_selectedChildViewController removeFromParentViewController];
                                    [viewController didMoveToParentViewController:self];
                                    _selectedChildViewController = viewController;
                                }];
        
    } else {
        
        // remove old viewController
        if ( _selectedChildViewController ) {
            [_selectedChildViewController willMoveToParentViewController:nil];
            [_selectedChildViewController.view removeFromSuperview];
            [_selectedChildViewController removeFromParentViewController];
            _selectedChildViewController = nil;
        }
        
        viewController.view.frame = self.viewContainer.bounds;
        [self addChildViewController:viewController];
        [self.viewContainer addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        _selectedChildViewController = viewController;
    }
}

@end


@implementation UIViewController (JTabBarController)

static const NSString *KEY_ASSOC_jTabBarButton = @"JTabBarController.jTabBarButton";
static const NSString *KEY_ASSOC_jTabBarController = @"JTabBarController.jTabBarController";

@dynamic jTabBarButton;
-(UIButton *)jTabBarButton {
    UIButton *button = (UIButton *)objc_getAssociatedObject(self, &KEY_ASSOC_jTabBarButton);
    return button;
}

-(void)setJTabBarButton:(UIButton *)jTabBarButton {
    objc_setAssociatedObject(self, &KEY_ASSOC_jTabBarButton, jTabBarButton, OBJC_ASSOCIATION_RETAIN);
}

@dynamic jTabBarController;
- (JTabBarController *)jTabBarController {
    JTabBarController *controller = (JTabBarController *)objc_getAssociatedObject(self, &KEY_ASSOC_jTabBarController);
    return controller;
}

-(void)setJTabBarController:(JTabBarController *)jTabBarController {
    objc_setAssociatedObject(self, &KEY_ASSOC_jTabBarController, jTabBarController, OBJC_ASSOCIATION_RETAIN);
}

@end
