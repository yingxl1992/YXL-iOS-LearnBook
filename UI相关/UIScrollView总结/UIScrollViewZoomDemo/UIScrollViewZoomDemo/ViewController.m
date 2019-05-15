//
//  ViewController.m
//  UIScrollViewZoomDemo
//
//  Created by yingxl1992 on 17/1/9.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<
UIScrollViewDelegate
>

@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGPoint originCenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews {
    [self setupMainView];
    
    [self setupImageView];
}

- (void)setupMainView {
    self.mainView = [[UIScrollView alloc] init];
    self.mainView.delegate = self;
    self.mainView.minimumZoomScale = 0.5f;
    self.mainView.maximumZoomScale = 2.0f;
    self.mainView.backgroundColor = [UIColor yellowColor];
    self.mainView.showsVerticalScrollIndicator = YES;
    self.mainView.showsHorizontalScrollIndicator = YES;
//    self.mainView.contentSize = CGSizeMake(800, 800);
    [self.view addSubview:_mainView];
    
    self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:_mainView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:_mainView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:_mainView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:_mainView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:0]]];
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"transitionAnimation00.jpg"];
    [_mainView addSubview:_imageView];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_mainView addConstraints:@[[NSLayoutConstraint constraintWithItem:_imageView
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:_mainView
                                                                                     attribute:NSLayoutAttributeTop
                                                                                    multiplier:1.0
                                                                                      constant:0],
//                               [NSLayoutConstraint constraintWithItem:_imageView
//                                                            attribute:NSLayoutAttributeBottom
//                                                            relatedBy:NSLayoutRelationEqual
//                                                               toItem:_mainView
//                                                            attribute:NSLayoutAttributeBottom
//                                                           multiplier:1.0
//                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_mainView
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.0
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_mainView
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1.0
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:800],
                               [NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:800]]];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    self.originCenter = view.center;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"YXLScrollView contentOffset(x：%lf，y：%lf)", scrollView.contentOffset.x, scrollView.contentOffset.y);
    NSLog(@"YXLScrollView contentSize(width：%lf，height：%lf)", scrollView.contentSize.width, scrollView.contentSize.height);
    NSLog(@"YXLScrollView bounds（width：%lf，height：%f）", scrollView.bounds.size.width, scrollView.bounds.size.height);
    NSLog(@"YXLScrollView imageViewCenter(x：%lf，height：%lf)", _imageView.center.x, _imageView.center.y);
    [self.imageView setCenter: self.originCenter];
    NSLog(@"YXLScrollView imageViewCenter(x：%lf，height：%lf)", _imageView.center.x, _imageView.center.y);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    self.imageView.center = self.originCenter;
    NSLog(@"End YXLScrollView contentOffset(x：%lf，y：%lf)", scrollView.contentOffset.x, scrollView.contentOffset.y);
    NSLog(@"End YXLScrollView contentSize(width：%lf，height：%lf)", scrollView.contentSize.width, scrollView.contentSize.height);
    NSLog(@"End YXLScrollView bounds（width：%lf，height：%f）", scrollView.bounds.size.width, scrollView.bounds.size.height);
    NSLog(@"End YXLScrollView imageViewCenter(x：%lf，height：%lf)", _imageView.center.x, _imageView.center.y);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
