//
//  SettingsExample.h
//  JJlibUI
//
//  Created by Joao Jesus on 11/02/14.
//  Copyright (c) 2014 Joao Jesus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUILib.h"

@interface ExampleSettings : NSObject

+ (instancetype)sharedSettings;

- (void)initializeDefaultsWithTabBarController:(JTabBarController *)tabBarController;

@property(nonatomic, readonly) JTabBarController *tabBarController;

@property(nonatomic, assign) JTabBarAnimation hiddenTabBar;
@property(nonatomic, assign) JTabBarAnimation defaultVCTransition;
@property(nonatomic, assign) JTabBarAnimation nonDefaultVCTransition;

@property(nonatomic, assign) NSInteger scrollPolicyIndex;

@end
