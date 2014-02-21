//
//  JTabBarSegue.m
//  JJlibUI
//
//  Created by João Jesus on 21/02/14.
//  Copyright (c) 2014 Joao Jesus. All rights reserved.
//

#import "JTabBarSegue.h"
#import "JTabBarController.h"


@implementation JTabBarSegue

- (void)perform {
    UIViewController *controller = self.sourceViewController;
    if ( [controller isKindOfClass:[JTabBarController class]] ) {
        JTabBarController *tabBarController = (JTabBarController *)controller;
        tabBarController.selectedTabBarChild = self.destinationViewController;
    } else {
        [super perform];
    }
}

@end
