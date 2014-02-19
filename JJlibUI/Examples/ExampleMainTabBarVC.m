//
//  TabBarControllerExampleVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 30/11/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
//

#import "ExampleMainTabBarVC.h"
#import "ExampleTabBarVC.h"
#import "ExampleAnimConfigVC.h"
#import "ExampleActionsVC.h"
#import "ExampleTabbarConfigVC.h"
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
    JTabBarView *tabBarView = [[JTabBarView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
    tabBarView.backgroundImage = [UIImage imageNamed:@"blackHorizontalBar"];

    ExampleTabBarVC *tabBar = [[ExampleTabBarVC alloc] initWithNibName:nil bundle:nil];
    tabBar.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    
    ExampleAnimConfigVC *animConfig = [[ExampleAnimConfigVC alloc] initWithNibName:nil bundle:nil];
    animConfig.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];

    ExampleTabbarConfigVC *tabbarConfig = [[ExampleTabbarConfigVC alloc] initWithNibName:nil bundle:nil];
    tabbarConfig.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];

    ExampleActionsVC *actions = [[ExampleActionsVC alloc] initWithNibName:nil bundle:nil];
    actions.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MoreStoryboard" bundle:nil];
    UIViewController *more = [sb instantiateInitialViewController];
    more.jTabBarButton = [[NSBundle mainBundle] loadNibNamed:@"MainButtonTemplate" owner:self options:nil][0];
    
    _tabBarController = [[JTabBarController alloc] initWithTabBar:tabBarView andDockPosition:JTabBarDockBottom];
    _tabBarController.delegate = self;
    _tabBarController.childViewControllers = @[tabBar, animConfig, tabbarConfig, actions, more];
    _tabBarController.selectedIndex = 1;
    [self addChildViewController:_tabBarController];
    [self.view addSubview:_tabBarController.view];
    [_tabBarController didMoveToParentViewController:self];
    
    ExampleSettings *settings = [ExampleSettings sharedSettings];
    [settings initializeDefaultsWithTabBarController:_tabBarController];
    
    //self.tabBarController.tabBar.centerTabBarOnSelect = YES;
    //self.tabBarController.tabBar.alwaysCenterTabBarOnSelect = YES;
}

#pragma mark - JTabBarControllerDelegate

- (UIButton *)tabBarController:(JTabBarController *)tabBarController tabBarButtonForChildViewController:(UIViewController *)childViewController forIndex:(NSInteger)index {
    
    // this will only execute if the childViewController do not provide a jTabBarButton
    return [[NSBundle mainBundle] loadNibNamed:@"AltMainButtonTemplate" owner:self options:nil][0];;
}

@end
