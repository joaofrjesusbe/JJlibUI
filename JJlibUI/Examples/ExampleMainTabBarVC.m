//
//  TabBarControllerExampleVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 30/11/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
//

#import "ExampleMainTabBarVC.h"
#import "ExampleTabBarVC.h"
#import "ExampleConfigVC.h"
#import "ExampleActionsVC.h"
#import "JUILib.h"
#import "ExampleSettings.h"

@interface ExampleMainTabBarVC () <JTabBarControllerDelegate>

@property (nonatomic,strong) JTabBarController *tabBarController;

@end

@implementation ExampleMainTabBarVC

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

    ExampleTabBarVC *tabBar = [[ExampleTabBarVC alloc] initWithNibName:nil bundle:nil];
    tabBar.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    
    ExampleConfigVC *config = [[ExampleConfigVC alloc] initWithNibName:nil bundle:nil];
    config.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    
    ExampleActionsVC *actions = [[ExampleActionsVC alloc] initWithNibName:nil bundle:nil];
    actions.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    
    _tabBarController = [[JTabBarController alloc] initWithTabBar:tabBarView andDockPosition:JTabBarDockBottom];
    _tabBarController.delegate = self;
    _tabBarController.childViewControllers = @[ tabBar, actions, config];
    _tabBarController.selectedIndex = 1;
    [self addChildViewController:_tabBarController];
    [self.view addSubview:_tabBarController.view];
    [_tabBarController didMoveToParentViewController:self];
    
    ExampleSettings *settings = [ExampleSettings sharedSettings];
    [settings initializeDefaultsWithTabBarController:_tabBarController];
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

- (UIButton *)tabBarController:(JTabBarController *)tabBarController tabBarButtonForChildViewController:(UIViewController *)childViewController forIndex:(NSInteger)index {
    
    // this will only execute if the childViewController do not provide a jTabBarButton
    return [[NSBundle mainBundle] loadNibNamed:@"AltMainButtonTemplate" owner:self options:nil][0];;
}

@end
