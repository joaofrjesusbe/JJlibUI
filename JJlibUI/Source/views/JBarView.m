//
//  JBarView.m
//  JJlibUI
//
//  Created by Joao Jesus on 10/20/13.
//  Copyright (c) 2013 JJApps. All rights reserved.
//

#import "JBarView.h"

@interface JBarView () <UIScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *separatorImageViews;
@property(nonatomic,strong) UIImageView *backgroundView;
@property(nonatomic,strong) UIScrollView *scrollContainer;
@property(nonatomic,assign) UIView *subViewsContainer;
@property(nonatomic,assign) CGFloat scrollBoxFixSize;
@property(nonatomic,assign) int scrollViewsCounter;
@property(nonatomic,assign) float partialViewPercentage;

@end



@implementation JBarView

@synthesize scrollContainer = _scrollContainer;

#pragma mark - Initialization

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, 320, 44)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupJBarView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupJBarView];
    }
    return self;
}

- (void)setupJBarView {
    _alignment = JBarViewAlignmentHorizontal;
    self.subViewsContainer = self;
    self.autoResizeChilds = YES;
    _childViews = @[];
    self.separatorImageViews = nil;
}


#pragma mark - public properties

@dynamic backgroundImage;
- (UIImage *)backgroundImage {
    return _backgroundView.image;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if ( backgroundImage ) {
        
        if (self.backgroundView == nil) {
            _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
            _backgroundView.contentMode = UIViewContentModeScaleToFill;
            _backgroundView.backgroundColor = [UIColor clearColor];
            _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self insertSubview:_backgroundView atIndex:0];
        }
        
        _backgroundView.image = backgroundImage;
        
    } else {
        [_backgroundView removeFromSuperview];
    }
}

- (void)setAlignment:(JBarViewAlignment)alignment {
    _alignment = alignment;
    [self setNeedsLayout];
}

- (void)setChildEdges:(UIEdgeInsets)childEdges {
    _childEdges = childEdges;
    [self setNeedsLayout];
}

- (void)setImageSeparator:(UIImage *)imageSeparator {
    if ( imageSeparator == nil || _imageSeparator != imageSeparator ) {
        for (UIImageView *separatorView in self.separatorImageViews) {
            [separatorView removeFromSuperview];
        }
    }
    
    _imageSeparator = imageSeparator;
    self.separatorImageViews = nil;
    
    [self setNeedsLayout];
}

- (void)setAutoResizeChilds:(BOOL)autoResizeChilds {
    _autoResizeChilds = autoResizeChilds;
    [self setNeedsLayout];
}

- (void)setChildViews:(NSArray *)childViews {
    
    // remove all tabViews
    for (UIView *subBarView in _childViews) {
        [subBarView removeFromSuperview];
    }
    
    for (UIImageView *separatorView in self.separatorImageViews) {
        [separatorView removeFromSuperview];
    }
    
    self.separatorImageViews = nil;
    
    // get a copy of array
    _childViews = [childViews copy];
    if (_childViews == nil) {
        _childViews = @[];
    }
    
    [self setNeedsLayout];
}


#pragma mark - scroll

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;

    if (_scrollEnabled && self.scrollContainer == nil) {
        _scrollContainer = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollContainer.backgroundColor = [UIColor clearColor];
        _scrollContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollContainer.showsHorizontalScrollIndicator = NO;
        _scrollContainer.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollContainer];
    }
    self.subViewsContainer = (_scrollEnabled ? self.scrollContainer : self );

    self.scrollViewsCounter = 0;
    self.scrollBoxFixSize = 0;

    [self setNeedsLayout];
}

- (void)setScrollEnabledWithNumberOfChildsVisible:(float)numberOfChildsVisible {
    
    NSAssert( numberOfChildsVisible > 0, @"numberOfChildsVisible must be great than 0" );
    
    self.scrollEnabled = YES;
    self.scrollViewsCounter = (int)numberOfChildsVisible;
    self.partialViewPercentage = fmodf(numberOfChildsVisible, 1.0);
    self.scrollBoxFixSize = 0;
    [self setNeedsLayout];
}

