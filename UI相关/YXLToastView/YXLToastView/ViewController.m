//
//  ViewController.m
//  YXLToastView
//
//  Created by yingxl1992 on 2017/6/8.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "ViewController.h"
#import "YXLToastView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *toastButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [toastButton addTarget:self
                    action:@selector(clickToastButton)
          forControlEvents:UIControlEventTouchUpInside];
    [toastButton setTitle:@"Click Me To Toast~" forState:UIControlStateNormal & UIControlStateSelected];
    [self.view addSubview:toastButton];
    
    toastButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:toastButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:200]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:toastButton
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:200]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:toastButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:60]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:toastButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:20]];
}

- (void)clickToastButton {
    
    [[YXLToastView sharedToastView] showMessage:@"Test Toast!"
                                      withImage:@"dailog_failure"];
}

@end
