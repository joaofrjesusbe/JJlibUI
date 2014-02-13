//
//  BarViewExampleVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 09/12/13.
//  Copyright (c) 2013 Joao Jesus. All rights reserved.
//

#import "ExampleConfigVC.h"
#import "JUILib.h"
#import "ExampleSettings.h"

@interface ExampleConfigVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segAnimHiddenTabbar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segAnimDefaultTrans;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segAnimOtherTrans;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segOrientation;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ExampleConfigVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Config";
    }
    return self;
}

#pragma mark - Converter Animation

- (NSInteger)indexForAnimation:(JTabBarAnimation)animation {
    switch (animation) {
        case JTabBarAnimationCrossDissolve:
            return 1;

        case JTabBarAnimationSlide:
            return 2;

        default:
            return 0;
    }
}

- (JTabBarAnimation)animationForIndex:(NSInteger)index {
    switch (index) {
        case 1:
            return JTabBarAnimationCrossDissolve;
            
        case 2:
            return JTabBarAnimationSlide;
            
        default:
            return JTabBarAnimationNone;
    }
}

#pragma mark - Converter Orientation

- (JTabBarDock)dockingForIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return JTabBarDockTop;
        case 1:
            return JTabBarDockLeft;
        case 2:
            return JTabBarDockBottom;
        case 3:
            return JTabBarDockRight;
            
        default:
            return JTabBarDockBottom;
    }
}

- (NSInteger)indexForDocking:(NSInteger)index {
    switch (index) {
        case JTabBarDockTop:
            return 0;
        case JTabBarDockLeft:
            return 1;
        case JTabBarDockBottom:
            return 2;
        case JTabBarDockRight:
            return 3;
            
        default:
            return 3;
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.segAnimDefaultTrans.selectedSegmentIndex = [self indexForAnimation:[ExampleSettings sharedSettings].defaultVCTransition];
    self.segAnimOtherTrans.selectedSegmentIndex = [self indexForAnimation:[ExampleSettings sharedSettings].nonDefaultVCTransition];
    self.segAnimHiddenTabbar.selectedSegmentIndex = [self indexForAnimation:[ExampleSettings sharedSettings].hiddenTabBar];
    
    self.segOrientation.selectedSegmentIndex = [self indexForDocking:self.jTabBarController.tabBarDock];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.scrollView setContentSizeWithMarginSize:CGSizeMake(10, 10)];
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

#pragma mark - IBActions

- (IBAction)changeAnimHiddenTabbar:(id)sender {
    [ExampleSettings sharedSettings].hiddenTabBar = [self animationForIndex:self.segAnimHiddenTabbar.selectedSegmentIndex];
}

- (IBAction)changeAnimDefaultTrans:(id)sender {
    [ExampleSettings sharedSettings].defaultVCTransition = [self animationForIndex:self.segAnimDefaultTrans.selectedSegmentIndex];
}

- (IBAction)changeAnimOtherTrans:(id)sender {
    [ExampleSettings sharedSettings].nonDefaultVCTransition = [self animationForIndex:self.segAnimOtherTrans.selectedSegmentIndex];
}

- (IBAction)changeOrientation:(id)sender {
    self.jTabBarController.tabBarDock = [self dockingForIndex:self.segOrientation.selectedSegmentIndex];
}

@end
