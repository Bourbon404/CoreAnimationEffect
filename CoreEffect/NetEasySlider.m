//
//  NetEasySlider.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/22.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "NetEasySlider.h"
#define kTroughImage [UIImage imageNamed:@"cm2_efc_knob_trough_prs"]    //中心圆形
#define kNeedleImage [UIImage imageNamed:@"cm2_efc_knob_needle_prs"]    //中间指针
#define kScaleImage  [UIImage imageNamed:@"cm2_efc_knob_scale"]         //中间灰色进度条

@interface NetEasySlider ()
{
    UIImageView *needleView;
    //半径
    CGFloat radius;
    //当前角度
    CGFloat angle;
}
@end
@implementation NetEasySlider

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        needleView = [[UIImageView alloc] initWithImage:kNeedleImage];
        needleView.bounds = CGRectMake(0, 0, kNeedleImage.size.width, kNeedleImage.size.height);
        needleView.center = self.center;
        [self addSubview:needleView];
        
        radius = kScaleImage.size.width/2-1;
        angle = M_PI;
        
        self.backgroundColor = [UIColor clearColor];
        //旋转坐标系
        self.transform = CGAffineTransformMakeScale(1, -1);
    }
    return self;
}
-(void)dealloc
{
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //绘制背景图片
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ref, CGRectMake((self.frame.size.width-kScaleImage.size.width)/2.0, (self.frame.size.height-kScaleImage.size.height)/2.0, kScaleImage.size.width, kScaleImage.size.height), kScaleImage.CGImage);
    CGContextDrawImage(ref, CGRectMake((self.frame.size.width-kTroughImage.size.height)/2.0, (self.frame.size.height-kTroughImage.size.width)/2.0, kTroughImage.size.width, kTroughImage.size.height), kTroughImage.CGImage);
    //绘制红色进度条
    CGContextAddArc(ref, self.center.x, self.center.y, radius, M_PI, angle, YES);
    CGContextSetLineWidth(ref, 2);
    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
    CGContextStrokePath(ref);
    //指针根据角度进行旋转
    needleView.transform = CGAffineTransformMakeRotation(angle+M_PI_2);

}
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    return [super beginTrackingWithTouch:touch withEvent:event];
}
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint point = [touch locationInView:self];
    CGFloat change  = atan2f(point.y-self.center.y, point.x-self.center.x);
    if (change >= 0) {
        angle = change;
        self.currentValue = (self.maxValue - self.minValue)*(angle+M_PI)/M_PI;
        [self sendActionsForControlEvents:(UIControlEventValueChanged)];
    }
    [self setNeedsDisplay];
    return YES;
}
@end
