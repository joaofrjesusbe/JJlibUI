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

@property (weak, nonatomic) IBOutlet JBarView *barView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.barView.alignment = JBarViewAlignmentVertical;
    self.barView.autoResizeChilds = NO;
    
    self.segAnimDefaultTrans.selectedSegmentIndex = [self indexForAnimation:[ExampleSettings sharedSettings].defaultVCTransition];
    self.segAnimOtherTrans.selectedSegmentIndex = [self indexForAnimation:[ExampleSettings sharedSettings].nonDefaultVCTransition];
    self.segAnimHiddenTabbar.selectedSegmentIndex = [self indexForAnimation:[ExampleSettings sharedSettings].hiddenTabBar];
}

- (IBAction)changeAnimHiddenTabbar:(id)sender {
    [ExampleSettings sharedSettings].hiddenTabBar = [self animationForIndex:self.segAnimHiddenTabbar.selectedSegmentIndex];
}

- (IBAction)changeAnimDefaultTrans:(id)sender {
    [ExampleSettings sharedSettings].defaultVCTransition = [self animationForIndex:self.segAnimDefaultTrans.selectedSegmentIndex];
}

- (IBAction)changeAnimOtherTrans:(id)sender {
    [ExampleSettings sharedSettings].nonDefaultVCTransition = [self animationForIndex:self.segAnimOtherTrans.selectedSegmentIndex];
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
