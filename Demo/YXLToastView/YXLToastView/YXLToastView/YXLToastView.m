//
//  YXLToastView.m
//  YXLToastView
//
//  Created by yingxl1992 on 2017/6/8.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "YXLToastView.h"
#import "YXLToastContentView.h"

@interface YXLToastView ()

@property (nonatomic, strong) YXLToastContentView *contentView;
@property (nonatomic, assign) BOOL cancelled;

@end

@implementation YXLToastView

+ (instancetype)sharedToastView {
    
    static YXLToastView *sharedToastView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedToastView = [[YXLToastView alloc] initWithFrame:CGRectZero];
    });
    
    return sharedToastView;
}

- (void)showMessage:(NSString *)message {
    
    [self showMessage:message withImage:nil];
}

- (void)showMessage:(NSString *)message withImage:(NSString *)imageName {
    
    if (_contentView) {
        [self hideToastView];
    }
    
    self.contentView = [[YXLToastContentView alloc] initWithMessage:message imageName:imageName];
    [self showToastView];
}

- (void)showToastView {
    
    UIView *parentView = [[[UIApplication sharedApplication] windows] lastObject];
    [parentView addSubview:_contentView];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:parentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:parentView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
    
    [UIView animateWithDuration:0.2 animations:^{
        [_contentView layoutIfNeeded];
    }];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToastView) object:nil];
    [self performSelector:@selector(hideToastView) withObject:nil afterDelay:1.5];
}

- (void)hideToastView {
    [UIView animateWithDuration:0.2 animations:^{
        [_contentView removeFromSuperview];
    }];
}

@end
