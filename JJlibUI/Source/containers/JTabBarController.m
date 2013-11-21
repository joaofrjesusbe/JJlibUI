//
//  JTabBarController.m
//  JJlibUI
//
//  Created by Joao Jesus on 18/11/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
//

#import "JTabBarController.h"

@interface JTabBarController ()

@property(nonatomic,assign) BOOL setNeedsToCreateTabBar;
@property(nonatomic,assign) CGFloat tabBarSize;

@end

@implementation JTabBarController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.setNeedsToCreateTabBar = YES;
        _associatedButtonMatrix = nil;
    }
    return self;
}

- (id)initWithTabBarHeight:(CGFloat)height {
    return [self initWithTabBarSize:height andDockPosition:JTabBarDockBottom];
}

- (id)initWithTabViewSize:(CGFloat)size andDockPosition:(JTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        self.setNeedsToCreateTabBar = YES;
        _associatedTabBar = nil;
        _associatedButtonMatrix = nil;
        _tabBarDock = dockPosition;
        self.tabBarSize = size;
    }
    return nil;
}

- (id)initWithTabBar:(JTabBarView *)tabbar andDockPosition:(JTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        self.setNeedsToCreateTabBar = NO;
        _associatedTabBar = tabbar;
        _associatedButtonMatrix = nil;
        _tabBarDock = dockPosition;
        if (_tabBarDock != JTabBarDockNone) {
            self.tabBarSize = ( JTabBarDockIsHorizontal(_tabBarDock) ? CGRectGetWidth(tabbar.frame) : CGRectGetHeight(tabbar.frame) );
        }else {
            self.tabBarSize = -1;
        }
    }
    return nil;
}

- (id)initWithButtonMatrix:(JButtonMatrix *)buttonMatrix {
    self = [super init];
    if (self) {
        self.setNeedsToCreateTabBar = NO;
        _associatedButtonMatrix = buttonMatrix;
        _associatedTabBar = nil;
        _tabBarDock = JTabBarDockNone;
        self.tabBarSize = -1;
    }
    return nil;
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public properties


#pragma mark - public functions

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animated:(BOOL)animated {
    
}

@end
