//
//  ViewController.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "ViewController.h"
#import "SNSLCommentImagePickController.h"
#import <Masonry.h>

@interface ViewController ()<SNSLCommentImagePickDelegate>

@property (nonatomic, strong) NSArray *seletAssert;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"选择照片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pickImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}

- (void)pickImg{
    __weak typeof(self)weakSelf = self;
    SNSLCommentImagePickController *pickVC = [[SNSLCommentImagePickController alloc]initWithSelectedImages:self.seletAssert maxPickCount:5 finish:^(NSArray *selectAssets) {
        weakSelf.seletAssert = selectAssets;
    }];
    pickVC.imagePickDelegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
