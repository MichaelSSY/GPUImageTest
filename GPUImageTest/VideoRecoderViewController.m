//
//  VideoRecoderViewController.m
//  GPUImageTest
//
//  Created by weiyun on 2018/1/30.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "VideoRecoderViewController.h"
#import "VideoCameraView.h"

@interface VideoRecoderViewController ()

@end

@implementation VideoRecoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VideoCameraView *view = [[VideoCameraView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
