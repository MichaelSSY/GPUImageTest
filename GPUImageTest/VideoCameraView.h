//
//  VideoCameraView.h
//  GPUImageTest
//
//  Created by weiyun on 2018/1/30.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage.h>
#import "Tool.h"

@interface VideoCameraView : UIView<CAAnimationDelegate>
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    NSString *pathToMovie;
    GPUImageView *filteredVideoView;
    CALayer *_focusLayer;
    NSTimer *myTimer;
    UILabel *timeLabel;
    NSDate *fromdate;
}

@end
