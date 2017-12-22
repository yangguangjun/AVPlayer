//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by 杨广军 on 2017/12/22.
//  Copyright © 2017年 杨广军. All rights reserved.
//

#import "ViewController.h"
#import "PlayView.h"
#import "FullViewController.h"

#define URL @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4"

@interface ViewController ()

@property (nonatomic, strong) PlayView *playView;
@property (nonatomic, assign) NSInteger playViewHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _playViewHeight = 180*self.view.bounds.size.width/320;
    PlayView *playView = [[PlayView alloc]init];
    playView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, _playViewHeight);
    playView.center = self.view.center;
    [playView.fullButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //本地视频
        NSString *path = [[NSBundle mainBundle] pathForResource:@"环保小视频.mp4" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
    //网络视频
//    NSURL *url = [NSURL URLWithString:URL];
    [playView updateVideoItem:url];
    [self.view addSubview:playView];
    self.playView = playView;
}

- (void)buttonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    FullViewController *fullVC = nil;
    
    __weak ViewController *vc = self;
    if (sender.isSelected) {
        if (fullVC == nil) {
            fullVC = [[FullViewController alloc]init];
            fullVC.playView = self.playView;
        }
        [self presentViewController:fullVC animated:YES completion:^{
            vc.playView.frame = fullVC.view.bounds;
            [fullVC.view addSubview:vc.playView];
        }];
    }
    
    fullVC.dismissAction = ^{
        vc.playView.bounds = CGRectMake(0, 0, self.view.bounds.size.height, _playViewHeight);
        vc.playView.center = CGPointMake(self.view.bounds.size.height/2, self.view.bounds.size.width/2);
        
        [vc.view addSubview:vc.playView];
    };
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
