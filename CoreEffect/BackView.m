//
//  BackView.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/19.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "BackView.h"

@implementation BackView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGPoint startP = CGPointMake(0, 160);
    CGPoint endP = CGPointMake(320, 400);
    CGPoint startP1 = CGPointMake(320, 0);
    
    UIColor *color = [UIColor blueColor];
    [color set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startP];
    [path addLineToPoint:endP];
    [path moveToPoint:startP1];
    [path addLineToPoint:endP];
    [path setLineWidth:1];
    [path stroke];
    
    [path addArcWithCenter:CGPointMake(160, 160) radius:320/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [path stroke];

}


@end
