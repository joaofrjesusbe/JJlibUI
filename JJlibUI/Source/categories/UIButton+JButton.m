//
//  UIButton+JButton.m
//  JJlibUI
//
//  Created by Joao Jesus on 25/10/13.
//  Copyright (c) JJApps. All rights reserved.
//

#import "UIButton+JButton.h"
#import <objc/runtime.h>

@implementation UIButton (JButton)

static const NSString *KEY_ASSOC_BlockSelectionAction = @"JButton.blockSelectionAction";
static const NSString *KEY_ASSOC_SelectionIndex = @"JButton.selectionIndex";

@dynamic blockSelectionAction;
-(JButtonSelectionBlock)blockSelectionAction {
    JButtonSelectionBlock block = (JButtonSelectionBlock)objc_getAssociatedObject(self, &KEY_ASSOC_BlockSelectionAction);
    return block;
}

-(void)setBlockSelectionAction:(JButtonSelectionBlock)blockSelectionAction {
    objc_setAssociatedObject(self, &KEY_ASSOC_BlockSelectionAction, blockSelectionAction, OBJC_ASSOCIATION_RETAIN);
}


@dynamic selectionIndex;
- (NSInteger)selectionIndex {
    NSNumber *indexNumber = (NSNumber *)objc_getAssociatedObject(self, &KEY_ASSOC_SelectionIndex);
    if (indexNumber == nil) {
        return NSNotFound;
    }else
        return [indexNumber integerValue];
}

- (void)setSelectionIndex:(NSInteger)selectionIndex {
    NSNumber *indexNumber = [NSNumber numberWithInteger:selectionIndex];
    objc_setAssociatedObject(self, &KEY_ASSOC_SelectionIndex, indexNumber, OBJC_ASSOCIATION_RETAIN);
}



@end
