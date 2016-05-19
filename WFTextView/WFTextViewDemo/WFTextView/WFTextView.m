//
//  WFTextView.m
//  Paternity
//
//  Created by 开发者 on 15/7/23.
//  Copyright (c) 2015年 @HaiNa. All rights reserved.
//

#import "WFTextView.h"
#import "UIView+WFExtension.h"

@interface WFTextView ()
/** 占位符Label */
@property (nonatomic, weak) UILabel *placeHolderLabel;
@end

@implementation WFTextView


#pragma mark ------<占位文体Set方法>
/**
 *  设置占位文字
 *
 *  @param placeHolderText 文字内容
 */
- (void)setPlaceHolderText:(NSString *)placeHolderText {
    _placeHolderText = placeHolderText;
    _placeHolderLabel.text = placeHolderText;
}

#pragma mark ------<重写设置文本方法>
/**
 *  重写设置文本方法
 *
 *  @param text 文本
 */
- (void)setText:(NSString *)text {
    [super setText:text];
    NSNotification *notification = [NSNotification notificationWithName:UITextViewTextDidChangeNotification object:self];
    [self textChanged:notification];
}

#pragma mark ------<监听通知>
/**
 *  监听通知，显示/隐藏占位文字
 *
 *  @param notification 通知
 */
- (void)textChanged:(NSNotification *)notification {
    if(notification.object != self) return;
    
    NSString *toBeString = self.text;
    NSString *lang = self.textInputMode.primaryLanguage; // 键盘输入模式
    /** 记录当前光标位置 */
    NSRange locationRange = [self selectedRange];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制

        if (!position) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 2;// 字体的行间距
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize],
                                         NSParagraphStyleAttributeName:paragraphStyle,
                                         NSForegroundColorAttributeName:self.textColor?self.textColor:[UIColor blackColor]
                                         };
            self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
            
            if (_maxLength > 0 && toBeString.length > _maxLength) {
                self.attributedText = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, _maxLength)];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:self.textColor?self.textColor:[UIColor blackColor]
                                     };
        self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
        
        if (_maxLength > 0 && toBeString.length > _maxLength) {
            self.attributedText = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, _maxLength)];
        }
    }
    /** 恢复光标位置 */
    self.selectedRange = locationRange;
    
    /** 占位符控制 */
    if(self.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }
    else {
        _placeHolderLabel.hidden = NO;
    }
    
    /** 更改自身高度适应文字 */
    CGFloat expectHeight = self.contentSize.height - 4;
    if(expectHeight <= 15 + self.font.pointSize * 5) {
        CGRect dstFrame = self.frame;
        if(_autoChangeHeight) {
            self.height = expectHeight;
        }
        else {
            dstFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, expectHeight);
        }
        if([self.delegate respondsToSelector:@selector(textView:shouldChangeFrame:)]) {
            [self.delegate textView:self shouldChangeFrame:dstFrame];
        }
    }
    else {
        self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
    }
    return;
}

#pragma mark ------<增加占位符>
/**
 *  增加占位符
 */
- (void)addPlaceHolderLabel {
    /** 增加占位符 */
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.textColor = [UIColor grayColor];
    placeHolderLabel.font = [UIFont systemFontOfSize:(self.font?self.font.pointSize:12)];
    [self addSubview:placeHolderLabel];
    _placeHolderLabel = placeHolderLabel;
    /** 监听输入通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    self.contentInset = UIEdgeInsetsMake(-2, 0, 0, 0);
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [_placeHolderLabel setFont:font];
}

- (instancetype)init {
    
    if(self = [super init]) {
        [self addPlaceHolderLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        [self addPlaceHolderLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder]) {
        [self addPlaceHolderLabel];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _placeHolderLabel.frame = CGRectMake(8, 2, self.frame.size.width - 5, 30);
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    _placeHolderLabel.frame = CGRectMake(8, 2, self.frame.size.width - 5, 30);
}

#pragma mark ------<删除通知>
/**
 *  注销时删除通知
 */
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
