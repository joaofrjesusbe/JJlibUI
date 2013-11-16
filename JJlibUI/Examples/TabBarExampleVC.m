//
//  TabBarExampleVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 26/10/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "TabBarExampleVC.h"
#import "JUILib.h"


@interface TabBarExampleVC ()

@property (weak, nonatomic) IBOutlet JTabBarView *horizontalTabBar;
@property (weak, nonatomic) IBOutlet JTabBarView *verticalTabBar;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (nonatomic, strong) IBOutlet UIButton *btnTemplate;

@end

@implementation TabBarExampleVC

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
    JButtonSelectionBlock verticalBlockWhenSelect = ^(UIButton *button, JButtonEventType type ) {
        if (type == JButtonEventSelect) {
            NSInteger horizontalIndex = self.horizontalTabBar.selectedIndex;
            self.indexLabel.text = [NSString stringWithFormat:@"%d - %d", horizontalIndex, button.selectionIndex];
        }
    };
    
    JButtonSelectionBlock horizontalBlockWhenSelect = ^(UIButton *button, JButtonEventType type ) {
        if (type == JButtonEventSelect) {
     
            NSMutableArray *verticalViewsArray = [NSMutableArray array];
            for (int i=0; i<5; i++) {
                
                UIButton *tabButton = [[NSBundle mainBundle] loadNibNamed:@"ButtonTemplate" owner:self options:nil][0];
                [tabButton setTitle:[NSString stringWithFormat:@"Btn %d", i] forState:UIControlStateNormal];
                tabButton.blockSelectionAction = verticalBlockWhenSelect;
                [verticalViewsArray addObject:tabButton];
                
                // random change a frame
                CGRect frame = tabButton.frame;
                frame.size.width += arc4random_uniform(100);
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
        tabButton.blockSelectionAction = horizontalBlockWhenSelect;
        [tabViewsArray addObject:tabButton];
    }
    
    self.verticalTabBar.alignment = JBarViewAlignmentVertical;
    [self.verticalTabBar setScrollEnabledWithChildSize:90];
    self.verticalTabBar.centerTabBarOnSelect = YES;
    self.verticalTabBar.alwaysCenterTabBarOnSelect = YES;
    self.verticalTabBar.imageSeparator = [UIImage imageNamed:@"imageSeparatorVertical"];
    self.verticalTabBar.backgroundImage = [UIImage imageNamed:@"backgroundBar"];
    
    self.horizontalTabBar.alignment = JBarViewAlignmentHorizontal;
    [self.horizontalTabBar setScrollEnabledWithNumberOfChildsVisible:4.5];
    self.horizontalTabBar.childEdges = UIEdgeInsetsMake(4, 4, 4, 4);
    self.horizontalTabBar.centerTabBarOnSelect = YES;
    self.horizontalTabBar.imageSeparator = [UIImage imageNamed:@"imageSeparatorHorizontal"];
    self.horizontalTabBar.backgroundImage = [UIImage imageNamed:@"backgroundBar"];
    self.horizontalTabBar.childViews = tabViewsArray;
    self.horizontalTabBar.selectedIndex = 0;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
