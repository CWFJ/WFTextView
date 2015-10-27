//
//  WFTextView.h
//  Paternity
//
//  Created by 开发者 on 15/7/23.
//  Copyright (c) 2015年 @HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFTextView;

@protocol WFTextViewDelegate <UITextViewDelegate>

- (void)textView:(WFTextView *)textView shouldChangeFrame:(CGRect)suitableFrame;

@end


@interface WFTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeHolderText;
/** 最大文字长度 */
@property (nonatomic, assign) NSInteger maxLength;
/** 重写系统代理 */
@property (nonatomic, weak) id<WFTextViewDelegate> delegate;
@end
