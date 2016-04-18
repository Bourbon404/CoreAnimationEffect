//
//  ViewController.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/18.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "ViewController.h"
#import "CoreAnimationEffect.h"

@interface ViewController ()
{
    UIView *view;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view];
    [view setCenter:self.view.center];
    [view setBounds:CGRectMake(0, 0, 200, 200)];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self injected];
}
-(void)injected
{
    [CoreAnimationEffect animationRotateAndScaleDownUp:view];
}
@end
