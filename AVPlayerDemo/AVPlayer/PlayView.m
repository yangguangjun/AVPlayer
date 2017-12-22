//
//  PlayView.m
//  Demo
//
//  Created by 杨广军 on 2017/8/22.
//  Copyright © 2017年 杨广军. All rights reserved.
//

#import "PlayView.h"

@interface PlayView()
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NSTimer *progressTimer;
@end

@implementation PlayView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlayView" owner:nil options:nil] firstObject];
        
        self.player = [[AVPlayer alloc]init];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        self.playerLayer = layer;
        [self.imageView.layer addSublayer:layer];
        
        [self.onOrOffButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [self.progressSlider addTarget:self action:@selector(progressAction:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    return self;
    
}

- (void)layoutSubviews{ 
    [super layoutSubviews];
    _playerLayer.frame = self.imageView.bounds;
}
//更新视频资源
- (void)updateVideoItem:(NSURL *)url{
    
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    [self addObserver];
    [self createProgressTimer];
}

- (void)addObserver{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
        if (status == AVPlayerStatusReadyToPlay) {
            [self.player play];
        }
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *arr = [change objectForKey:@"new"];
        //缓冲进度，目前没研究出来
        
       
        
    }
    
}
//暂停开始
- (void)playAction{
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self.player pause];
    }else if (self.player.timeControlStatus == AVPlayerTimeControlStatusPaused){
        [self.player play];
    }
}
//拖拽到某个时间播放
- (void)progressAction:(UISlider *)slider{
   CMTime changeTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.playerItem.duration)*slider.value, 1.0);
    [self.player pause];
    [self.player seekToTime:changeTime completionHandler:^(BOOL finished) {
        if (finished) {
            [self.player play];
        }
    }];
    
}
//创建定时器，加载播放进度
- (void)createProgressTimer{
    if ([_progressTimer isValid]) {
        [_progressTimer invalidate];
    }
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(calculateProgress) userInfo:nil repeats:YES];
}
//计算播放进度和时间
- (void)calculateProgress{
    CGFloat currentTime = CMTimeGetSeconds(self.playerItem.currentTime);
    CGFloat totalTime = CMTimeGetSeconds(self.playerItem.duration);
    CGFloat value = currentTime/totalTime;
    self.progressSlider.value = value;
    
    NSString *currentTimeStr = [self calculateTimeWithTime:currentTime];
    NSString *totalTimeStr = [self calculateTimeWithTime:totalTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",currentTimeStr,totalTimeStr];
}
//计算时间进度
- (NSString *)calculateTimeWithTime:(CGFloat)time{
    NSString *timeStr = nil;
    int H = 0;
    int M = 0;
    int S = 0;
    if (time >= 60.0 && time < 3600) {
       
        M = (int)time/60;
        S = (int)time%60;
    }else if (time >= 3600.0){
        H = (int)time/3600;
        M = (int)(time - H*3600)/60;
        S = (int)(time - H*3600)%60;
    }else{
        S = (int)time;
    }
   
    if (H != 0) {
        if (M >= 10 && S >= 10) {
            timeStr = [NSString stringWithFormat:@"%d:%d:%d",H,M,S];
        }else if(M < 10 && S < 10){
            timeStr = [NSString stringWithFormat:@"%d:0%d:0%d",H,M,S];
        }else if (M < 10 && S >= 10){
            timeStr = [NSString stringWithFormat:@"%d:0%d:%d",H,M,S];
        }else if (M >= 10 && S < 10){
            timeStr = [NSString stringWithFormat:@"%d:%d:0%d",H,M,S];
        }
    }else if(H == 0 && M != 0){
        if (S >= 10) {
            timeStr = [NSString stringWithFormat:@"%d:%d",M,S];
        }else {
            timeStr = [NSString stringWithFormat:@"%d:0%d",M,S];
        }
    }else{
        if (S >= 10) {
            timeStr = [NSString stringWithFormat:@"%d",S];
        }else {
            timeStr = [NSString stringWithFormat:@"0%d",S];
        }
    }
    return timeStr;
}

- (void)dealloc{
    
    NSLog(@"-----------playViewDealloc-------------");
    [_progressTimer invalidate];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
