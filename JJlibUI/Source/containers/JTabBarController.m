//
//  JTabBarController.m
//  JJlibUI
//
//  Created by Joao Jesus on 18/11/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "JTabBarController.h"
#import <objc/runtime.h>
#import "JTabBarSegue.h"

@interface JTabBarController () <JButtonMatrixDelegate>

@property(nonatomic,assign) CGSize tabBarSize;
@property(atomic,assign) BOOL isChangingChildViewControllers;

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
        _tabBar = nil;
        _tabBarDock = dockPosition;
        self.tabBarSize = size;
    }
    return self;
}

- (id)initWithTabBar:(JTabBarView *)tabbar andDockPosition:(JTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        _tabBar = tabbar;
        _tabBarDock = dockPosition;
        if (_tabBarDock != JTabBarDockNone) {            
            _tabBar.alignment = ( JTabBarDockIsHorizontal(_tabBarDock) ? JBarViewAlignmentHorizontal : JBarViewAlignmentVertical);
            self.tabBarSize = tabbar.frame.size;
        }else {
            _tabBar.alignment = JBarViewAlignmentNone;
            self.tabBarSize = CGSizeZero;
        }
    }
    return self;
}

#pragma mark - public properties

- (void)setTabBarChilds:(NSArray *)tabBarChilds {
    [self setTabBarChilds:tabBarChilds animation:JTabBarAnimationNone completion:nil];
}

- (void)setSelectedTabBarChild:(UIViewController *)selectedChildViewController {
    [self setSelectedTabBarChild:selectedChildViewController animation:JTabBarAnimationNone completion:nil];
}

@dynamic selectedTabBarIndex;
- (NSInteger)selectedTabBarIndex {
    UIViewController *viewController = self.selectedTabBarChild;
    if (viewController == nil) {
        return NSNotFound;
    }
    return [_tabBarChilds indexOfObject:self.selectedTabBarChild];
}

- (void)setSelectedTabBarIndex:(NSInteger)selectedIndex {
    [self setSelectedTabBarIndex:selectedIndex animation:JTabBarAnimationNone completion:nil];
}

- (void)setTabBar:(JTabBarView *)associatedTabBar {
    _tabBar = associatedTabBar;
    
    if ( ![self isViewLoaded] ) {
        return;
    }
    
    if ( _tabBar.superview != self.view ) {
        [self.view addSubview:_tabBar];
        [self.view bringSubviewToFront:_tabBar];
    }
    
    _tabBar.frame = [self frameForTabBarWithTabbarHidden:_tabBar.hidden];
    _tabBar.alignment = [self alignmentForTabBar];
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

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ( _tabBar == nil ) {
        [self createTabBar];
        [self.view addSubview:_tabBar];
    } else {
        _tabBar.frame = [self frameForTabBarWithTabbarHidden:_tabBar.hidden];
        _tabBar.alignment = [self alignmentForTabBar];
        [self.view addSubview:_tabBar];
    }
    
    if ( _viewContainer == nil ) {
        [self createViewContainer];
    }
    
    if ( _tabBarChilds == nil && _tabBar.matrix.buttonsArray.count > 0 ) {
        // initialize from storyboard
        [self prepareTabBarChildsArray];
        UIButton *selectedButton = _tabBar.matrix.selectedButton;
        if ( selectedButton == nil ) {
            _tabBar.matrix.selectedIndex = 0;
            selectedButton = _tabBar.matrix.selectedButton;
        }
        [self performSegueWithIdentifier:@"" sender:selectedButton];
        
    } else {
        
        [self createButtonsForViewControllers];
    
        if ( _tabBarChilds.count > 0 ) {
            
            NSUInteger index = 0;
            if (_selectedTabBarChild) {
                index = [_tabBarChilds indexOfObject:_selectedTabBarChild];
            }
            
            _tabBar.selectedIndex = index;
            
            UIViewController *controller = _tabBarChilds[index];
            [self changeToViewController:controller withAnimation:JTabBarAnimationNone completion:nil];
        }
    }
}

- (void)viewWillLayoutSubviews {
    _tabBar.frame = [self frameForTabBarWithTabbarHidden:_tabBar.hidden];
    _tabBar.alignment = [self alignmentForTabBar];
    _viewContainer.frame = [self frameForContainerWithTabbarHidden:(_tabBar ? _tabBar.hidden : NO)];
    self.selectedTabBarChild.view.frame = _viewContainer.bounds;
}


- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
    // Remove non-active child's views
    for (UIViewController *childController in _tabBarChilds) {
        if ( childController != _selectedTabBarChild ) {
            if ( [childController isViewLoaded] && [self.view window] == nil ) {
                childController.view = nil;
            }
        }
    }
    
    [super didReceiveMemoryWarning];
}

#pragma mark - animation functions

