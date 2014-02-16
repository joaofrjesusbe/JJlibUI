//
//  UIButton+JButton.m
//  JJlibUI
//
//  Created by Joao Jesus on 25/10/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "UIButton+JButton.h"
#import <objc/runtime.h>


@implementation UIButton (JButton)

static const NSString *KEY_ASSOC_BlockSelectionAction = @"JButton.blockSelectionActions";
static const NSString *KEY_ASSOC_SelectionIndex = @"JButton.selectionIndex";

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

@dynamic blockSelectionActions;
-(NSMutableArray *)blockSelectionActions {
    NSArray* blocks = (NSArray *)objc_getAssociatedObject(self, &KEY_ASSOC_BlockSelectionAction);
    if (blocks == nil) {
        blocks = @[];
    }
    return [blocks mutableCopy];
}

-(void)setBlockSelectionActions:(NSMutableArray *)blockSelectionActions {
    
    if ( blockSelectionActions != nil || blockSelectionActions.count > 0 ) {
        objc_setAssociatedObject(self, &KEY_ASSOC_BlockSelectionAction, [blockSelectionActions copy], OBJC_ASSOCIATION_RETAIN);
    } else {
        objc_setAssociatedObject(self, &KEY_ASSOC_BlockSelectionAction, nil, OBJC_ASSOCIATION_RETAIN);
        [self removeObserver:self forKeyPath:@"selection"];
    }
}

- (void)addBlockSelectionAction:(JButtonSelectionBlock)action {
    if (action) {
        NSMutableArray *blocks = self.blockSelectionActions;
        [blocks addObject:action];
        [self setBlockSelectionActions:blocks];
    }
}

- (void)removeBlockSelectionAction:(JButtonSelectionBlock)action {
    if (action) {
        NSMutableArray *blocks = self.blockSelectionActions;
        [blocks removeObject:action];
        [self setBlockSelectionActions:blocks];
    }
}

- (void)removeAllBlocks {
    [self setBlockSelectionActions:nil];
}

- (void)performBlockSelectionForEvent:(JButtonEventType)type {
    NSArray* blocks = [self blockSelectionActions];
    for (JButtonSelectionBlock eventBlock in blocks) {
        eventBlock(self, type);
    }
}

@end
