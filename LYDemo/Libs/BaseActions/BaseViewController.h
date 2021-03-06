//
//  BaseViewController.h
//  LYApp
//
//  Created by liyang on 17/7/1.
//  Copyright © 2017年 kosienDGL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>

/// 添加右滑返回手势
- (void)addPanGesture;

/// show Alert
- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message;

@end
