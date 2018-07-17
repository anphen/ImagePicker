//
//  SNSLCommentPhotoPickController.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSLCommentBaseViewController.h"
#import "SNSLCommentAssetModel.h"

@interface SNSLCommentPhotoPickController : SNSLCommentBaseViewController

@property (nonatomic, strong) SNSLCommentAlbumModel *albumModel;

- (void)showNoAuthorization;

- (void)hiddenNoAuthorization;

- (void)configAuthorizationUI;

@end
