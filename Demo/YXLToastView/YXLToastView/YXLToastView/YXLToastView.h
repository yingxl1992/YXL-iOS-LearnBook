//
//  YXLToastView.h
//  YXLToastView
//
//  Created by yingxl1992 on 2017/6/8.
//  Copyright © 2017年 yingxl1992. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLToastView : UIView

+ (instancetype)sharedToastView;

- (void)showMessage:(NSString *)message withImage:(NSString *)imageName;

@end
