//
//  SNSLCommentAlbumController.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSLCommentBaseViewController.h"
#import "SNSLCommentAlbumCell.h"

@protocol SNSLCommentAlbumControllerDelegate <NSObject>

- (void)clickAlbum:(SNSLCommentAlbumModel *)album;

@end

@interface SNSLCommentAlbumController : SNSLCommentBaseViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray<SNSLCommentAlbumModel *> * albums;

@property (nonatomic, weak) id<SNSLCommentAlbumControllerDelegate> delegate;

@end
