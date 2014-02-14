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

@property(nonatomic,assign) CGSize tabBarSize;

@end

@implementation JTabBarController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarSize = CGSizeMake(88, 44);
    }
    return self;
}

- (id)initWithTabBarSize:(CGSize)size {
    return [self initWithTabBarSize:size andDockPosition:JTabBarDockBottom];
}

- (id)initWithTabBarSize:(CGSize)size andDockPosition:(JTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        _associatedTabBar = nil;
        _tabBarDock = dockPosition;
        self.tabBarSize = size;
    }
    return self;
}

- (id)initWithTabBar:(JTabBarView *)tabbar andDockPosition:(JTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        _associatedTabBar = tabbar;
        _tabBarDock = dockPosition;
        if (_tabBarDock != JTabBarDockNone) {            
            _associatedTabBar.alignment = ( JTabBarDockIsHorizontal(_tabBarDock) ? JBarViewAlignmentHorizontal : JBarViewAlignmentVertical);
            self.tabBarSize = tabbar.frame.size;
        }else {
            _associatedTabBar.alignment = JBarViewAlignmentNone;
            self.tabBarSize = CGSizeZero;
        }
    }
    return self;
}

#pragma mark - public properties

- (void)setChildViewControllers:(NSArray *)childViewControllers {
    [self setChildViewControllers:childViewControllers animation:JTabBarAnimationNone completion:nil];
}

- (void)setSelectedChildViewController:(UIViewController *)selectedChildViewController {
    [self setSelectedChildViewController:selectedChildViewController animation:JTabBarAnimationNone completion:nil];
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
    [self setSelectedIndex:selectedIndex animation:JTabBarAnimationNone completion:nil];
}

- (void)setAssociatedTabBar:(JTabBarView *)associatedTabBar {
    _associatedTabBar = associatedTabBar;
    [self.view addSubview:_associatedTabBar];
    [self.view bringSubviewToFront:_associatedTabBar];
    
    _associatedTabBar.frame = [self frameForTabBarWithTabbarHidden:_associatedTabBar.hidden];
    _associatedTabBar.alignment = [self alignmentForTabBar];
}

- (void)setHiddenTabBar:(BOOL)hiddenTabBar {
    [self setHiddenTabBar:hiddenTabBar animation:JTabBarAnimationNone completion:nil];
}

- (void)setTabBarDock:(JTabBarDock)tabBarDock {
    _tabBarDock = tabBarDock;
    
    if ( [self isViewLoaded] ) {
        [self viewWillLayoutSubviews];
    }
}

#pragma mark - view helpers

- (void)createAssociatedTabBar {
    JTabBarView *tabbar = [[JTabBarView alloc] initWithFrame:CGRectZero];
    self.associatedTabBar = tabbar;
}

- (void)createViewContainer {
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.clipsToBounds = YES;
    _viewContainer = container;
    [self.view addSubview:container];
    [self.view sendSubviewToBack:container];
    
    _viewContainer.frame = [self frameForContainerWithTabbarHidden:_associatedTabBar.hidden];
}

