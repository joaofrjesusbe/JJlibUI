//
//  JTabBarView.m
//  JJlibUI
//
//  Created by Joao Jesus on 10/21/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "JTabBarView.h"
#import "UIScrollView+JCenterScroll.h"
#import "JButtonMatrix.h"


@interface JTabBarView ()

@property(nonatomic,readwrite) JButtonMatrix *associatedButtonMatrix;
@property(nonatomic,assign) BOOL needsUpdateScroll;
@property(nonatomic,assign) BOOL needsAnimateSelection;

@end


@implementation JTabBarView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupJTabBarView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupJTabBarView];
    }
    return self;
}

- (void)setupJTabBarView {
    _associatedButtonMatrix = [[JButtonMatrix alloc] init];
    self.needsAnimateSelection = NO;
    self.needsUpdateScroll = NO;
}


#pragma mark - override super properties

- (void)setChildViews:(NSArray *)childViews {
    
    if (childViews == nil) {
        childViews = @[];
    }
    
    for (UIButton *button in self.associatedButtonMatrix.buttonsArray) {
        [button removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    }
    
    NSMutableArray *childsButtons = [NSMutableArray arrayWithCapacity:childViews.count];
    for (UIButton *button in childViews) {
        [button addTarget:self action:@selector(actionSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [childsButtons addObject:button];
    }
    
    self.associatedButtonMatrix.buttonsArray = childsButtons;
    
    if (self.scrollEnabled) {
        self.needsUpdateScroll = YES;
    }
    
    [super setChildViews:childViews];
}


#pragma mark - public properties

@dynamic selectedTabBar;
- (UIButton *)selectedTabBar {
    return self.associatedButtonMatrix.selectedButton;
}

- (void)setSelectedTabBar:(UIButton *)selectedTabBar {
    if (selectedTabBar != self.selectedTabBar) {
        self.associatedButtonMatrix.selectedButton = selectedTabBar;
        [self setNeedsLayout];
    }
}

@dynamic selectedIndex;
- (NSInteger)selectedIndex {
    return self.associatedButtonMatrix.selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex != self.selectedIndex) {
        self.associatedButtonMatrix.selectedIndex = selectedIndex;
        [self setNeedsLayout];
    }
}

- (void)setCenterTabBarOnSelect:(BOOL)centerTabBarOnSelect {
    
    if (_centerTabBarOnSelect != centerTabBarOnSelect) {
        self.needsUpdateScroll = YES;
    }
    
    _centerTabBarOnSelect = centerTabBarOnSelect;
    
    if (centerTabBarOnSelect && !self.scrollEnabled ) {
        self.scrollEnabled = YES;
    }
}


#pragma mark - public actions

- (void)setSelectedTabBar:(UIButton *)selectedTabBar animated:(BOOL)animated {
    self.needsAnimateSelection = animated;
    self.selectedTabBar = selectedTabBar;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    self.needsAnimateSelection = animated;
    self.selectedIndex = selectedIndex;
}

#pragma mark - private actions

- (void)actionSelectedButton:(UIButton *)button {
    [self positionButton:button animated:YES];
}

- (void)positionButton:(UIButton *)button animated:(BOOL)animated {
    if ( self.centerTabBarOnSelect || self.alwaysCenterTabBarOnSelect ) {
        [_scrollContainer scrollRectToCenter:button.frame animated:animated];
    } else {
        [_scrollContainer scrollRectToVisible:button.frame animated:animated];
    }
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];

    NSArray *viewsArray = _scrollContainer.subviews;
    CGRect bounds = self.bounds;
    if ( self.needsUpdateScroll && viewsArray.count > 0 ) {

        NSArray * buttonsArray = self.associatedButtonMatrix.buttonsArray;
        CGRect minRect = ((UIView *)buttonsArray[0]).frame;
        CGRect maxRect = ((UIView *)buttonsArray[buttonsArray.count-1]).frame;
        
        if ( self.alwaysCenterTabBarOnSelect ) {
            
            if ( self.alignment == JBarViewAlignmentHorizontal ) {
                CGFloat minDelta = bounds.size.width/2.0f - minRect.size.width/2.0f;
                CGFloat maxDelta = bounds.size.width/2.0f - maxRect.size.width/2.0f;
                for (UIView *subView in viewsArray) {
                    CGRect frame = subView.frame;
                    frame.origin.x += minDelta;
                    subView.frame = frame;
                }
                CGSize size = _scrollContainer.contentSize;
                size.width += minDelta + maxDelta;
                _scrollContainer.contentSize = size;

            }else if ( self.alignment == JBarViewAlignmentVertical ) {
                CGFloat minDelta = bounds.size.height/2.0f - minRect.size.height/2.0f;
                CGFloat maxDelta = bounds.size.height/2.0f - maxRect.size.height/2.0f;
                for (UIView *subView in viewsArray) {
                    CGRect frame = subView.frame;
                    frame.origin.y += minDelta;
                    subView.frame = frame;
                }
                CGSize size = _scrollContainer.contentSize;
                size.height += minDelta + maxDelta;
                _scrollContainer.contentSize = size;
                
            }
        }
    }
    
    if ( self.selectedTabBar ) {
        [self positionButton:self.selectedTabBar animated:self.needsAnimateSelection];
    }
    
    self.needsAnimateSelection = NO;
    self.needsUpdateScroll = NO;
}

@end
