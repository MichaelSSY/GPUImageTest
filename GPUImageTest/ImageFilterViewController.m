//
//  ImageFilterViewController.m
//  GPUImageTest
//
//  Created by weiyun on 2018/1/30.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "ImageFilterViewController.h"
#import <Masonry.h>
#import <GPUImage.h>
#import "Tool.h"
#import "GPUImageBeautifyFilter.h"

@interface ImageFilterViewController ()
{
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageFilterPipeline *pipeline;
    GPUImageFilterGroup *filterGroup;
}

@property (nonatomic , strong) UIImageView *imageView1;
@property (nonatomic , strong) UIImageView *imageView2;

@property (nonatomic , strong) GPUImagePicture *sourcePicture;
@property (nonatomic , strong) GPUImageTiltShiftFilter *sepiaFilter;

@end

@implementation ImageFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片滤镜";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test1];
}
/**
 *  单个滤镜使用
 */
- (void)test5{
    UIImage * image = [UIImage imageNamed:@"333"];
    
    _imageView1 = [[UIImageView alloc] initWithFrame:self.view.frame];
    _imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imageView1];
    
    _sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:_imageView1.frame];
    [_imageView1 addSubview:imageView];
    
    GPUImageSepiaFilter *f = [[GPUImageSepiaFilter alloc] init];
    [_sourcePicture addTarget:f];
    
    [_sourcePicture processImage];
    [f useNextFrameForImageCapture];
    
    image = [f imageFromCurrentFramebuffer];
    
    self.imageView1.image = image;
}

/**
 *  多个滤镜一起使用
 */
- (void)test4
{
    UIImage * image = [UIImage imageNamed:@"333"];
    
    _imageView1 = [[UIImageView alloc] initWithFrame:self.view.frame];
    _imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imageView1];

    _sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:_imageView1.frame];
    [_imageView1 addSubview:imageView];
    
    filterGroup = [[GPUImageFilterGroup alloc] init];
    [_sourcePicture addTarget:filterGroup];
    
    GPUImageSepiaFilter *f = [[GPUImageSepiaFilter alloc] init];
    
    GPUImageBrightnessFilter *imageFilter = [[GPUImageBrightnessFilter alloc] init];
    filter = imageFilter;
    
    [self addGPUImageFilter:f];
    [self addGPUImageFilter:imageFilter];
        
    // 处理图片
    [_sourcePicture processImage];
    [filterGroup useNextFrameForImageCapture];
    
    self.imageView1.image = [filterGroup imageFromCurrentFramebuffer];
    
    
    
    
    [self addSlider];
}
// 添加 filter
/**
 原理：
 1. filterGroup(addFilter) 滤镜组添加每个滤镜
 2. 按添加顺序（可自行调整）前一个filter(addTarget) 添加后一个filter
 3. filterGroup.initialFilters = @[第一个filter]];
 4. filterGroup.terminalFilter = 最后一个filter;
 
 */
- (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filter
{
    [filterGroup addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    
    NSInteger count = filterGroup.filterCount;
    
    if (count == 1)
    {
        filterGroup.initialFilters = @[newTerminalFilter];
        filterGroup.terminalFilter = newTerminalFilter;
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    = filterGroup.terminalFilter;
        NSArray *initialFilters                          = filterGroup.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];
        
        filterGroup.initialFilters = @[initialFilters[0]];
        filterGroup.terminalFilter = newTerminalFilter;
    }
}


- (void)test3
{
    [self addImageView];
    UIImage *image = [UIImage imageNamed:@"111"];
    self.imageView1.image = image;
    
    /**
     磨皮效果
     */
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    // 磨皮滤镜
    GPUImageBilateralFilter *filter = [[GPUImageBilateralFilter alloc] init];
    // 设置磨皮参数
    [filter setDistanceNormalizationFactor:3];
    [filter forceProcessingAtSize:image.size];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    image = [filter imageFromCurrentFramebuffer];
    
    self.imageView2.image = image;
    
    [self editPhotoByBrightnessWithLevel:0.1];
    
    // 哎呀妈呀，这个人太难美白了！！
}

//美白
- (void)editPhotoByBrightnessWithLevel:(CGFloat)level {

    UIImage *image = self.imageView2.image;

    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];

    // 美白滤镜
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];

    //设置美白参数
    filter.brightness = level;

    [filter forceProcessingAtSize:image.size];

    [pic addTarget:filter];

    [pic processImage];

    [filter useNextFrameForImageCapture];

    image = [filter imageFromCurrentFramebuffer];

    self.imageView2.image = image;

}


