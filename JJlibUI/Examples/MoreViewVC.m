//
//  MoreViewVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 09/12/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
//

#import "MoreViewVC.h"
#import "JUILib.h"
#import "TabBarExampleVC.h"
#import "BarViewExampleVC.h"


@interface MoreViewVC ()

@end

@implementation MoreViewVC

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
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)changeTabByCode:(id)sender {
    self.jTabBarController.selectedIndex = 0;
}

- (IBAction)changeVCsByCode:(id)sender {
    
    TabBarExampleVC *example1 = [[TabBarExampleVC alloc] initWithNibName:nil bundle:nil];
    example1.tabBarItem.title = @"TabBar";
    
    BarViewExampleVC *example2 = [[BarViewExampleVC alloc] initWithNibName:nil bundle:nil];
    example2.tabBarItem.title = @"BarView";
    
    // remove our custom button so a default delegate is created
    self.jTabBarButton = nil;
    
    self.jTabBarController.childViewControllers = @[
                                               example1,
                                               self,
                                               example2
                                               ];
    
    self.jTabBarController.selectedIndex = 1;
    
}

@end
