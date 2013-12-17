//
//  TabBarControllerExampleVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 30/11/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
//

#import "TabBarControllerExampleVC.h"
#import "TabBarExampleVC.h"
#import "BarViewExampleVC.h"
#import "MoreViewVC.h"
#import "JUILib.h"

@interface TabBarControllerExampleVC () <JTabBarControllerDelegate>

@property (nonatomic,strong) JTabBarController *tabBarController;

@end

@implementation TabBarControllerExampleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    JTabBarView *tabBarView = [[JTabBarView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    tabBarView.backgroundImage = [UIImage imageNamed:@"blackHorizontalBar"];

    TabBarExampleVC *example1 = [[TabBarExampleVC alloc] initWithNibName:nil bundle:nil];
    example1.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    example1.tabBarItem.title = @"TabBar";
    
    BarViewExampleVC *example2 = [[BarViewExampleVC alloc] initWithNibName:nil bundle:nil];
    example2.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    example2.tabBarItem.title = @"BarView";
    
    MoreViewVC *example3 = [[MoreViewVC alloc] initWithNibName:nil bundle:nil];
    example3.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    example3.tabBarItem.title = @"More";
    
    _tabBarController = [[JTabBarController alloc] initWithTabBar:tabBarView andDockPosition:JTabBarDockBottom];
    _tabBarController.delegate = self;
    _tabBarController.childViewControllers = @[
                                               example1,
                                               example2,
                                               example3
                                               ];
    _tabBarController.selectedIndex = 2;
    [self addChildViewController:_tabBarController];
    [self.view addSubview:_tabBarController.view];
    [_tabBarController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - JTabBarControllerDelegate

- (UIButton *)tabBarController:(JTabBarController *)tabBarController tabBarButtonForChildViewController:(UIViewController *)childViewController forIndex:(uint)index {
    
    // this will only execute if the childViewController do not provide a jTabBarButton
    return [[NSBundle mainBundle] loadNibNamed:@"AltMainButtonTemplate" owner:self options:nil][0];;
}

@end
