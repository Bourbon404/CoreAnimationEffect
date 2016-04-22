//
//  MySlider.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/22.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "MySlider.h"

@interface MySlider ()
{
    CGFloat angle;
    CGFloat radius;
    CGFloat minAngle;
    CGFloat maxAngle;
}
@end
@implementation MySlider

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        radius = 200;
        minAngle = M_PI_4;
        maxAngle = M_PI_4 * 3;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setTransform:CGAffineTransformMakeRotation(M_PI_4)];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(ref, self.center.x, self.center.y, radius, minAngle, angle, YES);
    CGContextSetStrokeColorWithColor(ref, [UIColor purpleColor].CGColor);
    CGContextSetLineWidth(ref, 1);
    CGContextStrokePath(ref);
    
    CGContextSaveGState(ref);
    
    [self drawControl:ref];
    
}
-(void)drawControl:(CGContextRef)ctx
{
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGPoint point = [self controlLoaction:angle];
    CGContextAddArc(ctx, point.x, point.y, 10, 0, M_PI * 2, YES);
    CGContextFillPath(ctx);
    CGContextSaveGState(ctx);
}
-(CGPoint)controlLoaction:(CGFloat)r
{
    CGFloat tmp = radius - 10;
    CGFloat x = cosf(r)*tmp;
    CGFloat y = sinf(r)*tmp;
    CGPoint result = CGPointMake(self.center.x + x, self.center.y + y);
    return result;
}
-(void)moveControl:(CGPoint)point
{
    CGFloat change = atan2f(point.y - self.center.y, point.x - self.center.x);
    if (change < 0) {
        change = change + M_PI * 2;
    }
    if (change > M_PI_4 && change < M_PI_4 * 3) {
        
    }else{
        angle = change;
    }
    
    
    [self setNeedsDisplay];
}
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint point = [touch locationInView:self];
    
    [self moveControl:point];
    [self sendActionsForControlEvents:(UIControlEventValueChanged)];
    
    return YES;
}
-(CGFloat)value
{
    CGFloat tmp = 100 * angle / M_PI /2.0;
    if (tmp < 0) {
        tmp = 100 + tmp;
    }
    return tmp;
}
@end
