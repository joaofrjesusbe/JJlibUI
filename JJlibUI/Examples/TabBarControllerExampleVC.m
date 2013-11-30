//
//  TabBarControllerExampleVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 30/11/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
//

#import "TabBarControllerExampleVC.h"
#import "TabBarExampleVC.h"
#import "JUILib.h"

@interface TabBarControllerExampleVC ()

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
    
    _tabBarController = [[JTabBarController alloc] initWithTabBarSize:44 andDockPosition:JTabBarDockLeft];
    _tabBarController.childViewControllers = @[
                                               [[TabBarExampleVC alloc] initWithNibName:nil bundle:nil],
                                               [[TabBarExampleVC alloc] initWithNibName:nil bundle:nil],
                                               [[TabBarExampleVC alloc] initWithNibName:nil bundle:nil]
                                               ];
    [self addChildViewController:_tabBarController];
    [self.view addSubview:_tabBarController.view];
    [_tabBarController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
