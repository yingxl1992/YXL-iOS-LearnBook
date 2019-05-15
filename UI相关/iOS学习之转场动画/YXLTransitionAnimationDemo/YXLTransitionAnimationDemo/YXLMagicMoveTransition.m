//
//  YXLMagicMoveTransition.m
//  YXLTransitionAnimationDemo
//
//  Created by yingxl1992 on 16/12/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLMagicMoveTransition.h"
#import "ViewController.h"
#import "YXLShowDetailViewController.h"
#import "YXLCollectionViewCell.h"
#import <Accelerate/Accelerate.h>

@implementation YXLMagicMoveTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    ViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    YXLShowDetailViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    YXLCollectionViewCell *cell = (YXLCollectionViewCell *)[fromViewController.mainCollectionView cellForItemAtIndexPath:[[fromViewController.mainCollectionView indexPathsForSelectedItems] firstObject]];
    
    UIImage *snapImage = [self boxblurImage:cell.imageView.image
                             withBlurNumber:0.5];
    UIImageView *snapView = [[UIImageView alloc] initWithImage:snapImage];
    snapView.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];

    cell.imageView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.detailImageView.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:snapView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         [containerView layoutIfNeeded];
                         toViewController.view.alpha = 1.0;
                         snapView.frame = [containerView convertRect:toViewController.view.frame
                                                            fromView:toViewController.view.superview];
                     }
                     completion:^(BOOL finished) {
                         toViewController.detailImageView.hidden = NO;
                         cell.imageView.hidden = NO;
                         [snapView removeFromSuperview];
                         toViewController.detailImageView.image = snapImage;
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
    
}

- (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
