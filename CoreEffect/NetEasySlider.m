//
//  NetEasySlider.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/22.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "NetEasySlider.h"
#define kTroughImage [UIImage imageNamed:@"cm2_efc_knob_trough_prs"]
#define kNeedleImage [UIImage imageNamed:@"cm2_efc_knob_needle_prs"]
#define kScaleImage  [UIImage imageNamed:@"cm2_efc_knob_scale"]

@interface NetEasySlider ()
{
    UIImageView *needleView;
    CGFloat radius;
}
@end
@implementation NetEasySlider

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        frame.size = kScaleImage.size;
        self.frame = frame;
        
//        UIImageView *scaleView = [[UIImageView alloc] initWithImage:kScaleImage];
//        scaleView.bounds = CGRectMake(0, 0, kScaleImage.size.width, kScaleImage.size.height);
//        scaleView.center = self.center;
//        [self addSubview:scaleView];
//        
//        UIImageView *troughView = [[UIImageView alloc] initWithImage:kTroughImage];
//        troughView.bounds = CGRectMake(0, 0, kTroughImage.size.width, kTroughImage.size.height);
//        troughView.center = self.center;
//        [self addSubview:troughView];
//        
//        needleView = [[UIImageView alloc] initWithImage:kNeedleImage];
//        needleView.bounds = CGRectMake(0, 0, kNeedleImage.size.width, kNeedleImage.size.height);
//        needleView.center = self.center;
//        [self addSubview:needleView];
        
        radius = kScaleImage.size.width/2-1;

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextAddArc(ref, self.center.x, self.center.y, radius, M_PI_4, M_PI_4*3, YES);
    CGContextSetLineWidth(ref, 2);
    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
    CGContextStrokePath(ref);
    CGContextSaveGState(ref);
    
    
}

@end
