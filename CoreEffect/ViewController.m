//
//  ViewController.m
//  CoreEffect
//
//  Created by ZhengWei on 16/4/18.
//  Copyright © 2016年 Bourbon. All rights reserved.
//

#import "ViewController.h"
#import "CoreAnimationEffect.h"
#import "BackView.h"
#import <CoreMotion/CoreMotion.h>
#import "UIDynamicAnimator+AAPLDebugInterfaceOnly.h"
@interface ViewController ()
{
    UIView *redView;
    UIView *purpleView;
    
    CGPoint beginPoint;
    CGPoint movePoint;
    CGPoint endPoint;
    UIPushBehavior *push;
    
    UIAttachmentBehavior *attachmentBehavior;
    
    BOOL isPushBehavior;
    
    CMMotionManager *manager;
    UIGravityBehavior *grayity;
}
@property (nonatomic,strong) UIDynamicAnimator *animator;

@end

@implementation ViewController
-(UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        [_animator setDebugEnabled:YES];
    }
    return _animator;
}
-(void)reset
{
    [self.animator removeAllBehaviors];
    [redView setFrame:CGRectMake(50, 50, 50, 50)];
}
-(void)pan:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.view];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        beginPoint = point;
        
        if (!isPushBehavior) {
            CGPoint anchor = CGPointMake(point.x, point.y);
            attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:redView attachedToAnchor:anchor];
            [self.animator addBehavior:attachmentBehavior];
        }
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        movePoint = point;
        if (!isPushBehavior) {
            [attachmentBehavior setAnchorPoint:movePoint];
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        endPoint = point;
        
        if (isPushBehavior) {
            CGPoint offset = CGPointMake(endPoint.x - beginPoint.x, endPoint.y - beginPoint.y);
            push.angle = -atan2f(offset.y, -offset.x);
            push.magnitude = sqrtf(offset.x * offset.x + offset.y * offset.y) / 50;
        }else{
            [self.animator removeBehavior:attachmentBehavior];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"1.png"];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
    UIVibrancyEffect *effect1 = [UIVibrancyEffect effectForBlurEffect:effect];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:effect1];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    [imageView setFrame:self.view.frame];
    [visualView setFrame:self.view.frame];
//    [self.view addSubview:imageView];
//    [imageView addSubview:visualView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
    [label setText:@"hello world"];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30]];
    [label setTextAlignment:(NSTextAlignmentCenter)];
//    [visualView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [visualView.contentView addSubview:label];
    [self.view addSubview:visualView];
    
//    vibrancyView.setTranslatesAutoresizingMaskIntoConstraints(false)
//    blurView.contentView.addSubview(vibrancyView)
//    var label: UILabel = UILabel()
//    label.setTranslatesAutoresizingMaskIntoConstraints(false)
//    label.text = "Vibrancy Effect"
//    label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
//    label.textAlignment = .Center
//    label.textColor = UIColor.whiteColor()
//    vibrancyView.contentView.addSubview(label)
    return;
    
    
    BackView *back = [[BackView alloc] init];
    [back setBackgroundColor:[UIColor clearColor]];
    [back setFrame:self.view.frame];
    [self.view addSubview:back];
    
    redView = [[UIView alloc] init];
    [redView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:redView];
    [redView setFrame:CGRectMake(50, 50, 50, 50)];
    
    purpleView = [[UIView alloc] init];
    [purpleView setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:purpleView];
    [purpleView setFrame:CGRectMake(50, 150, 50, 50)];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button addTarget:self action:@selector(reset) forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:@"重置" forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-60, 100, 50)];
    [self.view addSubview:button];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self snapFunction:touches];
    [self fieldBehaviorFunction];
}
//重力行为
-(void)grayityFunction
{
    grayity = [[UIGravityBehavior alloc] initWithItems:@[redView,purpleView]];
    //控制方向
//    [grayity setGravityDirection:CGVectorMake(-1, -1)];
//    [grayity setAngle:0.5];
    [self.animator addBehavior:grayity];
}
//碰撞行为
-(void)collisionFunction
{
    [self grayityFunction];
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[redView,purpleView]];
    //子view不会冲出父view
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [self.animator addBehavior:collision];
    
    manager = [[CMMotionManager alloc] init];
    
    if (manager.deviceMotionAvailable) {
        manager.deviceMotionUpdateInterval = 0.1;
        [manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            [grayity setGravityDirection:CGVectorMake(motion.gravity.x, -motion.gravity.y)];
        }];
    }
}
//指定路径内碰撞
-(void)addPathCollisionFunction
{
    [self grayityFunction];
    UICollisionBehavior *behavior = [[UICollisionBehavior alloc] initWithItems:@[redView]];
    
//    //园
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 320, 320)];
    [behavior addBoundaryWithIdentifier:@"circle" forPath:path];
    //线
//    CGPoint startP = CGPointMake(0, 160);
//    CGPoint endP = CGPointMake(320, 400);
//    CGPoint startP1 = CGPointMake(320, 0);
//    [behavior addBoundaryWithIdentifier:@"line1" fromPoint:startP toPoint:endP];
//    [behavior addBoundaryWithIdentifier:@"line2" fromPoint:startP1 toPoint:endP];
    
    [self.animator addBehavior:behavior];
}
//捕捉行为
-(void)snapFunction:(NSSet <UITouch *> *)touchs
{
    UITouch *touch = [touchs anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:redView snapToPoint:point];
    [snap setDamping:arc4random_uniform(10)/10.0];
    
    //先移除，后添加
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:snap];
}
//推动行为
-(void)pushFunction
{
    isPushBehavior = YES;
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[redView,purpleView]];
    //子view不会冲出父view
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [self.animator addBehavior:collision];
    push = [[UIPushBehavior alloc] initWithItems:@[redView,purpleView] mode:(UIPushBehaviorModeContinuous)];
    [self.animator addBehavior:push];
}
//锚点
-(void)attachmentFunction
{
    [self grayityFunction];
    isPushBehavior = NO;
}
#pragma mark iOS9新填行为
-(void)fieldBehaviorFunction
{
    [self grayityFunction];
    
    UIFieldBehavior *behavior = [UIFieldBehavior noiseFieldWithSmoothness:1.0 animationSpeed:0.5];
    [behavior addItem:redView];
    [behavior addItem:purpleView];
    [behavior setStrength:0.5];
    [self.animator addBehavior:behavior];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[redView,purpleView]];
    [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(20, 5, 5, 5)];
    [self.animator addBehavior:collision];
    
    manager = [[CMMotionManager alloc] init];
    
    if (manager.deviceMotionAvailable) {
        manager.deviceMotionUpdateInterval = 0.1;
        [manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            [grayity setGravityDirection:CGVectorMake(motion.gravity.x, -motion.gravity.y)];
        }];
    }
    
}
@end
