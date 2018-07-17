//
//  SNSLCommentPhotoPreviewController.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSLCommentBaseViewController.h"
#import "SNSLCommentImagePickManager.h"

@interface SNSLCommentPhotoPreviewController : SNSLCommentBaseViewController

@property (nonatomic, strong) NSArray<SNSLCommentAssetModel *> *selectModels;

- (instancetype)initWithBackAction:(void(^)(void))Backaction;

@end
