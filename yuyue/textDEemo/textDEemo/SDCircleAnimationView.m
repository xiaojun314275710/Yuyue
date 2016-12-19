//
//  SDCircleAnimationView.m
//  textDEemo
//
//  Created by 邹少军 on 16/8/16.
//  Copyright © 2016年 chengdian. All rights reserved.
//


#define MAX_RADIUS 10

#import "SDCircleAnimationView.h"

@implementation SDCircleAnimationView
{
    CADisplayLink *_displayLink;//CADisplayLink 可以确保系统渲染每一帧的时候我们的方法都被调用，从而保证了动画的流畅性。毫秒级动画就靠它
    UIBezierPath *_path; //用于创建基于矢量的路径
    CGPoint _beginPoint; //开始触摸的位置
    CGPoint _endPoint; //触摸结束的位置
    CAShapeLayer *_shapeLayer; //可以结合UIBezierPath进行绘画；

    BOOL _isTouchEnd; //触摸结束
    int _currentFrame; //当前的帧数
    

}

//接着初始化实例变量，由于我们用的是storyboard进行加载，所以可以在awakeFromNib方法里面初始化

#pragma  mark -- xib加载当前view --
-(void)awakeFromNib
{
    _shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_shapeLayer];
    _shapeLayer.fillColor = [[UIColor colorWithRed:154/255.0 green:204/255.0 blue:18/255.0 alpha:1.0] CGColor];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updataFrame)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    

}


//接下来实现上面CADisplayLink要不停调用的updateFrame方法，我们在此方法内不断地画圆。

- (void)updataFrame
{
    //画圈
    _path = [UIBezierPath bezierPathWithArcCenter:_beginPoint radius:[self getRadius] startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    _shapeLayer.path = _path.CGPath;
    

}

//上面我们用开始触摸的点的位置作为圆心的位置，再根据特定的半径进行绘制一个圆，这个半径是根据我们触摸的开始点和结束点进行计算出来的，开始触摸点到结束点的距离就是这个圆的半径。
//我们先把触摸的起始和结束点给找到：


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _beginPoint = point;
    _endPoint = point;
    
    _isTouchEnd = NO;
    _currentFrame = 1;
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _endPoint = point;
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    _isTouchEnd = YES; // 触摸结束更新触摸状态
    
}


//最后计算用上我们中学的数学知识，根据两点坐标距离公式
//两点坐标距离公式
//可以得到我们起始和结束两点的距离，也就是圆的半径是：

- (CGFloat)getRadius
{
    
    CGFloat result = sqrt(pow(_endPoint.x - _beginPoint.x, 2) + pow(_endPoint.y - _beginPoint.y, 2));
    
    if (_isTouchEnd) {
        
        CGFloat animationDuration = 1.0; // 弹簧动画持续时间
        int maxFrames = animationDuration / _displayLink.duration;
        _currentFrame++;
        
        if (_currentFrame <= maxFrames) {
            CGFloat factor = [self getSpringInterpolation:(CGFloat)(_currentFrame) / (CGFloat)(maxFrames)];//根据公式计算出弹簧因子
            return MAX_RADIUS + (result - MAX_RADIUS) * factor; // 根据弹簧因子计算当前帧的圆半径
        }else
        {
            return MAX_RADIUS;
        }
        
        
    }
    
    
    return result;
    
    
}


- (CGFloat)getSpringInterpolation:(CGFloat)x
{
    CGFloat tension = 0.3; // 张力系数
    return pow(2, -10 * x) * sin((x - tension / 4) * (2 * M_PI) / tension);
}


//到这里画圆动画完成。

//加入弹性效果
//上面只是的画圆动画看起来是没什么问题了，不过总感觉缺少动感，接下来我们来帮他加入些活力！



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
