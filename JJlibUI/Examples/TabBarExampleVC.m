//
//  TabBarExampleVC.m
//  JJlibUI
//
//  Created by Joao Jesus on 26/10/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "TabBarExampleVC.h"
#import "JUILib.h"

#define LoadXibView(xibName) [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil][0]
#define LoadXibViewAtPos(xibName,position) [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil][position]
#define ColorHexRGBA(r,g,b,a) [UIColor colorWithRed:((r)/256.0f) green:((g)/256.0f) blue:((b)/256.0f) alpha:a]

@interface TabBarExampleVC ()

@property (weak, nonatomic) IBOutlet JTabBarView *tabBar;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

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
    
    JButtonSelectionBlock blockWhenSelect = ^(UIButton *button, JButtonEventType type ) {
        if (type == JButtonEventSelect) {
            self.indexLabel.text = [NSString stringWithFormat:@"%d", button.selectionIndex];
        }else if (type == JButtonEventReselect) {
            self.indexLabel.text = [NSString stringWithFormat:@"Re %d", button.selectionIndex];
        }else if (type == JButtonEventDeselect) {
            
        }
    };
    
    NSMutableArray *tabViewsArray = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        UIButton *tabButton = LoadXibViewAtPos(@"TabBarExampleVC",1);
        [tabButton setTitle:[NSString stringWithFormat:@"Btn %d", i] forState:UIControlStateNormal];
        tabButton.blockSelectionAction = blockWhenSelect;
        [tabViewsArray addObject:tabButton];
        
        // random change a frame
        CGRect frame = tabButton.frame;
        frame.size.width += arc4random_uniform(100);
        tabButton.frame = frame;
    }
    
    //self.tabBar.autoResizeChilds = NO;
    self.tabBar.alignment = JBarViewAlignmentHorizontal;
    //self.tabBar.scrollEnabled = YES;
    [self.tabBar setScrollEnabledWithNumberOfChildsVisible:4.5];
    //[self.tabBar setScrollEnabledWithChildSize:90];
    self.tabBar.childEdges = UIEdgeInsetsMake(4, 4, 4, 4);
    self.tabBar.centerTabBarOnSelect = YES;
    self.tabBar.alwaysCenterTabBarOnSelect = NO;
    self.tabBar.imageSeparator = (self.tabBar.alignment == JBarViewAlignmentHorizontal ?
                                  [UIImage imageNamed:@"imageSeparatorHorizontal"] :
                                  [UIImage imageNamed:@"imageSeparatorVertical"]);
    self.tabBar.backgroundImage = [UIImage imageNamed:@"backgroundBar"];
    self.tabBar.childViews = tabViewsArray;
    self.tabBar.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
