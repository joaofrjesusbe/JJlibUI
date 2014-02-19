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
#import "ExampleAnimConfigVC.h"
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
    
    [self.jTabBarController setSelectedIndex:0 animation:[ExampleSettings sharedSettings].nonDefaultVCTransition completion:nil];
}

- (IBAction)changeVCsByCode:(id)sender {
    
    if (self.usingOriginalVCs) {
        
        ExampleTabBarVC *tabBar = [[ExampleTabBarVC alloc] initWithNibName:nil bundle:nil];
        
        ExampleAnimConfigVC *config = [[ExampleAnimConfigVC alloc] initWithNibName:nil bundle:nil];
        
        // remove our custom button so a default delegate is created
        self.backupButton = self.jTabBarButton;
        self.jTabBarButton = nil;
        
        self.backupVCs = self.jTabBarController.childViewControllers;
        self.usingOriginalVCs = NO;
        
        NSArray * childViewControllers = @[ tabBar, self, config];
        
        [self.jTabBarController setChildViewControllers:childViewControllers animation:[ExampleSettings sharedSettings].nonDefaultVCTransition completion:nil];
        
    } else {

        self.jTabBarButton = self.backupButton;
        self.usingOriginalVCs = YES;
        
        [self.jTabBarController setChildViewControllers:self.backupVCs animation:[ExampleSettings sharedSettings].nonDefaultVCTransition completion:nil];

    }
}


- (IBAction)toggleHiddenTabBar:(id)sender {
    
    [self.jTabBarController setHiddenTabBar:!self.jTabBarController.hiddenTabBar animation:[ExampleSettings sharedSettings].hiddenTabBar completion:nil];
}

@end
