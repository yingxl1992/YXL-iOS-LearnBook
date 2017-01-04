##iOS学习之转场动画


### Part1. UIViewController present UIViewController

####步骤及相关说明：

1. 自定义一个转场动画

  ```objective-c
  @interface YXLMagicMoveTransition : NSObject
  <
  UIViewControllerAnimatedTransitioning
  >
  
  @end
  ```

  **这个转场动画必须遵守`UIViewControllerAnimatedTransitioning`协议。**

  ```objective-c
  @protocol UIViewControllerAnimatedTransitioning <NSObject>

  // 返回转场动画实现的时间间隔
  - (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;

  // ！！在这个方法中实现转场动画的效果
  - (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;

  @optional

  /// A conforming object implements this method if the transition it creates can
  /// be interrupted. For example, it could return an instance of a
  /// UIViewPropertyAnimator. It is expected that this method will return the same
  /// instance for the life of a transition.
  - (id <UIViewImplicitlyAnimating>) interruptibleAnimatorForTransition:(id <UIViewControllerContextTransitioning>)transitionContext NS_AVAILABLE_IOS(10_0);

  // This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
  - (void)animationEnded:(BOOL) transitionCompleted;

  @end
  ```
  
  
  其中，`(nullable id <UIViewControllerContextTransitioning>)transitionContext`，`transitionContext`遵守了`UIViewControllerContextTransitioning`协议，提供了转场动画所需的环境，这个环境由系统提供，不能自定义。以下为该协议常用的方法。
  
  ```objective-c
  @protocol UIViewControllerContextTransitioning <NSObject>

  //获取转场动画的容器
  - (UIView *)containerView;

  //自定义动画结束时调用，不论是完成还是被取消
  - (void)completeTransition:(BOOL)didComplete;


  // 获取toViewController和fromViewController
  // key的取值：UITransitionContextToViewControllerKey、UITransitionContextFromViewControllerKey
  - (nullable __kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key;

  //获取toVC和fromVC的初始frame和最终frame(fromVC必为CGRectZero)
  - (CGRect)initialFrameForViewController:(UIViewController *)vc;
  - (CGRect)finalFrameForViewController:(UIViewController *)vc;
  @end
  ```

2. 实现转场动画
   `- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;`
  `- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;`
  
  只有这两个方法是必要的。
  
  ```
  - (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}
  ```
  
  ```
  - (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //1、获取转场前的VC
    ViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //2、获取转场后的VC
    YXLShowDetailViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //3、containerView作为转场过程中所有涉及到的页面的父View（包括toView和fromView）
    UIView *containerView = [transitionContext containerView];
    
    //4、设置或初始化转场涉及的各view的位置等
    YXLCollectionViewCell *cell = (YXLCollectionViewCell *)[fromViewController.mainCollectionView cellForItemAtIndexPath:[[fromViewController.mainCollectionView indexPathsForSelectedItems] firstObject]];
    
    UIView *snapView = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    snapView.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    cell.imageView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.detailImageView.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:snapView];
    
    //5、开始执行动画
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
                         
                         //6、执行完成后调用completeTransition
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];                         
                     }];
  }
  ```
  
3. 设置present动画

  ```objective-c
  @interface ViewController ()
  <
  UICollectionViewDelegate,
  UICollectionViewDataSource,
  UIViewControllerTransitioningDelegate
  >

  @end
  ```
  
  **fromViewController需要遵守[`UIViewControllerTransitioningDelegate`](https://developer.apple.com/reference/uikit/uiviewcontrollertransitioningdelegate)协议**
  
  ```objective-c
  @protocol UIViewControllerTransitioningDelegate <NSObject>

  @optional
  //返回一个转场动画
  - (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

  - (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

  //返回一个交互式的转场动画
  - (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;

  - (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;

  - (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0);

  @end
  ```
  
  - 实现代理方法，返回2中实现的转场动画
  
    ```objective-c
    - (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    YXLMagicMoveTransition *transition = [[YXLMagicMoveTransition alloc] init];
    return transition;
  }
    ```
  
  - 在跳转时设置transitioningDelegate
  
  ```objective-c
  YXLShowDetailViewController *detailViewController = (YXLShowDetailViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"YXLShowDetailViewController"];
    detailViewController.transitioningDelegate = self;
    [self presentViewController:detailViewController
                       animated:YES
                     completion:nil];
  ```
  
4. 设置dismiss动画
  
  同步骤1、2设置自定义的dimiss动画效果，在此时的toViewController中，即上述的fromViewController中设置代理方法，返回对应的转场动画。
  
  ```objective-c
  - (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    YXLDismissTransition *transition = [[YXLDismissTransition alloc] init];
    return transition;
}
  ```

####涉及的协议小结

1. `UIViewControllerAnimatedTransitioning`实现自定义转场动画——**动画控制器(Animation Controller)**
2. `UIViewControllerContextTransitioning`提供转场上下文环境——**转场环境(Transition Context)**
3. `UIViewControllerTransitioningDelegate`提供自定义的转场动画——**转场代理(Transition Delegate)**

### Part2. UINavigationController控制转场
####步骤及相关说明
1. 同上
2. 同上
3. 设置fromViewController
  
  由于toViewController和fromViewController由UINavigationController统一管理，所以，与上述VC present VC不同的是:
  
  - fromViewController需要实现`UINavigationControllerDelegate`中的`- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC`，而不是`- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented`和`- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed`;
                                                           
  - 将`self`设置为`navigationController.delegate`

####相关协议

`UINavigationControllerDelegate`——与`UIViewControllerTransitioningDelegate`一样，属于**转场代理**

### Part3. 交互式转场

####步骤及相关说明

1. 增加交互手势，一般为`UIScreenEdgePanGestureRecognizer`
    
    ```objective-c
    
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanned:)];
    //设置滑动的方向
    edgePanGestureRecognizer.edges = UIRectEdgeAll;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
    
    ```

2. 实现手势事件

    ```objective-c
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
    
    ```

####相关协议


-
2016-12-18 by YXL