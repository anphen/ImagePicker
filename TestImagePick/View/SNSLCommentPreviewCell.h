//
//  SNSLCommentPreviewCell.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/8.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSLCommentImagePickManager.h"

typedef NS_ENUM(NSUInteger, SNSLCommentPreviewCellType) {
    SNSLCommentPreviewCellTypeBig = 0,
    SNSLCommentPreviewCellTypeSmall
};

@interface SNSLCommentPreviewCell : UICollectionViewCell

@property (nonatomic, copy) void(^clickAction)(SNSLCommentPreviewCell *photoCell);

@property (nonatomic, copy) void(^singleTapAction)(SNSLCommentPreviewCell *photoCell);

@property (nonatomic, strong) SNSLCommentAssetModel *model;

@property (nonatomic, assign) SNSLCommentPreviewCellType cellType;

@property (nonatomic, assign) BOOL selectState;

@property (nonatomic, assign) BOOL isStroke;

@property (nonatomic, assign) BOOL isFullScreen;

- (void)configCellWithAsset:(SNSLCommentAssetModel *)model;

+ (NSString *)cellIdentifierWithType:(SNSLCommentPreviewCellType)cellType;

@end
