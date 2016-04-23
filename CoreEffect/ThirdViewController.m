//
//  ThirdViewController.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/21.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "ThirdViewController.h"
#import "NetEasySlider.h"
@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
    NetEasySlider *slider = [[NetEasySlider alloc] initWithFrame:self.view.frame];
    slider.minValue = 0;
    slider.maxValue = 100;
    slider.center = self.view.center;
    [self.view addSubview:slider];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
