//
//  SNSLCommentPhotoCell.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/6.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSLCommentAssetModel.h"

@interface SNSLCommentPhotoCell : UICollectionViewCell

@property (nonatomic, strong) SNSLCommentAssetModel *model;

@property (nonatomic, copy) void(^clickAction)(SNSLCommentPhotoCell *photoCell);

@property (nonatomic, assign) BOOL selectState;

@property (nonatomic, assign) NSInteger selectIndex;

- (void)configCellWithAsset:(SNSLCommentAssetModel *)model;

+ (NSString *)cellIdentifier;

@end
