//
//  UIScrollView+JCenterScroll.m
//  JJlibUI
//
//  Created by Joao Jesus on 26/10/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "UIScrollView+JCenterScroll.h"

@implementation UIScrollView (JCenterScroll)

- (void)scrollRectToCenter:(CGRect)rect animated:(BOOL)animated {
    
    CGSize scrollSize = self.bounds.size;
    CGFloat x = CGRectGetMidX(rect) - ((scrollSize.width - rect.size.width) / 2.0f) - (rect.size.width / 2.0f);
    CGFloat y = CGRectGetMidY(rect) - ((scrollSize.height - rect.size.height) / 2.0f) - (rect.size.height / 2.0f);
    
    x = (x < 0 ? 0 : x);
    y = (y < 0 ? 0 : y);
    
    CGSize contentSize = self.contentSize;
    CGPoint maxContentOffset = CGPointMake(contentSize.width - scrollSize.width, contentSize.height - scrollSize.height);
    x = (x > maxContentOffset.x ? maxContentOffset.x : x);
    y = (y > maxContentOffset.y ? maxContentOffset.y : y);
    
    [self setContentOffset:CGPointMake(x, y) animated:animated];

}

@end