- (void)setScrollEnabledWithChildSize:(CGFloat)childsSize {
    self.scrollEnabled = YES;
    self.scrollViewsCounter = 0;
    self.scrollBoxFixSize = childsSize;
    [self setNeedsLayout];
}


#pragma mark - private methods

- (void)prepareImageSeparators {
    if ( _childViews.count > 1 && _imageSeparator && self.separatorImageViews == nil ) {
        
        _separatorImageViews = [[NSMutableArray alloc] initWithCapacity: _childViews.count - 1];
        for ( NSInteger i = 0; i < _childViews.count - 1; i++ ) {
            UIImageView *imageSeparatorView = [[UIImageView alloc] initWithImage:_imageSeparator];
            UIView *container = (self.isScrollEnabled ? _scrollContainer : self);
            [container addSubview:imageSeparatorView];
            [_separatorImageViews addObject:imageSeparatorView];
        }
    }
}

- (void)verifyChangesOfContainer {
    
    if ( _childViews.count > 0 ) {
        
        UIView *fatherView = _childViews[0];
        fatherView = fatherView.superview;
        if ( fatherView != self.subViewsContainer ) {
            
            for ( UIView *subView in _childViews ) {
                [self.subViewsContainer addSubview:subView];
            }
            
            for ( UIView *subView in self.separatorImageViews ) {
                [self.subViewsContainer addSubview:subView];
            }
        }
    }
    
    if (_scrollViewsCounter > _childViews.count) {
        _scrollViewsCounter = _childViews.count;
    }
}

- (CGRect)frameForSubBarViews {
    
    CGRect frame = CGRectZero;
    CGRect bounds = self.bounds;
    
    // CGRectNull no change in frame
    if ( self.alignment == JBarViewAlignmentNone ) {
        return CGRectNull;
    }
    
    // CGRectZero no change in size
    if ( !self.autoResizeChilds || (self.isScrollEnabled && self.scrollViewsCounter == 0 && self.scrollBoxFixSize == 0) ) {
        return CGRectZero;
    }
    
    if ( self.isScrollEnabled  && self.scrollBoxFixSize != 0 ) {
        
        switch (self.alignment) {
            case JBarViewAlignmentHorizontal:
                frame.size.width = self.scrollBoxFixSize;
                frame.size.height = bounds.size.height;
                break;
                
            case JBarViewAlignmentVertical:
                frame.size.width = bounds.size.width;
                frame.size.height = self.scrollBoxFixSize;
                break;
                
            default:
                return CGRectNull;
        }
    } else {
        
        CGFloat boxCount = _childViews.count;
        int separatorCount = boxCount - 1;
        CGSize separatorSize = _imageSeparator.size;
        CGFloat totalSpace = 0;
        
        if ( _scrollEnabled && self.scrollViewsCounter != 0 ) {
            boxCount = self.scrollViewsCounter;
            separatorCount = boxCount - 1;
            
            if (self.partialViewPercentage > 0) {
                separatorCount = boxCount;
                boxCount += self.partialViewPercentage;
            }
        }
        
        switch (_alignment) {
            case JBarViewAlignmentHorizontal:
                totalSpace = ( _imageSeparator ? bounds.size.width - separatorSize.width * separatorCount : bounds.size.width );
                frame.size.width = totalSpace / boxCount;
                frame.size.height = bounds.size.height;
                break;
                
            case JBarViewAlignmentVertical:
                totalSpace = ( _imageSeparator ? bounds.size.height - separatorSize.height * separatorCount : bounds.size.height );
                frame.size.width = bounds.size.width;
                frame.size.height = totalSpace / boxCount;
                break;
                
            default:
                return CGRectNull;
        }
        
    }
    
    return frame;
}


