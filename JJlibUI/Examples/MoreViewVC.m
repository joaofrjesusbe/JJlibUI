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
#import "AnimationExampleVC.h"


@interface MoreViewVC ()

@property(nonatomic,strong) NSArray *backupVCs;
@property(nonatomic,strong) UIButton *backupButton;
@property(nonatomic,assign) BOOL usingOriginalVCs;

@end

@implementation MoreViewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Advance";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.usingOriginalVCs = YES;
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
    //self.jTabBarController.selectedIndex = 0; 
    [self.jTabBarController setSelectedIndex:0 animation:JTabBarAnimationCrossDissolve completion:nil];
}

- (IBAction)changeVCsByCode:(id)sender {
    
    if (self.usingOriginalVCs) {
        
        TabBarExampleVC *example1 = [[TabBarExampleVC alloc] initWithNibName:nil bundle:nil];
        
        AnimationExampleVC *example2 = [[AnimationExampleVC alloc] initWithNibName:nil bundle:nil];
        
        // remove our custom button so a default delegate is created
        self.backupButton = self.jTabBarButton;
        self.jTabBarButton = nil;
        
        self.backupVCs = self.jTabBarController.childViewControllers;
        self.jTabBarController.childViewControllers = @[
                                                        example1,
                                                        self,
                                                        example2
                                                        ];
        
        self.jTabBarController.selectedIndex = 1;
        self.usingOriginalVCs = NO;
        
    } else {

        self.jTabBarButton = self.backupButton;
        self.jTabBarController.childViewControllers = self.backupVCs;

        self.jTabBarController.selectedIndex = 2;
        self.usingOriginalVCs = YES;
    }
}


- (IBAction)toggleHiddenTabBar:(id)sender {
    //self.jTabBarController.hiddenTabBar = !self.jTabBarController.hiddenTabBar;
    [self.jTabBarController setHiddenTabBar:!self.jTabBarController.hiddenTabBar animation:JTabBarAnimationCrossDissolve completion:nil];
}

@end