/**
 *  图片模糊处理
 */
- (void)test2
{
    GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.view = primaryView;
    
    UIImage *inputImage = [UIImage imageNamed:@"333"];
    
    _sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    _sepiaFilter = [[GPUImageTiltShiftFilter alloc] init];
    // 这个值越大越模糊
    _sepiaFilter.blurRadiusInPixels = 30.0;
    //_sepiaFilter.bottomFocusLevel = 1.0;
    //_sepiaFilter.topFocusLevel = 0.0;
    //_sepiaFilter.focusFallOffRate = 0.5;
    [_sepiaFilter forceProcessingAtSize:primaryView.sizeInPixels];
    
    [_sourcePicture addTarget:_sepiaFilter];
    [_sepiaFilter addTarget:primaryView];
    [_sourcePicture processImage];
    
    
    // GPUImageContext相关的数据显示
    GLint size = [GPUImageContext maximumTextureSizeForThisDevice];
    GLint unit = [GPUImageContext maximumTextureUnitsForThisDevice];
    GLint vector = [GPUImageContext maximumVaryingVectorsForThisDevice];
    NSLog(@"%d %d %d", size, unit, vector);
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    float rate = point.y / self.view.frame.size.height;
    NSLog(@"Processing");
    [_sepiaFilter setTopFocusLevel:rate - 0.1];
    [_sepiaFilter setBottomFocusLevel:rate + 0.1];
    [_sourcePicture processImage];
}

/**
 *  简单的图片加滤镜效果
 */
- (void)test1
{
    // GPUImageFilter 集成自 GPUImageOutput

    // GPUImageSepiaFilter：图像棕褐色滤镜
    // GPUImageStretchDistortionFilter：图像拉伸失真滤镜 （这个有意思）
    // GPUImageSmoothToonFilter：图像光滑香椿滤镜
    // GPUImageBrightnessFilter：图像亮度滤镜，范围[-1,1]， -1就是黑色的，1就是白色的了
    // GPUImageSketchFilter：黑白照滤镜
    // .....
    
    GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.view = primaryView;
    
    UIImage *image = [UIImage imageNamed:@"333"];

    _sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];

    GPUImageSepiaFilter *f = [[GPUImageSepiaFilter alloc] init];
    //[_sourcePicture addTarget:f];
    
    GPUImageBrightnessFilter *imageFilter = [[GPUImageBrightnessFilter alloc] init];
    filter = imageFilter;
    //[_sourcePicture addTarget:imageFilter];
    //[imageFilter addTarget:primaryView];

    pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:@[f,imageFilter] input:_sourcePicture output:primaryView];
    
    [_sourcePicture processImage];

    //self.imageView1.image = [imageFilter imageByFilteringImage:image];
    
    [self addSlider];
}

- (void)addSlider
{
    UISlider *filterSettingsSlider = [[UISlider alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT-50, SCREEN_WIDTH - 50, 40)];
    [filterSettingsSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    filterSettingsSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    filterSettingsSlider.minimumValue = -1.0;
    filterSettingsSlider.maximumValue = 1.0;
    filterSettingsSlider.value = 0.0;
    [self.view addSubview:filterSettingsSlider];
}

- (void)updateSliderValue:(UISlider *)slider
{
    [(GPUImageBrightnessFilter *)filter setBrightness:slider.value];
    
    //[pipeline.filters.lastObject useNextFrameForImageCapture];
    [_sourcePicture processImage];
    
    //[filterGroup useNextFrameForImageCapture];
   // self.imageView1.image = [filterGroup imageFromCurrentFramebuffer];
    
//    UIImage *image = [UIImage imageNamed:@"333"];
//    if (image) {
//        self.imageView1.image = [filter imageByFilteringImage:image];
//    }
}

- (void)addImageView
{
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@200);
        make.width.equalTo(@120);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.top.equalTo(self.view.mas_top).offset(80);
    }];
    self.imageView1 = imageView1;
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@200);
        make.width.equalTo(@120);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.top.equalTo(self.view.mas_top).offset(80);
    }];
    self.imageView2 = imageView2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

@end
