//
//  NavigationController.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/21.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "NavigationController.h"
#import "NavigationInteractiveTransition.h"
@interface NavigationController ()<UIGestureRecognizerDelegate>
@property (nonatomic,weak) UIPanGestureRecognizer *popRecognizer;
@property (nonatomic,strong) NavigationInteractiveTransition *navT;
@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    
    _navT = [[NavigationInteractiveTransition alloc] initWithViewController:self];
    [popRecognizer addTarget:_navT action:@selector(handleControllerPop:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];

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
