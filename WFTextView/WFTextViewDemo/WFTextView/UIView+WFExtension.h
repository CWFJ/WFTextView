//
//  UIView+WFExtension.h
//  UIView
//
//  Created by Jason on 13/6/22.
//  Copyright (c) 2013年 Jason. All rights reserved.
//  增加此分类可以对UIView的frame相关属性直接进行修改

#import <UIKit/UIKit.h>

@interface UIView (WFExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

@end
