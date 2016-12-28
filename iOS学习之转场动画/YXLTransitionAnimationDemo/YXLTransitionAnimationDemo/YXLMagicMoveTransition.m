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

@implementation YXLMagicMoveTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    ViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    YXLShowDetailViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    YXLCollectionViewCell *cell = (YXLCollectionViewCell *)[fromViewController.mainCollectionView cellForItemAtIndexPath:[[fromViewController.mainCollectionView indexPathsForSelectedItems] firstObject]];
    
    UIView *snapView = [cell.imageView snapshotViewAfterScreenUpdates:NO];
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
                         snapView.frame = [containerView convertRect:toViewController.detailImageView.frame
                                                            fromView:toViewController.detailImageView.superview];
                     }
                     completion:^(BOOL finished) {
                         toViewController.detailImageView.hidden = NO;
                         cell.imageView.hidden = NO;
                         [snapView removeFromSuperview];
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];                         
                     }];
    
}

@end
