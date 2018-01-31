//
//  FilterCameraViewController.m
//  GPUImageTest
//
//  Created by weiyun on 2018/1/30.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "FilterCameraViewController.h"
#import <GPUImage.h>
#import <Masonry.h>
#import "GPUImageBeautifyFilter.h"
#import "Tool.h"

@interface FilterCameraViewController ()
{
    UIButton *takePhotoBtn;
}
@property (nonatomic, strong) GPUImageStillCamera *stillCamera; ///< 捕获和过滤静态照片
@property (nonatomic, strong) GPUImageView *filterView; ///< 展示camera的view
@property (nonatomic, strong) GPUImageFilter *filter;/// < 滤镜
@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;
@property (nonatomic, strong) UIButton *beautifyButton;
@property (nonatomic , assign) BOOL isBeautify;
@property (nonatomic , assign) BOOL isBack;
@property (nonatomic , strong) GPUImageOutput<GPUImageInput> *outPut;

@end

@implementation FilterCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test
{
    self.isBeautify = NO;
    self.isBack = NO;
    
    // 1.创建相机
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    // 镜像效果，前置摄像头需要，后置摄像头不出要，不然看到的是反的
    self.stillCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    // 2.创建设置滤镜效果
    //self.filter = [[GPUImageSketchFilter alloc] init]; // 黑白滤镜效果
    self.filter = [[GPUImageGammaFilter alloc] init];
    self.outPut = self.filter;
    
    // 3.创建展示相机的视图
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.filterView.center = self.view.center;
    [self.view addSubview:self.filterView];
    
    // 4.这里一定要注意 一定要先加滤镜->在加视图->然后吧camera开始获取视频图像
    [self.stillCamera addTarget:self.filter];
    [self.filter addTarget:self.filterView];
    
    // 5.开始获取视频
    [self.stillCamera startCameraCapture];
    
    
    self.beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beautifyButton.backgroundColor = [UIColor whiteColor];
    self.beautifyButton.layer.cornerRadius = 20;
    self.beautifyButton.clipsToBounds = YES;
    [self.beautifyButton setTitle:@"开启" forState:UIControlStateNormal];
    [self.beautifyButton setTitle:@"关闭" forState:UIControlStateSelected];
    [self.beautifyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.beautifyButton addTarget:self action:@selector(beautify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beautifyButton];
    [self.beautifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.left.equalTo(self.view.mas_left).offset(40);
    }];
    
    //按钮拍照
    takePhotoBtn = [[UIButton alloc]init];
    takePhotoBtn.backgroundColor = [UIColor whiteColor];
    takePhotoBtn.layer.cornerRadius = 20;
    takePhotoBtn.clipsToBounds = YES;
    [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhotoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:takePhotoBtn];
    [takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.right.equalTo(self.view.mas_right).offset(-40);
    }];
    [takePhotoBtn addTarget:self action:@selector(takePhotoToAlbum) forControlEvents:UIControlEventTouchUpInside];
}

- (void)takePhotoToAlbum
{
    [takePhotoBtn setEnabled:NO];
    
    [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.outPut withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        UIImage *image = [UIImage imageWithData:processedJPEG];
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [takePhotoBtn setEnabled:YES];
        if(error == NULL){
            [MBProgressHUD showSuccessWithText:@"已保存"];
        }else{
            [MBProgressHUD showErrorWithText:@"保存失败"];
        }
    });
}

- (void)beautify {
    self.isBeautify = !self.isBeautify;
    
    if (self.isBeautify == NO) {
        self.beautifyButton.selected = NO;
        [self.stillCamera removeAllTargets];
        
        self.outPut = self.filter;
    }
    else {
        self.beautifyButton.selected = YES;
        [self.stillCamera removeAllTargets];
        
        self.outPut = self.beautifyFilter;
    }
    
    [self.stillCamera addTarget:self.outPut];
    [self.outPut addTarget:self.filterView];
}

- (GPUImageBeautifyFilter *)beautifyFilter
{
    if (_beautifyFilter == nil) {
        _beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    }
    return _beautifyFilter;
}

- (void)dealloc
{
    NSLog(@"释了");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