- (void)setSelectedTabBarIndex:(NSInteger)selectedIndex animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {

    if (selectedIndex >= 0 && selectedIndex < _tabBarChilds.count) {
        UIViewController *viewController = [_tabBarChilds objectAtIndex:selectedIndex];
        
        if ( [self isViewLoaded] ) {
            
            _tabBar.selectedIndex = selectedIndex;
            
            if (viewController != _selectedTabBarChild) {
                [self changeToViewController:viewController withAnimation:animation completion:completion];
            }
            
        } else {
            _selectedTabBarChild = viewController;
        }
    }
}

- (void)setTabBarChilds:(NSArray *)childViewControllers animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {

    for (UIViewController *child in _tabBarChilds) {
        child.jTabBarController = nil;
    }
    
    if ( [self isViewLoaded] ) {
        self.selectedTabBarChild = nil;
    }
    
    _tabBarChilds = [childViewControllers mutableCopy];
    
    for (UIViewController *child in _tabBarChilds) {
        child.jTabBarController = self;
    }
    
    if ( [self isViewLoaded] ) {
        [self createButtonsForViewControllers];
        [self setSelectedTabBarIndex:0 animation:animation completion:completion];
    }
}

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    
    _hiddenTabBar = hiddenTabBar;
    CGRect frame = CGRectZero;
    
    if ( [self isViewLoaded] && self.tabBar && animation != JTabBarAnimationNone ) {
        
        frame = [self frameForContainerWithTabbarHidden:YES];
        self.selectedTabBarChild.view.frame = frame;
        
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
        if ( animation == JTabBarAnimationCrossDissolve ) {
            frame = [self frameForTabBarWithTabbarHidden:NO];
            self.tabBar.frame = frame;
            self.tabBar.alpha = (hiddenTabBar ? 1.0f : 0.0f);

        }else if ( animation == JTabBarAnimationSlide ) {
            frame = [self frameForTabBarWithTabbarHidden:!_hiddenTabBar];
            self.tabBar.frame = frame;
            self.tabBar.alpha = 1.0f;
        }
        
        self.tabBar.hidden = NO;
        
        [UIView animateWithDuration:0.3f delay:0.0f options:options animations:^{
            
            if ( animation == JTabBarAnimationSlide ) {
                CGRect frame = [self frameForTabBarWithTabbarHidden:_hiddenTabBar];
                self.tabBar.frame = frame;
            } else if ( animation == JTabBarAnimationCrossDissolve ) {
                self.tabBar.alpha = (hiddenTabBar ? 0.0f : 1.0f);
            }
            
            _viewContainer.frame = [self frameForContainerWithTabbarHidden:(_tabBar ? _tabBar.hidden : NO)];
            self.selectedTabBarChild.view.frame = _viewContainer.bounds;
            
        } completion:^(BOOL finished) {
            self.tabBar.alpha = 1.0f;
            self.tabBar.hidden = _hiddenTabBar;
            [self viewWillLayoutSubviews];

            if ( completion ) {
                completion();
            }
        }];
    } else {

        self.tabBar.alpha = 1.0f;
        self.tabBar.hidden = _hiddenTabBar;
        [self viewWillLayoutSubviews];
    }
}

- (void)setSelectedTabBarChild:(UIViewController *)selectedChildViewController animation:(JTabBarAnimation)animation completion:(void (^)(void))completion {

    NSInteger index = [_tabBarChilds indexOfObject:selectedChildViewController];
    if (index == NSNotFound) {
        return;
    }
    
    if ( [self isViewLoaded] ) {
        
        self.tabBar.selectedIndex = index;
        
        if (selectedChildViewController != _selectedTabBarChild) {
            [self changeToViewController:selectedChildViewController withAnimation:animation completion:nil];
        }
        
    } else {
        _selectedTabBarChild = selectedChildViewController;
    }
}

#pragma mark - Perform Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ( [sender isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue isKindOfClass:[JTabBarSegue class]] && [sender isKindOfClass:[UIButton class]] ) {

        UIButton *button = (UIButton *)sender;
        UIViewController *vc = segue.destinationViewController;
        vc.jTabBarController = self;
        vc.jTabBarButton = button;
        [((NSMutableArray *)_tabBarChilds) replaceObjectAtIndex:button.selectionIndex withObject:segue.destinationViewController];
    }
}

#pragma mark - JButtonMatrixDelegate

- (BOOL)buttonMatrix:(JButtonMatrix *)buttonMatrix willSelectButton:(UIButton *)button forIndex:(NSInteger)index {
    BOOL shouldSelect = YES;
    if ( [self.delegate respondsToSelector:@selector(tabBarController:willSelectTabBarChild:forIndex:)] ) {
        shouldSelect = [self.delegate tabBarController:self willSelectTabBarChild:_tabBarChilds[index] forIndex:index];
    }
    return shouldSelect;
}