#pragma mark - UIView methods

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;

    [self verifyChangesOfContainer];
    
    CGRect subViewFrame = [self frameForSubBarViews];
    if (CGRectIsNull(subViewFrame)) {
        return;
    }
    
    BOOL isFixedSize = NO;
    if ( !CGRectIsEmpty(subViewFrame) ) {
        isFixedSize = YES;
        subViewFrame = UIEdgeInsetsInsetRect(subViewFrame, self.childEdges);
    }
    
    [self prepareImageSeparators];
    
    UIView *childView = nil;
    UIView *previousChildView = nil;
    for ( NSInteger i = 0; i < _childViews.count; i++ ) {
        previousChildView = childView;
        childView = _childViews[i];
        
        UIImageView *imageSeparatorView = nil;
        CGRect imageViewFrame = CGRectZero;
        if ( self.imageSeparator && i < _childViews.count - 1 ) {
            imageSeparatorView = self.separatorImageViews[i];
            imageViewFrame.size = imageSeparatorView.frame.size;
        }
        
        CGRect frame = subViewFrame;
        if ( !isFixedSize ) {
            frame = childView.frame;
            frame.origin = CGPointZero;
        }
        CGRect previousFrame = ( previousChildView == nil ? CGRectZero : previousChildView.frame );
        switch (self.alignment) {
            case JBarViewAlignmentHorizontal:
            {
                CGFloat shift = 0;
                if (isFixedSize) {
                    shift = ( previousChildView == nil ? 0 : self.childEdges.right + imageViewFrame.size.width );
                }else {
                    shift = ( previousChildView == nil ? self.childEdges.left : self.childEdges.left + self.childEdges.right + imageViewFrame.size.width );
                }
                frame.origin.x += CGRectGetMaxX(previousFrame) + shift;
                frame.origin.y = CGRectGetMidY(bounds) - frame.size.height/2.0f;
                
                if (imageSeparatorView) {
                    imageViewFrame.origin = CGPointMake( CGRectGetMaxX(frame) + self.childEdges.right , CGRectGetMidY(bounds) - imageViewFrame.size.height/2.0f);
                    imageSeparatorView.frame = imageViewFrame;
                }
            }
            break;
                
            case JBarViewAlignmentVertical:
            {
                CGFloat shift = 0;
                if (isFixedSize) {
                    shift = ( previousChildView == nil ? 0 : self.childEdges.bottom + imageViewFrame.size.height );
                }else {
                    shift = ( previousChildView == nil ? self.childEdges.top : self.childEdges.top + self.childEdges.bottom + imageViewFrame.size.height );
                }
                frame.origin.x = CGRectGetMidX(bounds) - frame.size.width/2.0f;
                frame.origin.y += CGRectGetMaxY(previousFrame) + shift;
                
                if (imageSeparatorView) {
                    imageViewFrame.origin = CGPointMake( CGRectGetMidX(bounds) - imageViewFrame.size.width/2.0f, CGRectGetMaxY(frame) + self.childEdges.bottom);
                    imageSeparatorView.frame = imageViewFrame;
                }
            }
                
            default:
                break;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(barView:layoutChild:withFrame:)] ) {
            [self.delegate barView:self layoutChild:childView withFrame:frame];
        }else {
            childView.frame = frame;
        }
    }
    _backgroundView.frame = bounds;
    
    if ( _scrollEnabled && _childViews.count > 0 ) {
        
        if ( _alignment == JBarViewAlignmentHorizontal )
            _scrollContainer.contentSize = CGSizeMake( CGRectGetMaxX(childView.frame) + self.childEdges.right, CGRectGetMaxY(bounds));
        if ( _alignment == JBarViewAlignmentVertical )
            _scrollContainer.contentSize = CGSizeMake( CGRectGetMaxX(bounds),  CGRectGetMaxY(childView.frame) + self.childEdges.bottom);
    }
}

@end



