//
//  JTabBarController.m
//  JJlibUI
//
//  Created by Joao Jesus on 18/11/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
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
            self.tabBarSize = ( JTabBarDockIsHorizontal(_tabBarDock) ? CGRectGetWidth(tabbar.frame) : CGRectGetHeight(tabbar.frame) );
        }else {
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
    if ( [self isViewLoaded] ) {
        
    }
    
    _childViewControllers = [childViewControllers mutableCopy];
    
    if ( [self isViewLoaded] ) {
        
    }
}

- (void)setSelectedChildViewController:(UIViewController *)selectedChildViewController {
    
    NSInteger index = [_childViewControllers indexOfObject:selectedChildViewController];
    if (index == NSNotFound) {
        return;
    }
    
    _selectedChildViewController = selectedChildViewController;
    
    if ( [self isViewLoaded] ) {
        _associatedButtonMatrix.selectedIndex = index;
    }
}

@dynamic selectedIndex;
- (uint)selectedIndex {
    UIViewController *viewController = self.selectedChildViewController;
    if (viewController == nil) {
        return NSNotFound;
    }
    return [_childViewControllers indexOfObject:self.selectedChildViewController];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex > 0 && selectedIndex < _childViewControllers.count) {
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
    [NSException raise:NSGenericException format:@"Not implemented"];
}

#pragma mark - view helpers

- (void)createTabBar {
    CGRect viewBounds = self.view.bounds;
    CGRect tabBarFrame = CGRectZero;
    JBarViewAlignment alignment = JBarViewAlignmentHorizontal;
    UIViewAutoresizing resizeMask = UIViewAutoresizingNone;
    
    switch (self.tabBarDock) {
        case JTabBarDockTop:
            tabBarFrame = CGRectMake(0, 0, viewBounds.size.width, self.tabBarSize);
            alignment = JBarViewAlignmentHorizontal;
            resizeMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            break;
            
        case JTabBarDockBottom:
            tabBarFrame = CGRectMake(0, viewBounds.size.height - self.tabBarSize, viewBounds.size.width, self.tabBarSize);
            alignment = JBarViewAlignmentHorizontal;
            resizeMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            break;
            
        case JTabBarDockLeft:
            tabBarFrame = CGRectMake(0, 0, self.tabBarSize, viewBounds.size.height);
            alignment = JBarViewAlignmentVertical;
            resizeMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
            break;
            
        case JTabBarDockRight:
            tabBarFrame = CGRectMake(0, viewBounds.size.width - self.tabBarSize, self.tabBarSize, viewBounds.size.height);
            alignment = JBarViewAlignmentVertical;
            resizeMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
            break;
            
        default:
            break;
    }
    
    JTabBarView *tabbar = [[JTabBarView alloc] initWithFrame:tabBarFrame];
    tabbar.alignment = alignment;
    _associatedTabBar = tabbar;
    [self.view addSubview:tabbar];

}

- (void)createViewContainer {
    CGRect viewBounds = self.view.bounds;
    CGSize tabBarSize = _associatedTabBar.frame.size;
    CGRect containerFrame = CGRectZero;
    
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
    
    UIView *container = [[UIView alloc] initWithFrame:containerFrame];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _viewContainer = container;
    [self.view addSubview:container];
    [self.view sendSubviewToBack:container];
}

- (void)createButtonsForViewControllers {
    
    NSMutableArray *tabBarButtons = [NSMutableArray arrayWithCapacity:_childViewControllers.count];
    NSInteger i = 0;
    BOOL needToAssociateNewButtons = NO;
    for (UIViewController *childViewControllers in _childViewControllers) {
        UIButton *button = childViewControllers.jTabBarButton;
        
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
            [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            needToAssociateNewButtons = YES;
        }
        
        [button addTarget:self action:@selector(changeWithButton:) forControlEvents:UIControlEventTouchUpInside];
        childViewControllers.jTabBarButton = button;
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
        [self createTabBar];
    }
    
    if ( _viewContainer == nil ) {
        [self createViewContainer];
    }
    
    [self createButtonsForViewControllers];
    
    if (_childViewControllers.count > 0) {
        [self changeToViewController:_childViewControllers[0]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public functions

- (void)setChildViewControllers:(NSArray *)childViewControllers animatedOptions:(UIViewAnimationOptions)animatedOptions completion:(void (^)(void))completion {
    [NSException raise:NSGenericException format:@"Not implemented"];
}

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animatedOptions:(UIViewAnimationOptions)animatedOptions completion:(void (^)(void))completion {
    [NSException raise:NSGenericException format:@"Not implemented"];
}

#pragma mark - private functions

- (void)changeWithButton:(UIButton *)button {
    [self changeToViewController:_childViewControllers[button.selectionIndex]];
}

- (void)changeToViewController:(UIViewController *)viewController {
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
