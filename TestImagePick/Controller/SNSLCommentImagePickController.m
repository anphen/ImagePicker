//
//  SNSLCommentImagePickController.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentImagePickController.h"
#import "SNSLCommentPhotoPickController.h"

@interface SNSLCommentImagePickController ()

@property (nonatomic, copy) arrayBlock finishCallBack;
@property (nonatomic, strong) SNSLCommentPhotoPickController *photoVC;

@end

@implementation SNSLCommentImagePickController

- (void)dealloc{
    [SNSLCommentImagePickManager deallocManager];
}

- (instancetype)initWithSelectedImages:(NSArray<PHAsset *> *)selectedAssets maxPickCount:(NSInteger)maxPickCount finish:(arrayBlock)finishCallBack
{
    SNSLCommentPhotoPickController *photoPickVC = [[SNSLCommentPhotoPickController alloc]init];
    [PickManger checkAuthorizationStatus:^(BOOL authorization) {
        PickManger.maxPickCount = maxPickCount;
        [PickManger configSelectAssets:selectedAssets];
        if (authorization) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [photoPickVC configAuthorizationUI];
                [PickManger getAllPhotoComplete:^(SNSLCommentAlbumModel *model) {
                    [PickManger synchronizeAlbum:model];
                    photoPickVC.albumModel = model;
                }];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [photoPickVC showNoAuthorization];
            });
        }
    }];
    self = [super initWithRootViewController:photoPickVC];
    if (self) {
        self.finishCallBack = finishCallBack;
        self.photoVC = photoPickVC;
    }
    return self;
}

- (void)setImagePickDelegate:(id<SNSLCommentImagePickDelegate>)imagePickDelegate{
    _imagePickDelegate = imagePickDelegate;
    PickManger.imagePickDelegate = imagePickDelegate;
}

- (void)setFinishCallBack:(arrayBlock)finishCallBack{
    _finishCallBack = finishCallBack;
    PickManger.finishCallBack = finishCallBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
