//
//  SettingsExample.m
//  JJlibUI
//
//  Created by Joao Jesus on 11/02/14.
//  Copyright (c) 2014 Joao Jesus. All rights reserved.
//

#import "ExampleSettings.h"

@interface ExampleSettings ()

@property(nonatomic, readwrite, strong) JTabBarController *tabBarController;

@end


@implementation ExampleSettings

+ (instancetype)sharedSettings {
    
    static ExampleSettings *_sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSettings = [[ExampleSettings alloc] init];
    });
    
    return _sharedSettings;
}

- (void)initializeDefaultsWithTabBarController:(JTabBarController *)tabBarController {
    self.tabBarController = tabBarController;
    
    self.hiddenTabBar = JTabBarAnimationSlide;
    self.defaultVCTransition = JTabBarAnimationCrossDissolve;
    self.nonDefaultVCTransition = JTabBarAnimationNone;
    
    self.scrollPolicyIndex = 0;
}

@dynamic defaultVCTransition;
- (JTabBarAnimation)defaultVCTransition {
    return self.tabBarController.defaultSelectedControllerAnimation;
}

-(void)setDefaultVCTransition:(JTabBarAnimation)defaultVCTransition {
    self.tabBarController.defaultSelectedControllerAnimation = defaultVCTransition;
}

@end
