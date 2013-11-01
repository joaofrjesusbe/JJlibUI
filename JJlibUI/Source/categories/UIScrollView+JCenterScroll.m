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
    [self setContentOffset:CGPointMake(x, y) animated:animated];

}

@end
