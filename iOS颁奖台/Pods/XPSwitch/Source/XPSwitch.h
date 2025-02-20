/**
 *  XPSwitch.h
 *  ShareMerge
 *
 *  Created by huangxp on 2016-01-04.
 *
 *  Copyright (c) www.sharemerge.com All rights reserved.
 */

/** @file */    // Doxygen marker

#import <UIKit/UIKit.h>

@interface XPSwitch : UIControl

@property (strong, nonatomic) UIColor *backgroundColor; // defaults to gray
@property (strong, nonatomic) UIColor *sliderColor; // defaults to white
@property (strong, nonatomic) UIColor *labelTextColorInsideSlider; // defaults to black
@property (strong, nonatomic) UIColor *labelTextColorOutsideSlider; // defaults to white
@property (strong, nonatomic) UIFont *font; // default is nil
@property (nonatomic) CGFloat cornerRadius; // defaults to 12
@property (nonatomic) CGFloat sliderOffset; // slider offset from background, top, bottom, left, right

+ (instancetype)switchWithStringsArray:(NSArray *)strings;
- (instancetype)initWithStringsArray:(NSArray *)strings;
- (instancetype)initWithAttributedStringsArray:(NSArray *)strings;

- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated; // sets the index, also calls handler block

// This method sets handler block that is getting called after the switcher is done animating the transition

- (void)setPressedHandler:(void (^)(NSUInteger index))handler;

// This method sets handler block that is getting called right before the switcher starts animating the transition

- (void)setWillBePressedHandler:(void (^)(NSUInteger index))handler;

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated; // sets the index without calling the handler block

@end
