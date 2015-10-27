//
//  ViewController.m
//  WFTextViewDemo
//
//  Created by Jason on 15/10/26.
//  Copyright © 2015年 raydun. All rights reserved.
//

#import "ViewController.h"
#import "WFTextView.h"

@interface ViewController () <WFTextViewDelegate>
@property (weak, nonatomic) IBOutlet WFTextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _textView.placeHolderText = @"2312321";
    _textView.delegate = self;
}

- (void)textView:(WFTextView *)textView shouldChangeFrame:(CGRect)suitableFrame {
    NSLog(@"%@", NSStringFromCGRect(suitableFrame));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
