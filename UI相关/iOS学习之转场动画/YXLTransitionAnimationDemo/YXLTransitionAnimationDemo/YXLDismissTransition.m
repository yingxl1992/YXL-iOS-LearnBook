//
//  YXLDismissTransition.m
//  YXLTransitionAnimationDemo
//
//  Created by yingxl1992 on 16/12/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLDismissTransition.h"
#import "ViewController.h"
#import "YXLShowDetailViewController.h"
#import "YXLCollectionViewCell.h"

@implementation YXLDismissTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    YXLShowDetailViewController *fromViewController = (YXLShowDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toViewController = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    toViewController.view.alpha = 0;
    [containerView addSubview:toViewController.view];
    
    YXLCollectionViewCell *cell = (YXLCollectionViewCell *)[toViewController.mainCollectionView cellForItemAtIndexPath:[[toViewController.mainCollectionView indexPathsForSelectedItems] firstObject]];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         [containerView layoutIfNeeded];
                         toViewController.view.alpha = 1.0;
                         fromViewController.detailImageView.frame = [containerView convertRect:cell.frame fromView:cell.superview];
                     }
                     completion:^(BOOL finished) {
                         [fromViewController.view removeFromSuperview];
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
