//
//  YXLToastContentView.m
//  YXLToastView
//
//  Created by yingxl1992 on 2017/6/8.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "YXLToastContentView.h"

@interface YXLToastContentView ()

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *imageName;

@end

@implementation YXLToastContentView

- (instancetype)initWithMessage:(NSString *)message imageName:(NSString *)imageName {
    
    self = [super init];
    
    if (self) {
        
        self.message = message;
        self.imageName = imageName;
        
        self.backgroundColor = [UIColor redColor];
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    if (_message.length > 0
        && _imageName.length > 0) {
        
        [self setupMessageLabelAndImageView];
    }
    else if (_message.length > 0
             && _imageName.length == 0) {
        
    }
}

- (void)setupMessageLabelAndImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageName]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:30]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:55]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:55]];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:14.0];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.text = _message;
    [self addSubview:messageLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:imageView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:15]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:-30]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:30]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:-30]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:300]];
}

@end
