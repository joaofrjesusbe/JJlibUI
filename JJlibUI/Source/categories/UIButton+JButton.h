//
//  UIButton+JButton.h
//  JJlibUI
//
//  Created by Joao Jesus on 25/10/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  Specific events to UIButton when using JButtonMatrix
 */
typedef NS_ENUM(short, JButtonEventType) {
    /**
     *  Event as same as UIControlEventTouchUpInside. This will execute automatically when add a block selection action with this event.
     */
    JButtonEventTouchUpInside,
    /**
     *  Event when the button pass from selection to normal.
     */
    JButtonEventDeselect,
    /**
     *  Event when the button pass from normal to selection.
     */
    JButtonEventSelect,
    /**
     *  Event when the button is selected and is press again.
     */
    JButtonEventReselect
};

/**
 *  Block executed when an event of selection occurs.
 *
 *  @param UIButton*        button that receives the event
 *  @param JButtonEventType type of the event
 */
typedef void (^JButtonSelectionBlock)(UIButton* button, JButtonEventType type);

/**
 *  Category that add's extra functionality on button with this framework.
 */
@interface UIButton (JButton)

/**
 *  Index of the UIButton when is inside a JButtonMatrix.
 *  Default: NSNotFound
 */
@property(nonatomic,assign) NSInteger selectionIndex;



- (void)addBlockSelectionAction:(JButtonSelectionBlock)action forEvent:(JButtonEventType)event;

- (void)removeBlockSelectionAction:(JButtonSelectionBlock)action forEvent:(JButtonEventType)event;

- (void)removeAllBlocks;

- (void)performBlockSelectionForEvent:(JButtonEventType)type;

@end
