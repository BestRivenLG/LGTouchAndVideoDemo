//
//  ViewController.m
//  TouchAndVideoDemo
//
//  Created by liangang zhan on 2018/7/1.
//  Copyright © 2018年 liangang zhan. All rights reserved.
//

#import "ViewController.h"
#import "TouchMoveViewController.h"
#import "PlayerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)touchMoveAction:(id)sender {
    TouchMoveViewController *vc = [[TouchMoveViewController alloc] init];
    vc.title = @"移动视图";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)singleVideoLoadAction:(id)sender {
    PlayerViewController *vc = [[PlayerViewController alloc] init];
    vc.isSingle = YES;
    vc.title = @"单个视频播放";

    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)videoListLoadAction:(id)sender {
    PlayerViewController *vc = [[PlayerViewController alloc] init];
    vc.isSingle = NO;
    vc.title = @"视频列表播放";
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
