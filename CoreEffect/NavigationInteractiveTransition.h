//
//  NavigationInteractiveTransition.h
//  CoreEffect
//
//  Created by ZhengWei on 16/4/21.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIViewController,UIPercentDrivenInteractiveTransition;
@interface NavigationInteractiveTransition : NSObject<UINavigationControllerDelegate>
-(instancetype)initWithViewController:(UIViewController *)vc;
-(void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;
-(UIPercentDrivenInteractiveTransition *)interactivePopTransition;
@end