- (void)buttonMatrix:(JButtonMatrix *)buttonMatrix didSelectButton:(UIButton *)button forIndex:(NSInteger)index {
    UIViewController *viewController = _tabBarChilds[index];
    if (viewController != _selectedTabBarChild) {
        [self changeToViewController:viewController withAnimation:self.defaultSelectedControllerAnimation completion:nil];
    }
    
    if ( [self.delegate respondsToSelector:@selector(tabBarController:didSelectTabBarChild:forIndex:)] ) {
        [self.delegate tabBarController:self didSelectTabBarChild:viewController forIndex:index];
    }
}

#pragma mark - private functions

- (void)prepareTabBarChildsArray {
    NSMutableArray *array = [NSMutableArray array];
    for (UIButton *button in self.tabBar.matrix.buttonsArray) {
        [array addObject:[NSNull null]];
    }
    _tabBarChilds = array;
}

- (void)createTabBar {
    JTabBarView *tabbar = [[JTabBarView alloc] initWithFrame:CGRectZero];
    self.tabBar = tabbar;
}

- (void)createViewContainer {
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.clipsToBounds = YES;
    _viewContainer = container;
    [self.view addSubview:container];
    [self.view sendSubviewToBack:container];
    
    _viewContainer.frame = [self frameForContainerWithTabbarHidden:_tabBar.hidden];
}

- (CGRect)frameForTabBarWithTabbarHidden:(BOOL)tabbarHidden {
    CGRect viewBounds = [self frameForContainerWithTabbarHidden:tabbarHidden];
    CGRect tabBarFrame = self.tabBar.frame;
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

    NSMutableArray *tabBarButtons = [NSMutableArray arrayWithCapacity:_tabBarChilds.count];
    NSInteger i = 0;
    BOOL needToAssociateNewButtons = NO;
    self.tabBar.matrix.delegate = self;
    
    for (UIViewController *childViewController in _tabBarChilds) {
        
        UIButton *button = nil;
        
        if ( [self.delegate respondsToSelector:@selector(tabBarController:tabBarButtonForTabBarChild:forIndex:)] ) {
            button = [self.delegate tabBarController:self tabBarButtonForTabBarChild:childViewController forIndex:i];
            needToAssociateNewButtons = YES;
        }
        
        UIButton *customButton = childViewController.jTabBarButton;
        if ( customButton ) {
            button = customButton;
            needToAssociateNewButtons = YES;
        }
        
        if ( button == nil ) {
            NSArray *buttonsAvaiable = _tabBar.matrix.buttonsArray;
            button = (i < buttonsAvaiable.count ? buttonsAvaiable[i] : nil);
        }
        
        if ( button == nil ) {
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:[NSString stringWithFormat:@"%ld", (long)i] forState:UIControlStateNormal];
            needToAssociateNewButtons = YES;
        }
        
        if ( childViewController.tabBarItem ) {
            [button setTitle:childViewController.tabBarItem.title forState:UIControlStateNormal];
            [button setImage:childViewController.tabBarItem.image forState:UIControlStateNormal];
            if ([childViewController.tabBarItem respondsToSelector:@selector(selectedImage)]) {
                [button setImage:childViewController.tabBarItem.selectedImage forState:UIControlStateNormal];
            }
        }
        
        childViewController.jTabBarButton = button;
        [tabBarButtons addObject:button];
        i++;
    }
    
    if (needToAssociateNewButtons) {
        
        if (_tabBar) {
            _tabBar.childViews = tabBarButtons;
        }
    }
}

- (void)changeToViewController:(UIViewController *)viewController withAnimation:(JTabBarAnimation)animation completion:(void (^)(void))completion {
    
    if ( self.isChangingChildViewControllers ) {
        return;
    }
    
    self.isChangingChildViewControllers = YES;
    BOOL allowAnimation = (animation != JTabBarAnimationNone && _selectedTabBarChild != nil && viewController != nil);
    
    if ( allowAnimation ) {
        
        viewController.view.frame = self.viewContainer.bounds;
        [self addChildViewController:viewController];
        [_selectedTabBarChild willMoveToParentViewController:nil];
        
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
        
        [self transitionFromViewController:_selectedTabBarChild
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
                                    [_selectedTabBarChild removeFromParentViewController];
                                    [viewController didMoveToParentViewController:self];
                                    _selectedTabBarChild = viewController;
                                    [self viewWillLayoutSubviews];
                                    
                                    if ( completion ) {
                                        completion();
                                    }
                                    
                                     self.isChangingChildViewControllers = NO;
                                }];
        
    } else {
        
        // remove old viewController
        if ( _selectedTabBarChild ) {
            [_selectedTabBarChild willMoveToParentViewController:nil];
            [_selectedTabBarChild.view removeFromSuperview];
            [_selectedTabBarChild removeFromParentViewController];
            _selectedTabBarChild = nil;
        }
        
        viewController.view.frame = self.viewContainer.bounds;
        [self addChildViewController:viewController];
        [self.viewContainer addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        _selectedTabBarChild = viewController;
        [self viewWillLayoutSubviews];
        
        if ( completion ) {
            completion();
        }
        
        self.isChangingChildViewControllers = NO;
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
