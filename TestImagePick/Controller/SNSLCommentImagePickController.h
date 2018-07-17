//
//  SNSLCommentImagePickController.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSLCommentNavigationController.h"
#import "SNSLCommentImagePickManager.h"

@interface SNSLCommentImagePickController : SNSLCommentNavigationController

@property (nonatomic, weak) id<SNSLCommentImagePickDelegate> imagePickDelegate;

- (instancetype)initWithSelectedImages:(NSArray<PHAsset *> *)selectedAssets maxPickCount:(NSInteger)maxPickCount finish:(arrayBlock)finishCallBack;

@end
