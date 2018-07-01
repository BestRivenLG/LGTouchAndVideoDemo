//
//  TouchMoveViewController.m
//  videoDemo
//
//  Created by liangang zhan on 2018/7/1.
//  Copyright © 2018年 liangang zhan. All rights reserved.
//

#import "TouchMoveViewController.h"

@interface TouchMoveViewController (){
    CGPoint _point;
}
@property (nonatomic,strong) UIView *touchView;

@end

@implementation TouchMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"移动视图";
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake((size.width - 200)/2.0, size.height - 300 -100, 200, 300);
    CGPoint center = CGPointMake(rect.origin.x +(rect.size.width)/2.0, rect.origin.y+(rect.size.height)/2.0);
    //记录视图中心点;
    _point = center;
    for (int i=0; i<10; i++) {
        [self initViewWithFrame:rect];
    }
}

//初始化视图，添加拖动手势
- (void)initViewWithFrame:(CGRect) rect {
    UIView *touchView = [[UIView alloc]initWithFrame:rect];
    [self.view addSubview:touchView];
    
    int red = (arc4random() % 256) ;
    int green = (arc4random() % 256);
    int blue = (arc4random() % 256);
    
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)];
    [touchView addGestureRecognizer:pan];
    touchView.backgroundColor = color;
    touchView.layer.cornerRadius = 15.0;
    touchView.layer.masksToBounds = YES;
}

- (void)moveAction:(UIPanGestureRecognizer *)pan {
    //获取拖动的距离点
    CGPoint point = [pan translationInView:self.view];
    NSLog(@"%f,%f",point.x,point.y);
    
    //最后偏移的点
    CGPoint newCenter = CGPointMake(pan.view.center.x+point.x, pan.view.center.y+point.y);
    
    pan.view.center = newCenter;
    
    CGFloat x1 = newCenter.x - _point.x;
    CGFloat y1 = newCenter.y - _point.y;
    
    //范围取绝对值
    CGFloat x = fabs(newCenter.x - _point.x);
    CGFloat y = fabs(newCenter.y - _point.y);
    
    //约束范围
    CGFloat maxx = ([UIScreen mainScreen].bounds.size.width - 100)/2.0;
    CGFloat maxy = ([UIScreen mainScreen].bounds.size.height - 100);
    
    
    //拖拽距离范围判定
    if (x>maxx||y>maxy) {
        if (pan.state == UIGestureRecognizerStateEnded) {//拖拽手势结束
            CGPoint otherCenter = CGPointMake(newCenter.x+ x1, newCenter.y+y1);
            
            //动画 视图漂移界面最后移除视图
            [UIView animateWithDuration:1 animations:^{
                pan.view.center = otherCenter;
                
            } completion:^(BOOL finished) {
                [pan.view removeFromSuperview];
                NSLog(@"视图移除");
            }];
        }
        
    }else {
        if (pan.state == UIGestureRecognizerStateEnded) {//拖拽手势结束
            //动画返回原点
            [UIView animateWithDuration:1 animations:^{
                pan.view.center = self->_point;
            }];
        }
    }
    
    //重置视图位置点
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
