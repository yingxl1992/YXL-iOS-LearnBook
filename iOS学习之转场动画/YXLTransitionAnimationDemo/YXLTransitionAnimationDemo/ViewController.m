//
//  ViewController.m
//  YXLTransitionAnimationDemo
//
//  Created by yingxl1992 on 16/12/28.
//  Copyright © 2016年 yingxl1992. All rights reserved.
//

#import "ViewController.h"
#import "YXLCollectionViewCell.h"
#import "YXLShowDetailViewController.h"
#import "YXLMagicMoveTransition.h"
#import "YXLDismissTransition.h"

@interface ViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
//UIViewControllerTransitioningDelegate
UINavigationControllerDelegate
>

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(200, 200);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    self.mainCollectionView.collectionViewLayout = flowLayout;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"YXLCollectionViewCell" bundle:nil]
              forCellWithReuseIdentifier:@"YXLCollectionViewCell"];
    
    NSMutableArray *tmpImageArray = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i++) {
        NSString *image = [[NSString alloc] initWithFormat:@"transitionAnimation0%ld.jpg", i];
        [tmpImageArray addObject:image];
    }
    self.imageArray = tmpImageArray.copy;
    
    [self.mainCollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXLCollectionViewCell"
                                                                            forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:[NSBundle mainBundle]];
    
    YXLShowDetailViewController *detailViewController = (YXLShowDetailViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"YXLShowDetailViewController"];
    
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
    
//    detailViewController.transitioningDelegate = self;
//    [self presentViewController:detailViewController
//                       animated:YES
//                     completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if ([toVC isKindOfClass:[YXLShowDetailViewController class]]) {
        YXLMagicMoveTransition *transition = [[YXLMagicMoveTransition alloc] init];
        return transition;
    }
    else {
        
        YXLDismissTransition *transition = [[YXLDismissTransition alloc] init];
        return transition;
    }
}

//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    YXLMagicMoveTransition *transition = [[YXLMagicMoveTransition alloc] init];
//    return transition;
//}
//
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    YXLDismissTransition *transition = [[YXLDismissTransition alloc] init];
//    return transition;
//}

@end
