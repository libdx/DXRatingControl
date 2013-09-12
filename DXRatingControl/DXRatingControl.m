//
//  DXRatingControl.m
//  DXRatingControl
//
//  Created by Alexander Ignatenko on 8/23/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "DXRatingControl.h"

static const NSUInteger DXMaxRating = 5;

static void setCenterY(UIView *view, CGFloat y)
{
    view.center = CGPointMake(view.center.x, y);
}

static CGFloat left(UIView *view)
{
    return view.frame.origin.x;
}

static void setLeft(UIView *view, CGFloat x)
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

static CGFloat width(UIView *view)
{
    return view.frame.size.width;
}

static CGFloat height(UIView *view)
{
    return view.frame.size.height;
}

@implementation DXRatingControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponents];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initComponents];
    }
    return self;
}

static const CGFloat DXDefaultSpacing = 10.0f;

- (void)initComponents
{
    _spacing = DXDefaultSpacing;
    self.unselectedItemImageName = @"dx-rating-control-unselected-item-default.png";
    self.selectedItemImageName = @"dx-rating-control-selected-item-default.png";
    self.unratedItemImageName = @"dx-rating-control-unrated-item-default.png";
    for (NSUInteger index = 0; index < DXMaxRating; ++index) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_unselectedItemImage
                                                   highlightedImage:_selectedItemImage];
        [self addSubview:imageView];
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    // TODO retrieve values from subviews
    CGFloat leftmost = 0;
    CGFloat rightmost = size.width;
    CGSize itemSize = size;
    return CGSizeMake(rightmost - leftmost + 2*_spacing, itemSize.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSUInteger subviewsCount = self.subviews.count;
    if (subviewsCount < 1)
        return;

    CGFloat subviewsWidth = subviewsCount * width(self.subviews[0]) + (subviewsCount - 1) * _spacing;
    CGFloat xOffset = floorf((width(self) - subviewsWidth) * 0.5f);
    // Center all image subviews
    [self enumerateImageSubviewsUsingBlock:^(UIImageView *view, NSUInteger idx, BOOL *stop) {
        setCenterY(view, floorf(height(self) * 0.5f));
        setLeft(view, idx * (width(view) + _spacing) + xOffset);
    }];
}

- (void)setSpacing:(CGFloat)spacing
{
    if (_spacing != spacing) {
        _spacing = spacing;
        [self setNeedsLayout];
    }
}

- (void)setUnselectedItemImageName:(NSString *)unselectedItemImageName
{
    if (_unselectedItemImageName != unselectedItemImageName) {
        _unselectedItemImageName = unselectedItemImageName;
        self.unselectedItemImage = [UIImage imageNamed:_unselectedItemImageName];
    }
}

- (void)setSelectedItemImageName:(NSString *)selectedItemImageName
{
    if (_selectedItemImageName != selectedItemImageName) {
        _selectedItemImageName = selectedItemImageName;
        self.selectedItemImage = [UIImage imageNamed:_selectedItemImageName];
    }
}

- (void)setUnselectedItemImage:(UIImage *)unselectedItemImage
{
    if (_unselectedItemImage != unselectedItemImage) {
        _unselectedItemImage = unselectedItemImage;
        [self enumerateImageSubviewsUsingBlock:^(UIImageView *imageView, NSUInteger index, BOOL *stop){
            imageView.image = _unselectedItemImage;
            [imageView sizeToFit];
        }];
        [self setNeedsLayout];
    }
}

- (void)setSelectedItemImage:(UIImage *)selectedItemImage
{
    if (_selectedItemImage != selectedItemImage) {
        _selectedItemImage = selectedItemImage;
        [self enumerateImageSubviewsUsingBlock:^(UIImageView *imageView, NSUInteger index, BOOL *stop){
            imageView.highlightedImage = _selectedItemImage;
            [imageView sizeToFit];
        }];
        [self setNeedsLayout];
    }
}

- (void)enumerateImageSubviewsUsingBlock:(void (^)(UIImageView *imageView, NSUInteger index, BOOL *stop))block
{
    if (block == nil)
        [NSException raise:NSInvalidArgumentException format:@"block argument must not be nil, but nil given"];

    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIImageView class]])
            block((UIImageView *)view, idx, stop);
    }];
}

- (UIView *)subviewAtLocation:(CGPoint)location
{
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, location)) {
            return view;
        }
    }
    return nil;
}

- (NSArray *)subviewsToLeftOfLocationIncluding:(CGPoint)location
{
    NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:DXMaxRating];
    for (UIView *view in self.subviews) {
        if (left(view) <= location.x)
            [views addObject:view];
    }
    return views;
}

- (void)setRating:(NSUInteger)rating
{
    if (_rating != rating) {
        _rating = rating <= DXMaxRating ? rating : DXMaxRating;
        [self enumerateImageSubviewsUsingBlock:^(UIImageView *imageView, NSUInteger index, BOOL *stop){
            index < _rating ? [imageView setHighlighted:YES] : [imageView setHighlighted:NO];
        }];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    NSArray *hitSubviews = [self subviewsToLeftOfLocationIncluding:location];
    self.rating = hitSubviews.count;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    if ([self subviewAtLocation:location] != [self subviewAtLocation:previousLocation]) {
        NSArray *hitSubviews = [self subviewsToLeftOfLocationIncluding:location];
        self.rating = hitSubviews.count;
    }
}

@end
