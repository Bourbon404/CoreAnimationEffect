//
//  PopAnimation.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/21.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "PopAnimation.h"

@interface PopAnimation ()
@property (nonatomic,strong) id<UIViewControllerContextTransitioning>transitionContext;
@end
@implementation PopAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
//    CATransition *tr = [CATransition animation];
//    tr.type = @"cube";
//    tr.subtype = @"fromLeft";
//    tr.duration = duration;
//    tr.removedOnCompletion = NO;
//    tr.fillMode = kCAFillModeForwards;
//    tr.delegate = self;
//    [containerView.layer addAnimation:tr forKey:nil];
//    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    }completion:^(BOOL finished) {
        
        // 当你的动画执行完成，这个方法必须要调用，否则系统会认为你的其余任何操作都在动画执行过程中。
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

//    [UIView beginAnimations:@"View Flip" context:nil];
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
//    [UIView commitAnimations];//提交UIView动画
//    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];

}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}
@end
