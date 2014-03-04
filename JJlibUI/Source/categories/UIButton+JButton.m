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

static const NSString *KEY_ASSOC_JButtonEventDeselect = @"JButton.JButtonEventDeselect";
static const NSString *KEY_ASSOC_JButtonEventSelect = @"JButton.JButtonEventSelect";
static const NSString *KEY_ASSOC_JButtonEventReselect = @"JButton.JButtonEventReselect";
static const NSString *KEY_ASSOC_JButtonEventTouchUpInside = @"JButton.JButtonEventTouchUpInside";
static const NSString *KEY_ASSOC_SelectionIndex = @"JButton.selectionIndex";

#pragma mark - private

-(NSMutableArray *)blockSelectionActionsForEvent:(JButtonEventType)event {
    
    NSMutableArray* blocks = nil;
    switch (event) {
        case JButtonEventTouchUpInside:
            blocks = (NSMutableArray *)objc_getAssociatedObject(self, &KEY_ASSOC_JButtonEventTouchUpInside);
            break;
        case JButtonEventSelect:
            blocks = (NSMutableArray *)objc_getAssociatedObject(self, &KEY_ASSOC_JButtonEventSelect);
            break;
        case JButtonEventReselect:
            blocks = (NSMutableArray *)objc_getAssociatedObject(self, &KEY_ASSOC_JButtonEventReselect);
            break;
        case JButtonEventDeselect:
            blocks = (NSMutableArray *)objc_getAssociatedObject(self, &KEY_ASSOC_JButtonEventDeselect);
            break;
            
        default:
            break;
    }
    
    if (blocks == nil) {
        blocks = [NSMutableArray array];
    }
    return blocks;
}

-(void)setBlockSelectionActions:(NSMutableArray *)blockSelectionActions forEvent:(JButtonEventType)event {
    
    if ( blockSelectionActions.count == 0 ) {
        blockSelectionActions = nil;
    }
    
    switch (event) {
        case JButtonEventTouchUpInside:
            objc_setAssociatedObject(self, &KEY_ASSOC_JButtonEventTouchUpInside, blockSelectionActions, OBJC_ASSOCIATION_RETAIN);
            if (blockSelectionActions) {
                [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        case JButtonEventSelect:
            objc_setAssociatedObject(self, &KEY_ASSOC_JButtonEventSelect, blockSelectionActions, OBJC_ASSOCIATION_RETAIN);
            break;
        case JButtonEventReselect:
            objc_setAssociatedObject(self, &KEY_ASSOC_JButtonEventReselect, blockSelectionActions, OBJC_ASSOCIATION_RETAIN);
            break;
        case JButtonEventDeselect:
            objc_setAssociatedObject(self, &KEY_ASSOC_JButtonEventDeselect, blockSelectionActions, OBJC_ASSOCIATION_RETAIN);
            break;
            
        default:
            break;
    }
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

- (void)addBlockSelectionAction:(JButtonSelectionBlock)action forEvent:(JButtonEventType)event {
    if (action) {
        NSMutableArray *blocks = [self blockSelectionActionsForEvent:event];
        [blocks addObject:action];
        [self setBlockSelectionActions:blocks forEvent:event];
    }
}

- (void)removeBlockSelectionAction:(JButtonSelectionBlock)action forEvent:(JButtonEventType)event {
    if (action) {
        NSMutableArray *blocks = [self blockSelectionActionsForEvent:event];
        [blocks removeObject:action];
        [self setBlockSelectionActions:blocks forEvent:event];
    } else {
        [self setBlockSelectionActions:nil forEvent:event];
    }
}

- (void)removeAllBlocks {
    [self setBlockSelectionActions:nil forEvent:JButtonEventTouchUpInside];
    [self setBlockSelectionActions:nil forEvent:JButtonEventDeselect];
    [self setBlockSelectionActions:nil forEvent:JButtonEventSelect];
    [self setBlockSelectionActions:nil forEvent:JButtonEventReselect];
}

- (void)performBlockSelectionForEvent:(JButtonEventType)event {
    NSMutableArray *blocks = [self blockSelectionActionsForEvent:event];
    for (JButtonSelectionBlock eventBlock in blocks) {
        eventBlock(self, event);
    }
}

- (void)onTouchUpInside:(UIButton *)sender {
    [self performBlockSelectionForEvent:JButtonEventTouchUpInside];
}

@end