- (CGRect)frameForTabBarWithTabbarHidden:(BOOL)tabbarHidden {
    CGRect viewBounds = [self frameForContainerWithTabbarHidden:tabbarHidden];
    CGRect tabBarFrame = self.associatedTabBar.frame;
    CGPoint offsetHidden = CGPointZero;
    if ( tabbarHidden ) {
        offsetHidden = CGPointMake( -self.tabBarSize.width, -self.tabBarSize.height);
    }
    
    switch (self.tabBarDock) {
        case JTabBarDockTop:
            tabBarFrame = CGRectMake(0, offsetHidden.y, viewBounds.size.width, self.tabBarSize.height);
            break;
            
        case JTabBarDockBottom:
            tabBarFrame = CGRectMake(0, viewBounds.size.height, viewBounds.size.width, self.tabBarSize.height);
            break;
            
        case JTabBarDockLeft:
            tabBarFrame = CGRectMake(offsetHidden.x, 0, self.tabBarSize.width, viewBounds.size.height);
            break;
            
        case JTabBarDockRight:
            tabBarFrame = CGRectMake(viewBounds.size.width, 0, self.tabBarSize.width, viewBounds.size.height);
            break;
            
        case JTabBarDockNone:
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

- (CGRect)frameForContainerWithTabbarHidden:(BOOL)tabbarHidden {
    CGRect viewBounds = self.view.bounds;
    CGSize tabBarSize = self.tabBarSize;
    if ( tabbarHidden ) {
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
            containerFrame = CGRectMake(0, 0, viewBounds.size.width - tabBarSize.width, viewBounds.size.height);
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
        if ( customButton ) {
            button = customButton;
            needToAssociateNewButtons = YES;
        }
        
        if ( button == nil ) {
            NSArray *buttonsAvaiable = _associatedTabBar.associatedButtonMatrix.buttonsArray;
            button = (i < buttonsAvaiable.count ? buttonsAvaiable[i] : nil);
        }
        
        if ( button == nil ) {
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
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
    
    if ( _associatedTabBar == nil ) {
        [self createAssociatedTabBar];
        [self.view addSubview:_associatedTabBar];
    } else {
        _associatedTabBar.frame = [self frameForTabBarWithTabbarHidden:_associatedTabBar.hidden];
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
        
        _associatedTabBar.selectedIndex = index;

        UIViewController *controller = _childViewControllers[index];
        [self changeToViewController:controller withAnimation:JTabBarAnimationNone completion:nil];
    }
}

- (void)viewWillLayoutSubviews {
    _associatedTabBar.frame = [self frameForTabBarWithTabbarHidden:_associatedTabBar.hidden];
    _associatedTabBar.alignment = [self alignmentForTabBar];
    _viewContainer.frame = [self frameForContainerWithTabbarHidden:(_associatedTabBar ? _associatedTabBar.hidden : NO)];
    self.selectedChildViewController.view.frame = _viewContainer.bounds;
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
    if (selectedIndex >= 0 && selectedIndex < _childViewControllers.count) {
        UIViewController *viewController = [_childViewControllers objectAtIndex:selectedIndex];
        
        if ( [self isViewLoaded] ) {
            
            _associatedTabBar.selectedIndex = selectedIndex;
            
            if (viewController != _selectedChildViewController) {
                [self changeToViewController:viewController withAnimation:animation completion:completion];
            }
            
        } else {
            _selectedChildViewController = viewController;
        }
    }
}

- (void)setChildViewControllers:(NSArray *)childViewControllers animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    
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
        [self setSelectedIndex:0 animation:animation completion:completion];
    }
}

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    
    _hiddenTabBar = hiddenTabBar;
    CGRect frame = CGRectZero;
    
    if ( [self isViewLoaded] && self.associatedTabBar && animation != JTabBarAnimationNone ) {
        
        frame = [self frameForContainerWithTabbarHidden:YES];
        self.selectedChildViewController.view.frame = frame;
        
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
        if ( animation == JTabBarAnimationCrossDissolve ) {
            frame = [self frameForTabBarWithTabbarHidden:NO];
            self.associatedTabBar.frame = frame;
            self.associatedTabBar.alpha = (hiddenTabBar ? 1.0f : 0.0f);

        }else if ( animation == JTabBarAnimationSlide ) {
            frame = [self frameForTabBarWithTabbarHidden:!_hiddenTabBar];
            self.associatedTabBar.frame = frame;
            self.associatedTabBar.alpha = 1.0f;
        }
        
        self.associatedTabBar.hidden = NO;
        
        [UIView animateWithDuration:0.3f delay:0.0f options:options animations:^{
            
            if ( animation == JTabBarAnimationSlide ) {
                CGRect frame = [self frameForTabBarWithTabbarHidden:_hiddenTabBar];
                self.associatedTabBar.frame = frame;
            } else if ( animation == JTabBarAnimationCrossDissolve ) {
                self.associatedTabBar.alpha = (hiddenTabBar ? 0.0f : 1.0f);
            }
            
            _viewContainer.frame = [self frameForContainerWithTabbarHidden:(_associatedTabBar ? _associatedTabBar.hidden : NO)];
            self.selectedChildViewController.view.frame = _viewContainer.bounds;
            
        } completion:^(BOOL finished) {
            self.associatedTabBar.alpha = 1.0f;
            self.associatedTabBar.hidden = _hiddenTabBar;
            [self viewWillLayoutSubviews];

            if ( completion ) {
                completion();
            }
        }];
    } else {

        self.associatedTabBar.alpha = 1.0f;
        self.associatedTabBar.hidden = _hiddenTabBar;
        [self viewWillLayoutSubviews];
    }
}

- (void)setSelectedChildViewController:(UIViewController *)selectedChildViewController animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    
    NSInteger index = [_childViewControllers indexOfObject:selectedChildViewController];
    if (index == NSNotFound) {
        return;
    }
    
    if ( [self isViewLoaded] ) {
        
        self.associatedTabBar.selectedIndex = index;
        
        if (selectedChildViewController != _selectedChildViewController) {
            [self changeToViewController:selectedChildViewController withAnimation:animation completion:nil];
        }
        
    } else {
        _selectedChildViewController = selectedChildViewController;
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
            [self changeToViewController:viewController withAnimation:self.defaultSelectedControllerAnimation completion:nil];
        }
        
        if ( [self.delegate respondsToSelector:@selector(tabBarController:didSelectChildViewController:forIndex:)] ) {
            [self.delegate tabBarController:self didSelectChildViewController:viewController forIndex:index];
        }
    }
}

