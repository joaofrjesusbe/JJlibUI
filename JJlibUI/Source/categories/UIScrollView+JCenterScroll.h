//
//  UIScrollView+JCenterScroll.h
//  JJlibUI
//
//  Created by Joao Jesus on 26/10/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Extra functionality to the UIScrollView.
 */
@interface UIScrollView (JCenterScroll)

/**
 *  Set the new contentOffset so the rect is in the center
 *
 *  @param rect     frame to be centered
 *  @param animated is movement animated
 */
- (void)scrollRectToCenter:(CGRect)rect animated:(BOOL)animated;

- (void)setContentSizeWithMarginSize:(CGSize)margin;

@end
