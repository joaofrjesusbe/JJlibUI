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

@interface ExampleTabbarConfigVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segOrientation;

@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue1;
@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue2;
@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue3;
@property (weak, nonatomic) IBOutlet UIView *containerCheckBoxValue4;

@property (strong, nonatomic) JButtonMatrix *buttonMatrix;

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
    NSMutableArray *array = [NSMutableArray array];
    
    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithHiddenValueAndText:@"No Scroll"];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue1 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        if (type == JButtonEventSelect) {
            self.jTabBarController.tabBar.scrollEnabled = NO;
        }
    }];

    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithHiddenValueAndText:@"Simple Scroll"];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue2 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        if (type == JButtonEventSelect) {
            self.jTabBarController.tabBar.scrollEnabled = YES;
        }
    }];

    CGFloat childSize = 120.0f;
    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithText:@"Fixed Box Scroll" value:childSize];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue3 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        if (type == JButtonEventSelect) {
            [self.jTabBarController.tabBar setScrollEnabledWithChildSize:childSize];
        }
    }];

    CGFloat childItems = 3.5;
    checkBox = [CheckBoxValue checkBoxValue];
    [checkBox setupCheckBoxWithText:@"Items Box Scroll" value:childItems];
    [array addObject:checkBox.checkButton];
    [self.containerCheckBoxValue4 addSubview:checkBox];
    [checkBox.checkButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
        if (type == JButtonEventSelect) {
            [self.jTabBarController.tabBar setScrollEnabledWithChildSize:childItems];
        }
    }];

    self.buttonMatrix = [[JButtonMatrix alloc] init];
    self.buttonMatrix.buttonsArray = array;
}

- (void)viewWillAppear:(BOOL)animated {
    self.segOrientation.selectedSegmentIndex = [self indexForDocking:self.jTabBarController.tabBarDock];
    
}

- (IBAction)changeOrientation:(id)sender {
    self.jTabBarController.tabBarDock = [self dockingForIndex:self.segOrientation.selectedSegmentIndex];
}

@end
