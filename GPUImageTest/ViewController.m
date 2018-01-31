//
//  ViewController.m
//  GPUImageTest
//
//  Created by weiyun on 2018/1/29.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "ViewController.h"
#import "FilterCameraViewController.h"
#import "VideoRecoderViewController.h"
#import "ImageFilterViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSArray *sourceArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GPUImage";
    self.sourceArray  =@[@"美颜相机",@"录制视频",@"图片处理"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.rowHeight = 60;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.sourceArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    if (indexPath.row == 0) {
        vc = [[FilterCameraViewController alloc] init];
    }else if(indexPath.row == 1){
        vc = [[VideoRecoderViewController alloc] init];
    }else if (indexPath.row == 2){
        vc = [[ImageFilterViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
