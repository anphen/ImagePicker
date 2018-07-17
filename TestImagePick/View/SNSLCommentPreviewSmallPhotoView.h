//
//  SNSLCommentPreviewSmallPhotoView.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/8.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSLCommentAssetModel.h"

@interface SNSLCommentPreviewSmallPhotoView : UIView

@property (nonatomic, copy) void(^clickAction)(NSInteger index);

@property (nonatomic, strong) NSArray<SNSLCommentAssetModel *> *selectModels;

@property (nonatomic, assign) NSInteger currentSelectIndex;

- (void)relodIndexPath:(NSIndexPath *)indexPath;

@end
