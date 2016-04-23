//
//  SecondViewController.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/21.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "MySlider.h"
#import "Slider.h"
#import "NetEasySlider.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    NetEasySlider *slider = [[NetEasySlider alloc] initWithFrame:self.view.frame];
    slider.minValue = 0;
    slider.maxValue = 100;
    slider.center = self.view.center;
    [slider addTarget:self action:@selector(value:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:slider];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)value:(NetEasySlider *)slider
{
//    NSLog(@"%f",slider.currentValue);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ThirdViewController *third = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:third animated:YES];
}
@end
