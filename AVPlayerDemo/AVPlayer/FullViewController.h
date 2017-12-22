//
//  FullViewController.h
//  Demo
//
//  Created by 杨广军 on 2017/8/22.
//  Copyright © 2017年 杨广军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayView.h"

@interface FullViewController : UIViewController

@property (nonatomic, strong) PlayView *playView;
@property (nonatomic, copy) void(^dismissAction)();

@end
