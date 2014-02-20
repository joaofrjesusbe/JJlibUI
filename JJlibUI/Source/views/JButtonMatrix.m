//
//  JButtonMatrix.m
//  JJlibUI
//
//  Created by Joao Jesus on 10/20/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "JButtonMatrix.h"

@interface JButtonMatrix ()

@end

@implementation JButtonMatrix

- (id)init {
    self = [super init];
    if (self) {
        _buttonsArray = @[];
        _selectedButton = nil;
    }
    return self;
}

#pragma mark  - public methods

- (void)setButtonsArray:(NSArray *)buttonsArray
{
    for (UIButton *button in _buttonsArray) {
        [button removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (buttonsArray == nil) {
        _buttonsArray = @[];
        _selectedButton = nil;
    } else {
        _buttonsArray = [buttonsArray copy];
        NSInteger i = 0;
        for (UIButton *button in _buttonsArray) {
            button.selectionIndex = i;
            i++;
        }
    }
    
    for (UIButton *button in _buttonsArray) {
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setSelectedButton:(UIButton *)selectedButton
{
    [self pressedButton:selectedButton];
}

@dynamic selectedIndex;
- (NSInteger)selectedIndex {
    UIButton *selection = self.selectedButton;
    if (selection) {
        return self.selectedButton.selectionIndex;
    }else {
        return NSNotFound;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (selectedIndex == NSNotFound) {
        self.selectedButton = nil;
        return;
    }
    
    if (selectedIndex < 0 || selectedIndex >= _buttonsArray.count) {
        [NSException raise:@"Invalid selected index" format:@"Selection index %ld is invalid", (long)selectedIndex];
        return;
    }
    self.selectedButton = _buttonsArray[selectedIndex];
}

#pragma mark - action

- (void)pressedButton:(UIButton *)sender
{   
    UIButton *previousSelected = self.selectedButton;
    if ( previousSelected == sender ) {
        if ( self.allowNoSelection ) {
            _selectedButton.selected = NO;
            _selectedButton = nil;
            [sender performBlockSelectionForEvent:JButtonEventDeselect];
        } else {
            [sender performBlockSelectionForEvent:JButtonEventReselect];
        }
        return;
    }
    
    BOOL allowSelection = YES;
    if ( [self.delegate respondsToSelector:@selector(buttonMatrix:willSelectButton:forIndex:)] ) {
        allowSelection = [self.delegate buttonMatrix:self willSelectButton:sender forIndex:sender.selectionIndex];
    }
    
    if ( !allowSelection ) {
        return;
    }
    
    _selectedButton.selected = NO;
    _selectedButton = sender;
    _selectedButton.selected = YES;
    
    [previousSelected performBlockSelectionForEvent:JButtonEventDeselect];
    [sender performBlockSelectionForEvent:JButtonEventSelect];
    
    if ( [self.delegate respondsToSelector:@selector(buttonMatrix:didSelectButton:forIndex:)] ) {
        [self.delegate buttonMatrix:self didSelectButton:_selectedButton forIndex:_selectedButton.selectionIndex];
    }
}

@end
