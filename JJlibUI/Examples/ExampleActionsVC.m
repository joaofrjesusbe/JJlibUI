//
//  MoreViewVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 09/12/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
//

#import "ExampleActionsVC.h"
#import "JUILib.h"
#import "ExampleTabBarVC.h"
#import "ExampleConfigVC.h"
#import "ExampleSettings.h"


@interface ExampleActionsVC ()

@property(nonatomic,strong) NSArray *backupVCs;
@property(nonatomic,strong) UIButton *backupButton;
@property(nonatomic,assign) BOOL usingOriginalVCs;

@property (weak, nonatomic) IBOutlet JBarView *barView;

@end

@implementation ExampleActionsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Actions";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.usingOriginalVCs = YES;
    
    self.barView.alignment = JBarViewAlignmentVertical;
    self.barView.autoResizeChilds = NO;
}

- (IBAction)changeTabByCode:(id)sender {
    
    //self.jTabBarController.selectedIndex = 0;  // nonAnimation
    [self.jTabBarController setSelectedIndex:0 animation:[ExampleSettings sharedSettings].nonDefaultVCTransition completion:nil];
}

- (IBAction)changeVCsByCode:(id)sender {
    
    if (self.usingOriginalVCs) {
        
        ExampleTabBarVC *tabBar = [[ExampleTabBarVC alloc] initWithNibName:nil bundle:nil];
        
        ExampleConfigVC *config = [[ExampleConfigVC alloc] initWithNibName:nil bundle:nil];
        
        // remove our custom button so a default delegate is created
        self.backupButton = self.jTabBarButton;
        self.jTabBarButton = nil;
        
        self.backupVCs = self.jTabBarController.childViewControllers;
        self.usingOriginalVCs = NO;
        
        NSArray * childViewControllers = @[ tabBar, self, config];
        
        // nonAnimation
        /*
        self.jTabBarController.childViewControllers = childViewControllers;
        self.jTabBarController.selectedIndex = 1;
         */
        
        [self.jTabBarController setChildViewControllers:childViewControllers animation:[ExampleSettings sharedSettings].nonDefaultVCTransition completion:nil];
        
    } else {

        self.jTabBarButton = self.backupButton;
        self.usingOriginalVCs = YES;
        
        //self.jTabBarController.childViewControllers = self.backupVCs;
        //self.jTabBarController.selectedIndex = 2;
        
        [self.jTabBarController setChildViewControllers:self.backupVCs animation:[ExampleSettings sharedSettings].nonDefaultVCTransition completion:nil];

    }
}


- (IBAction)toggleHiddenTabBar:(id)sender {
    
    //self.jTabBarController.hiddenTabBar = !self.jTabBarController.hiddenTabBar; // nonAnimation
    [self.jTabBarController setHiddenTabBar:!self.jTabBarController.hiddenTabBar animation:[ExampleSettings sharedSettings].hiddenTabBar completion:nil];
}

/*
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
 */

@end