- (void)changeToViewController:(UIViewController *)viewController withAnimation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    
    BOOL allowTransition = (animation != JTabBarAnimationNone && _selectedChildViewController != nil && viewController != nil);
    
    if ( allowTransition ) {
        
        viewController.view.frame = self.viewContainer.bounds;
        [self addChildViewController:viewController];
        [_selectedChildViewController willMoveToParentViewController:nil];
        
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
        
        if ( animation == JTabBarAnimationCrossDissolve ) {
            options |= UIViewAnimationOptionTransitionCrossDissolve;
            
        } else if ( animation == JTabBarAnimationSlide ) {
            
            CGRect initialFrame = self.viewContainer.bounds;
            switch (self.tabBarDock) {
                case JTabBarDockTop:
                    initialFrame.origin.y -= initialFrame.size.height;
                    break;
                    
                case JTabBarDockBottom:
                    initialFrame.origin.y += initialFrame.size.height;
                    break;
                    
                case JTabBarDockLeft:
                    initialFrame.origin.x -= initialFrame.size.width;
                    break;
                    
                case JTabBarDockRight:
                    initialFrame.origin.x += initialFrame.size.width;
                    break;
                    
                default:
                    break;
            }
            viewController.view.frame = initialFrame;
        }
        
        [self transitionFromViewController:_selectedChildViewController
                          toViewController:viewController
                                  duration:0.3
                                   options:options
                                animations:^{
                                    if ( animation == JTabBarAnimationSlide ) {
                                        CGRect finalFrame = self.viewContainer.bounds;
                                        viewController.view.frame = finalFrame;
                                    }
                                }
                                completion:^(BOOL finished){
                                    [_selectedChildViewController removeFromParentViewController];
                                    [viewController didMoveToParentViewController:self];
                                    _selectedChildViewController = viewController;
                                    [self viewWillLayoutSubviews];
                                    
                                    if ( completion ) {
                                        completion();
                                    }
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
        [self viewWillLayoutSubviews];
        
        if ( completion ) {
            completion();
        }
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
