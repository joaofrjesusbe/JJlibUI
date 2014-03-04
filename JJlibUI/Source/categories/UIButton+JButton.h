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
     *  Event when the button pass from selection to normal (Only if is inside a JButtonMatrix).
     */
    JButtonEventDeselect,
    /**
     *  Event when the button pass from normal to selection (Only if is inside a JButtonMatrix).
     */
    JButtonEventSelect,
    /**
     *  Event when the button is selected and is press again (Only if is inside a JButtonMatrix).
     */
    JButtonEventReselect
};

/**
 *  Block executed when an event JButtonEventType occurs.
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

/**
 *  Adds a execution block for a JButtonEventType
 */
- (void)addBlockSelectionAction:(JButtonSelectionBlock)action forEvent:(JButtonEventType)event;

/**
 *  Removes a block from an event.
 *  Setting the parameter action to nil will remove all blocks for that event.
 *
 */
- (void)removeBlockSelectionAction:(JButtonSelectionBlock)action forEvent:(JButtonEventType)event;

/**
 *  Removes all blocks from all events.
 */
- (void)removeAllBlocks;

/**
 *  Executes all blocks for a specific event.
 */
- (void)performBlockSelectionForEvent:(JButtonEventType)type;

@end
