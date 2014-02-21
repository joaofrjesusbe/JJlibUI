//
//  ExampleTabbarConfigVCViewController.m
//  JJlibUI
//
//  Created by João Jesus on 19/02/14.
//  Copyright (c) 2014 Joao Jesus. All rights reserved.
//

#import "ExampleTabbarConfigVC.h"
#import "JUILib.h"
#import "CheckBoxValue.h"
#import "ExampleSettings.h"

@interface ExampleTabbarConfigVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segOrientation;

@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue1;
@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue2;
@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue3;
@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue4;
@property (strong, nonatomic) JButtonMatrix *buttonMatrixScrollPolicy;

@property (weak, nonatomic) IBOutlet CheckBoxValue *containerCheckBoxValue5;
@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue6;
@property (strong, nonatomic) JButtonMatrix *buttonMatrixSelectPolicy;

@end

@implementation ExampleTabbarConfigVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Config";
    }
    return self;
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
            return 2;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CheckBoxValue *checkBox;
    self.buttonMatrixScrollPolicy = [[JButtonMatrix alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    
    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithHiddenValueAndText:@"No Scroll"];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue1 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        [ExampleSettings sharedSettings].scrollPolicyIndex = self.buttonMatrixScrollPolicy.selectedIndex;
        self.jTabBarController.tabBar.scrollEnabled = NO;
    } forEvent:JButtonEventSelect];
    
    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithHiddenValueAndText:@"Simple Scroll"];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue2 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        [ExampleSettings sharedSettings].scrollPolicyIndex = self.buttonMatrixScrollPolicy.selectedIndex;
        self.jTabBarController.tabBar.scrollEnabled = YES;
    } forEvent:JButtonEventSelect];

    CGFloat childSize = 120.0f;
    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithText:@"Fixed Box Scroll" value:childSize];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue3 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        [ExampleSettings sharedSettings].scrollPolicyIndex = self.buttonMatrixScrollPolicy.selectedIndex;
        [self.jTabBarController.tabBar setScrollEnabledWithChildSize:childSize];
    } forEvent:JButtonEventSelect];

    CGFloat childItems = 3.5;
    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithText:@"Items Box Scroll" value:childItems];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue4 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        [ExampleSettings sharedSettings].scrollPolicyIndex = self.buttonMatrixScrollPolicy.selectedIndex;
        [self.jTabBarController.tabBar setScrollEnabledWithNumberOfChildsVisible:childItems];
    } forEvent:JButtonEventSelect];

    self.buttonMatrixScrollPolicy.buttonsArray = array;
    
    
    self.buttonMatrixSelectPolicy = [[JButtonMatrix alloc] init];
    self.buttonMatrixSelectPolicy.allowMultipleSelection = YES;
    array = [NSMutableArray array];
    
    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithHiddenValueAndText:@"Selected Item always center"];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue5 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        [self.jTabBarController.tabBar setAlwaysCenterTabBarOnSelect:YES];
    } forEvent:JButtonEventSelect];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        [self.jTabBarController.tabBar setAlwaysCenterTabBarOnSelect:NO];
    } forEvent:JButtonEventDeselect];

    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithHiddenValueAndText:@"Selected Item centered"];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue6 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        [self.jTabBarController.tabBar setCenterTabBarOnSelect:YES];
    } forEvent:JButtonEventSelect];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        [self.jTabBarController.tabBar setCenterTabBarOnSelect:NO];
    } forEvent:JButtonEventDeselect];
    
    self.buttonMatrixSelectPolicy.buttonsArray = array;

}

- (void)viewWillAppear:(BOOL)animated {
    self.segOrientation.selectedSegmentIndex = [self indexForDocking:self.jTabBarController.tabBarDock];
    self.buttonMatrixScrollPolicy.selectedIndex = [ExampleSettings sharedSettings].scrollPolicyIndex;
}

- (IBAction)changeOrientation:(id)sender {
    self.jTabBarController.tabBarDock = [self dockingForIndex:self.segOrientation.selectedSegmentIndex];
}

@end
