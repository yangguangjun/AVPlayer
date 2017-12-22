//
//  PlayView.h
//  Demo
//
//  Created by 杨广军 on 2017/8/22.
//  Copyright © 2017年 杨广军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *onOrOffButton;
@property (weak, nonatomic) IBOutlet UIButton *fullButton;

@property (nonatomic, strong) AVPlayer *player;

- (void)updateVideoItem:(NSURL *)url;

@end
