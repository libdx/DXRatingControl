//
//  DXRatingControl.h
//  DXRatingControl
//
//  Created by Alexander Ignatenko on 8/23/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Reusable rating control with xib support.
 */
@interface DXRatingControl : UIControl

/**
 Designated initializer.

 Rating items have center alignment.
 */
- (id)initWithFrame:(CGRect)frame;

/**
 Rating value. Changes while user touches rating control.

 Use UIControlEventValueChanged for tracking rating changes
 value must be in range [0, 5]. Providing greater values will be equivalent to 5
 */
@property (nonatomic) NSUInteger rating;

/// Spacing between rating items. Default is 10 px.
@property (nonatomic) CGFloat spacing;

/// Image to be used for rating items which are not selected
@property (strong, nonatomic) UIImage *unselectedItemImage;

/// Image to be used for rating items which are selected
@property (strong, nonatomic) UIImage *selectedItemImage;

/// Image to be used for rating items whenever rating control is in unrated state (e.g. isn't touched yep by user)
@property (strong, nonatomic) UIImage *unratedItemImage;

/// Image name to be used for initializing or changing `unselectedItemImage` property. Must refer to image in main bundle.
@property (copy, nonatomic) NSString *unselectedItemImageName;

/// Image name to be used for initializing or changing `selectedItemImage`. Must refer to image in main bundle.
@property (copy, nonatomic) NSString *selectedItemImageName;

/// Image name to be used for initializing or changing `unratedItemImage` . Must refer to image in main bundle.
@property (copy, nonatomic) NSString *unratedItemImageName;

@end
