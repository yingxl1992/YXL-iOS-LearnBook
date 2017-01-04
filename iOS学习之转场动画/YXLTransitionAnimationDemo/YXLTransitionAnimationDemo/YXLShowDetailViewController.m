//
//  YXLShowDetailViewController.m
//  YXLTransitionAnimationDemo
//
//  Created by yingxl1992 on 16/12/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "YXLShowDetailViewController.h"
#import "YXLDismissTransition.h"
#import "ViewController.h"

@interface YXLShowDetailViewController ()
<
UINavigationControllerDelegate
>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;

@end

@implementation YXLShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.delegate = self;
    
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanned:)];
    edgePanGestureRecognizer.edges = UIRectEdgeAll;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popToPreView:(id)sender {
//    [self dismissViewControllerAnimated:YES
//                             completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edgePanned:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    //计算滑动的百分比
    CGFloat progress = [gestureRecognizer translationInView:self.view].x / self.view.bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //手势开始时，初始化UIPercentDrivenInteractiveTransition动画控制器
        self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //手势滑动时，更新百分比
        [self.percentDrivenInteractiveTransition updateInteractiveTransition:progress];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded
             || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        //处理手势结束或者取消的情况
        if (progress > 0.5) {
            [self.percentDrivenInteractiveTransition finishInteractiveTransition];
        }
        else {
            [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        self.percentDrivenInteractiveTransition = nil;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if ([toVC isKindOfClass:[ViewController class]]) {
        YXLDismissTransition *transition = [[YXLDismissTransition alloc] init];
        return transition;
    }
    else {
        return nil;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if ([animationController isKindOfClass:[YXLDismissTransition class]]) {
        return self.percentDrivenInteractiveTransition;
    }
    else {
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
