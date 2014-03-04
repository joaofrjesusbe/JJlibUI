//
//  TabBarExampleVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 26/10/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "ExampleTabBarVC.h"
#import "JUILib.h"


@interface ExampleTabBarVC ()

@property (weak, nonatomic) IBOutlet JTabBarView *horizontalTabBar;
@property (weak, nonatomic) IBOutlet JTabBarView *verticalTabBar;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (nonatomic, strong) IBOutlet UIButton *btnTemplate;

@end

@implementation ExampleTabBarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"TabBar";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    JButtonSelectionBlock horizontalBlock = ^(UIButton *button, JButtonEventType type ) {
        if (type == JButtonEventSelect) {
     
            NSMutableArray *verticalViewsArray = [NSMutableArray array];
            for (int i=0; i<5; i++) {
                
                UIButton *tabButton = [[NSBundle mainBundle] loadNibNamed:@"ButtonTemplate" owner:self options:nil][0];
                [tabButton setTitle:[NSString stringWithFormat:@"Btn %d", i] forState:UIControlStateNormal];
                
                [tabButton addBlockSelectionAction:^(UIButton *button, JButtonEventType type) {
                    NSInteger horizontalIndex = self.horizontalTabBar.selectedIndex;
                    self.indexLabel.text = [NSString stringWithFormat:@"%ld - %ld", (long)horizontalIndex, (long)button.selectionIndex];
                } forEvent:JButtonEventSelect];
                
                [verticalViewsArray addObject:tabButton];
                
                
                CGRect frame = tabButton.frame;
                
                // random change a frame
                //frame.size.height += arc4random_uniform(100);
                
                // fixed size
                frame.size.height = 80;
                
                tabButton.frame = frame;
            }
            self.verticalTabBar.childViews = verticalViewsArray;
            self.verticalTabBar.selectedIndex = 0;
            
        }else if (type == JButtonEventReselect) {
            self.verticalTabBar.selectedIndex = 0;
        }
    };
    
    
    
    NSMutableArray *tabViewsArray = [NSMutableArray array];
    for (int i=0; i<10; i++) {
         UIButton *tabButton = [[NSBundle mainBundle] loadNibNamed:@"ButtonTemplate" owner:self options:nil][0];
        [tabButton setTitle:[NSString stringWithFormat:@"Btn %d", i] forState:UIControlStateNormal];
        [tabButton addBlockSelectionAction:horizontalBlock forEvent:JButtonEventSelect];
        [tabButton addBlockSelectionAction:horizontalBlock forEvent:JButtonEventReselect];
        [tabViewsArray addObject:tabButton];
    }
    
    self.verticalTabBar.alignment = JBarViewAlignmentVertical;
    self.verticalTabBar.scrollEnabled = YES;
    self.verticalTabBar.autoResizeChilds = NO;
    self.verticalTabBar.centerTabBarOnSelect = YES;
    self.verticalTabBar.alwaysCenterTabBarOnSelect = YES;
    self.verticalTabBar.imageSeparator = [UIImage imageNamed:@"blueVerticalSeparator"];
    self.verticalTabBar.backgroundImage = [UIImage imageNamed:@"blueHorizontalBar"];
    
    self.horizontalTabBar.alignment = JBarViewAlignmentHorizontal;
    [self.horizontalTabBar setScrollEnabledWithNumberOfChildsVisible:4.5];
    self.horizontalTabBar.childEdges = UIEdgeInsetsMake(4, 4, 4, 4);
    self.horizontalTabBar.centerTabBarOnSelect = YES;
    self.horizontalTabBar.imageSeparator = [UIImage imageNamed:@"blueHorizontalSeparator"];
    self.horizontalTabBar.backgroundImage = [UIImage imageNamed:@"blueHorizontalBar"];
    self.horizontalTabBar.childViews = tabViewsArray;
    self.horizontalTabBar.selectedIndex = 0;
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
