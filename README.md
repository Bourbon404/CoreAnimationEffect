# CoreAnimationEffect
CoreAnimationEffect,几个介绍动画的实现方式，带详细注释
介绍几种动画实现方式，附带详细介绍，
更多内容欢迎访问我的博客

http://www.bourbonz.cn

===========================================
这里介绍下一个在iOS7中就出现的功能UIDynamicBehavior,

_说明_

UIDynamicBehavior是属于UIKit下的一个提供元素具备动力学的东西，能让你不着眼于复杂的物理公式，而实现多样的物理动画.具备像中重力、碰撞等行为.
使用的步骤也很简单,
>step1.  创建一个行为实现者(UIDynamicAnimator)
>step2.  创建你的行为 (UIDynamicBehavior)，系统提供了6种行为（包含iOS9中新增的）
>step3.  将行为添加到实现这种

简单的几个步骤就可以完成.
其中需要注明的是,想要实现的元素，必须遵循UIDynamicItem协议，而UIView遵循了，所以可以用UIView实现.

_UIDynamicAnimator介绍_

系统提供了两种Animator，一种是普通的，还有一种是用于UICollectionViewLayout.我们的重点在第一种上.
有如下方法是经常用到的
```
///初始化，view参数为所有元素的父视图
- (instancetype)initWithReferenceView:(UIView *)view NS_DESIGNATED_INITIALIZER;
//添加，删除一个，删除所有
- (void)addBehavior:(UIDynamicBehavior *)behavior;
- (void)removeBehavior:(UIDynamicBehavior *)behavior;
- (void)removeAllBehaviors;
```
当然还提供了一个属性来判断是否正在进行
```
@property (nonatomic, readonly, getter = isRunning) BOOL running;
```
这里需要注明的一点是，animator这个东东，需要设置成属性，或者全局变量时才能管用，不知道这个算不算坑,我是被坑了.
UIDynamicBehavior介绍
系统提供了6种行为，下面会细说.作为父类，你可以调用下面的方法，在行为进行到每个阶段时候都会调用一次
```
// When running, the dynamic animator calls the action block on every animation step.
@property (nullable, nonatomic,copy) void (^action)(void);
```
为了介绍这6种行为，我们先创建如下图的场景用于说明,具体用途后面会说明
![](http://upload-images.jianshu.io/upload_images/1025705-8e7185f9ba6e8ea5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
创建方式如下
```
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
```
_UIGravityBehavior_

这个行为负责重力相关，提供类似自由落体的功能.
方法简单，实现如下内容后就能刚看见效果
```
//重力行为
-(void)grayityFunction
{
grayity = [[UIGravityBehavior alloc] initWithItems:@[redView]];
//控制方向
//    [grayity setGravityDirection:CGVectorMake(-1, -1)];
//    [grayity setAngle:0.5];
[self.animator addBehavior:grayity];
}
```
需要提及的是
1. gravityDirection属性是一个平面中向量的概念,它定义了运行方向,在iOS中左上角才是坐标原点,向右和向下分别为正方向,这点需要注意,所以在设置中要正确设置相关值(-1,0,1)
2. angle角度,定义了在上面的变量值得基础上偏移的角度,从水平向右,向下方伸展为正方向.
3. magnitude 定义了初始运动时的力的大小.

_UICollisionBehavior_

这个行为负责在碰撞时的相关内容.先查看代码
```
//碰撞行为
-(void)collisionFunction
{
[self grayityFunction];
UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[redView,purpleView]];
//子view不会冲出父view,否则就会冲出屏幕
[collision setTranslatesReferenceBoundsIntoBoundary:YES];
[self.animator addBehavior:collision];
}
}
```
这里先调用了一次重力行为，使两个元素进行碰撞.此时就能看见效果
碰撞行为中还提供了添加路线的方法
```
- (void)addBoundaryWithIdentifier:(id <NSCopying>)identifier forPath:(UIBezierPath *)bezierPath;
- (void)addBoundaryWithIdentifier:(id <NSCopying>)identifier fromPoint:(CGPoint)p1 toPoint:(CGPoint)p2;
```
下面看下如何实现
```
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
```
这里实现了在进行碰撞后，元素按照预定好的线路进行运动，就像是给元素设置了一层外壁。这回知道我之前花的两条线是干什么的了吧^_^，起辅助观看作用.

_UISnapBehavior_

下面介绍的是捕捉行为,简单理解就是在屏幕中元素会弹跳到指定位置.需要注意的是,在进行下一个捕捉行为之前,需要移除上一个捕捉行为.提供了一个属性damping,用来表示力度大小，值的范围在0到1之间.值越大弹性效果越好
```
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
```
_UIAttachmentBehavior_

锚点行为,这个行为提供了一个元素按照锚点进行弹性伸展或者非弹性伸展的行为.实现方法也很简单,下面，先对一个元素添加重力行为,然后添加下面手势
```
-(void)pan:(UIPanGestureRecognizer *)gesture
{
CGPoint point = [gesture locationInView:self.view];
if (gesture.state == UIGestureRecognizerStateBegan) {
beginPoint = point;

CGPoint anchor = CGPointMake(point.x, point.y);
attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:redView attachedToAnchor:anchor];
[self.animator addBehavior:attachmentBehavior];


}else if (gesture.state == UIGestureRecognizerStateChanged){
movePoint = point;
[attachmentBehavior setAnchorPoint:movePoint];
}else if (gesture.state == UIGestureRecognizerStateEnded){
endPoint = point;

[self.animator removeBehavior:attachmentBehavior];

}
}
```
当看到元素下坠的时候，滑动屏幕，机会看到元素随着滑动而进行运动，就像有一个弹簧，连接着一个点和元素

_UIFieldBehavior_

下面要说的这个行为是iOS9中新增加的行为，可以理解为在使用这个行为后，系统在view上添加了一个扭曲的空间,元素在这个扭曲的空间上进行一些列运动行为.
在创建行为的时候系统提供了一些方法,这里使用下面的方法
```
UIFieldBehavior *behavior = [UIFieldBehavior noiseFieldWithSmoothness:1.0 animationSpeed:0.5];
```
给定两个值，分别代表的是光滑程度和动画的速度.
这个行为中，我们添加了一个CMMotionManager,通过这个我们可以在晃动设备的时候看到元素也在自由的运动，添加了一个碰撞行为，防止元素滑出边缘.这个行为建议在真机上运行，因为模拟器不能体验CMMotionManager.
```
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
```
我们还可以通过私有API来打开debug模式，来让我们看到这个行为的扭曲空间.
创建一个类别UIDynamicAnimator+AAPLDebugInterfaceOnly.h
```
@interface UIDynamicAnimator (AAPLDebugInterfaceOnly)
@property (nonatomic, getter=isDebugEnabled) BOOL debugEnabled;
@end
```
打开debug模式,就能看到下图的扭曲空间
```
-(UIDynamicAnimator *)animator
{
if (!_animator) {
_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
[_animator setDebugEnabled:YES];
}
return _animator;
}
```
![扭曲空间](http://upload-images.jianshu.io/upload_images/1025705-856a7c933cead5a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点我下载代码(https://github.com/zhwe130205/CoreAnimationEffect)